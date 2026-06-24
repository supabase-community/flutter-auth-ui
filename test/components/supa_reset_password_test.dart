import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

import '../test_utils.dart';

void main() {
  setUpAll(initializeSupabaseForTest);
  setUp(() => testServer.reset());
  tearDown(signOutTestUser);

  Widget buildForm({
    void Function(UserResponse response)? onSuccess,
    void Function(Object error)? onError,
    bool showSnackBars = true,
  }) {
    return wrapForTest(
      SupaResetPassword(
        onSuccess: onSuccess ?? (_) {},
        onError: onError,
        showSnackBars: showSnackBars,
      ),
    );
  }

  testWidgets('renders the password field and update button', (tester) async {
    await tester.pumpWidget(buildForm());

    expect(find.text('Enter your password'), findsOneWidget);
    expect(
      find.widgetWithText(ElevatedButton, 'Update Password'),
      findsOneWidget,
    );
  });

  testWidgets('shows an error for a too short password', (tester) async {
    await tester.pumpWidget(buildForm());

    await tester.enterText(find.byType(TextFormField), '123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Update Password'));
    await tester.pump();

    expect(
      find.text('Please enter a password that is at least 6 characters long'),
      findsOneWidget,
    );
  });

  testWidgets('updates the password and reports success', (tester) async {
    await signInTestUser();
    UserResponse? response;
    await tester.pumpWidget(buildForm(onSuccess: (r) => response = r));

    await tester.enterText(find.byType(TextFormField), 'newpassword');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Update Password'));
    await tester.pumpAndSettle();

    expect(response, isNotNull);
    expect(testServer.lastRequest!.method, 'PUT');
    expect(testServer.lastRequest!.url.path, endsWith('/user'));
    expect(find.text('Password reset email has been sent'), findsOneWidget);
  });

  testWidgets('forwards an error to onError when the update fails', (
    tester,
  ) async {
    await signInTestUser();
    Object? captured;
    await tester.pumpWidget(buildForm(onError: (e) => captured = e));
    testServer.responder = (_) => errorResponse('Update failed');

    await tester.enterText(find.byType(TextFormField), 'newpassword');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Update Password'));
    await tester.pumpAndSettle();

    expect(captured, isA<AuthException>());
  });
}
