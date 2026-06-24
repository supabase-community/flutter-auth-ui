import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

import '../test_utils.dart';

void main() {
  setUpAll(initializeSupabaseForTest);
  setUp(() => testServer.reset());

  Widget buildForm({
    required SupaAuthAction authAction,
    void Function(AuthResponse response)? onSuccess,
    void Function(Object error)? onError,
    bool showSnackBars = true,
  }) {
    return wrapForTest(
      SupaPhoneAuth(
        authAction: authAction,
        onSuccess: onSuccess ?? (_) {},
        onError: onError,
        showSnackBars: showSnackBars,
      ),
    );
  }

  testWidgets('renders phone and password fields with the sign in label', (
    tester,
  ) async {
    await tester.pumpWidget(buildForm(authAction: SupaAuthAction.signIn));

    expect(find.text('Enter your phone number'), findsOneWidget);
    expect(find.text('Enter your password'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Sign In'), findsOneWidget);
  });

  testWidgets('shows the sign up label for the sign up action', (tester) async {
    await tester.pumpWidget(buildForm(authAction: SupaAuthAction.signUp));

    expect(find.widgetWithText(ElevatedButton, 'Sign Up'), findsOneWidget);
  });

  testWidgets('shows an error for an empty phone number', (tester) async {
    await tester.pumpWidget(buildForm(authAction: SupaAuthAction.signIn));

    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
    await tester.pump();

    expect(find.text('Please enter a valid phone number'), findsOneWidget);
    expect(testServer.requests, isEmpty);
  });

  testWidgets('shows an error for a too short password', (tester) async {
    await tester.pumpWidget(buildForm(authAction: SupaAuthAction.signIn));

    await tester.enterText(find.byType(TextFormField).first, '+15551234567');
    await tester.enterText(find.byType(TextFormField).at(1), '123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
    await tester.pump();

    expect(
      find.text('Please enter a password that is at least 6 characters long'),
      findsOneWidget,
    );
  });

  testWidgets('signs in with phone and password and reports success', (
    tester,
  ) async {
    AuthResponse? response;
    await tester.pumpWidget(
      buildForm(
        authAction: SupaAuthAction.signIn,
        onSuccess: (r) => response = r,
      ),
    );

    await tester.enterText(find.byType(TextFormField).first, '+15551234567');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
    await tester.pumpAndSettle();

    expect(response, isNotNull);
    expect(testServer.lastBody['phone'], '+15551234567');
  });

  testWidgets('signs up with phone and password', (tester) async {
    AuthResponse? response;
    await tester.pumpWidget(
      buildForm(
        authAction: SupaAuthAction.signUp,
        onSuccess: (r) => response = r,
      ),
    );

    await tester.enterText(find.byType(TextFormField).first, '+15551234567');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
    await tester.pumpAndSettle();

    expect(response, isNotNull);
    expect(testServer.lastRequest!.url.path, contains('signup'));
  });

  testWidgets('shows an error snack bar when the request fails', (
    tester,
  ) async {
    await tester.pumpWidget(buildForm(authAction: SupaAuthAction.signIn));
    testServer.responder = (_) => errorResponse('Invalid phone or password');

    await tester.enterText(find.byType(TextFormField).first, '+15551234567');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
    await tester.pumpAndSettle();

    expect(find.text('Invalid phone or password'), findsOneWidget);
  });
}
