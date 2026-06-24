import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

/// In-memory implementation of [GotrueAsyncStorage] so the PKCE storage never
/// reaches for shared preferences during tests.
class _InMemoryAsyncStorage extends GotrueAsyncStorage {
  final _store = <String, String>{};

  @override
  Future<String?> getItem({required String key}) async => _store[key];

  @override
  Future<void> setItem({required String key, required String value}) async {
    _store[key] = value;
  }

  @override
  Future<void> removeItem({required String key}) async {
    _store.remove(key);
  }
}

/// Signature for a function that turns an intercepted request into a response.
typedef MockResponder = http.Response Function(http.Request request);

/// Records every request the Supabase client makes and lets each test swap in
/// the response it wants to assert against.
class SupabaseTestServer {
  SupabaseTestServer();

  final List<http.Request> requests = [];

  /// The responder used for the next requests. Defaults to returning a valid
  /// session for any auth endpoint.
  MockResponder responder = defaultResponder;

  http.Client get client => MockClient((request) async {
    requests.add(request);
    return responder(request);
  });

  void reset() {
    requests.clear();
    responder = defaultResponder;
  }

  http.Request? get lastRequest => requests.isEmpty ? null : requests.last;

  /// Returns the parsed JSON body of the last request, or `{}` when there was
  /// no body.
  Map<String, dynamic> get lastBody {
    final body = lastRequest?.body ?? '';
    if (body.isEmpty) return {};
    return jsonDecode(body) as Map<String, dynamic>;
  }
}

const _fakeUser = {
  'id': '11111111-1111-1111-1111-111111111111',
  'aud': 'authenticated',
  'role': 'authenticated',
  'email': 'test@example.com',
  'app_metadata': {'provider': 'email'},
  'user_metadata': <String, dynamic>{},
  'created_at': '2024-01-01T00:00:00.000Z',
  'is_anonymous': false,
};

final _fakeSession = {
  'access_token': 'fake-access-token',
  'token_type': 'bearer',
  'expires_in': 3600,
  'refresh_token': 'fake-refresh-token',
  'user': _fakeUser,
};

/// Builds a success response with a full session for any auth endpoint.
http.Response sessionResponse() => http.Response(
  jsonEncode(_fakeSession),
  200,
  headers: {'content-type': 'application/json'},
);

/// Builds a success response containing just a user (no session).
http.Response userResponse() => http.Response(
  jsonEncode(_fakeUser),
  200,
  headers: {'content-type': 'application/json'},
);

/// Builds an error response that gotrue parses into an [AuthApiException].
http.Response errorResponse(
  String message, {
  int statusCode = 400,
  String? code,
}) => http.Response(
  jsonEncode({
    'message': message,
    if (code != null) 'error_code': code,
  }),
  statusCode,
  headers: {'content-type': 'application/json'},
);

/// Default responder used between tests.
///
/// `recover` and `otp` endpoints return an empty body, everything else returns
/// a session.
http.Response defaultResponder(http.Request request) {
  final path = request.url.path;
  if (path.endsWith('/recover') || path.endsWith('/otp')) {
    return http.Response(
      '{}',
      200,
      headers: {'content-type': 'application/json'},
    );
  }
  if (path.endsWith('/user') && request.method == 'GET') {
    return userResponse();
  }
  return sessionResponse();
}

/// Shared server instance for the running test isolate.
late final SupabaseTestServer testServer;

/// Initializes Supabase once per test isolate, wiring up the mock HTTP client
/// and in-memory storage so no real network or platform calls are made.
Future<void> initializeSupabaseForTest() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  testServer = SupabaseTestServer();
  await Supabase.initialize(
    url: 'http://localhost:54321',
    publishableKey: 'test-anon-key',
    debug: false,
    httpClient: testServer.client,
    authOptions: FlutterAuthClientOptions(
      localStorage: const EmptyLocalStorage(),
      pkceAsyncStorage: _InMemoryAsyncStorage(),
      detectSessionInUri: false,
      autoRefreshToken: false,
    ),
  );
}

/// Wraps [child] in a minimal [MaterialApp] so it has the inherited widgets it
/// needs (theme, directionality, scaffold for snack bars).
Widget wrapForTest(Widget child) {
  return MaterialApp(
    localizationsDelegates: SupabaseAuthUILocalizations.localizationsDelegates,
    supportedLocales: SupabaseAuthUILocalizations.supportedLocales,
    home: Scaffold(
      body: SingleChildScrollView(child: child),
    ),
  );
}

/// Like [wrapForTest] but exposes [arguments] through the route so widgets that
/// read `ModalRoute.of(context)?.settings.arguments` receive them.
Widget wrapWithRouteArguments(Widget child, Object? arguments) {
  return MaterialApp(
    localizationsDelegates: SupabaseAuthUILocalizations.localizationsDelegates,
    supportedLocales: SupabaseAuthUILocalizations.supportedLocales,
    onGenerateRoute: (settings) => MaterialPageRoute(
      settings: RouteSettings(name: settings.name, arguments: arguments),
      builder: (_) => Scaffold(
        body: SingleChildScrollView(child: child),
      ),
    ),
  );
}

/// Signs a fake user in so endpoints that require an active session (such as
/// `updateUser`) succeed. Call [signOutTestUser] afterwards to clean up.
Future<void> signInTestUser() async {
  testServer.responder = (_) => sessionResponse();
  await Supabase.instance.client.auth.signInWithPassword(
    email: 'test@example.com',
    password: 'password123',
  );
}

/// Clears the current session so it does not leak into the next test.
///
/// Restores the default responder first so the sign-out request is not tripped
/// up by a responder a test swapped in to simulate a failure.
Future<void> signOutTestUser() async {
  testServer.responder = defaultResponder;
  try {
    await Supabase.instance.client.auth.signOut(scope: SignOutScope.local);
  } catch (_) {
    // The session may already be gone; nothing else to clean up.
  }
}
