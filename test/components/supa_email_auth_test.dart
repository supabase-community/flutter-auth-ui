import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

import '../test_utils.dart';

void main() {
  setUpAll(initializeSupabaseForTest);
  setUp(() => testServer.reset());

  Widget buildForm({
    void Function(AuthResponse response)? onSignInComplete,
    void Function(AuthResponse response)? onSignUpComplete,
    void Function(Object error)? onError,
    void Function(bool isSigningIn)? onToggleSignIn,
    void Function(bool isRecoveringPassword)? onToggleRecoverPassword,
    void Function(String email)? onPasswordResetEmailSent,
    bool isInitiallySigningIn = true,
    bool showConfirmPasswordField = false,
    bool useOtpForPasswordRecovery = false,
    bool showSnackBars = true,
    List<MetaDataField>? metadataFields,
    String? prefilledEmail,
    String? prefilledPassword,
  }) {
    return wrapForTest(
      SupaEmailAuth(
        onSignInComplete: onSignInComplete ?? (_) {},
        onSignUpComplete: onSignUpComplete ?? (_) {},
        onError: onError,
        onToggleSignIn: onToggleSignIn,
        onToggleRecoverPassword: onToggleRecoverPassword,
        onPasswordResetEmailSent: onPasswordResetEmailSent,
        isInitiallySigningIn: isInitiallySigningIn,
        showConfirmPasswordField: showConfirmPasswordField,
        useOtpForPasswordRecovery: useOtpForPasswordRecovery,
        showSnackBars: showSnackBars,
        metadataFields: metadataFields,
        prefilledEmail: prefilledEmail,
        prefilledPassword: prefilledPassword,
      ),
    );
  }

  group('rendering', () {
    testWidgets('shows email, password and sign in button by default', (
      tester,
    ) async {
      await tester.pumpWidget(buildForm());

      expect(find.text('Enter your email'), findsOneWidget);
      expect(find.text('Enter your password'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Sign In'), findsOneWidget);
      expect(find.text('Forgot your password?'), findsOneWidget);
      expect(find.text("Don't have an account? Sign up"), findsOneWidget);
    });

    testWidgets('does not show the forgot password button when signing up', (
      tester,
    ) async {
      await tester.pumpWidget(buildForm(isInitiallySigningIn: false));

      expect(find.widgetWithText(ElevatedButton, 'Sign Up'), findsOneWidget);
      expect(find.text('Forgot your password?'), findsNothing);
      expect(find.text('Already have an account? Sign in'), findsOneWidget);
    });

    testWidgets('pre-fills the email and password fields', (tester) async {
      await tester.pumpWidget(
        buildForm(
          prefilledEmail: 'prefilled@example.com',
          prefilledPassword: 'supersecret',
        ),
      );

      expect(find.text('prefilled@example.com'), findsOneWidget);
      expect(find.text('supersecret'), findsOneWidget);
    });
  });

  group('validation', () {
    testWidgets('shows an error for an invalid email', (tester) async {
      await tester.pumpWidget(buildForm());

      await tester.enterText(find.byType(TextFormField).first, 'not-an-email');
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'longenough',
      );
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pump();

      expect(find.text('Please enter a valid email address'), findsOneWidget);
    });

    testWidgets('shows an error for a too short password', (tester) async {
      await tester.pumpWidget(buildForm());

      await tester.enterText(
        find.byType(TextFormField).first,
        'valid@example.com',
      );
      await tester.enterText(find.byType(TextFormField).at(1), '123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pump();

      expect(
        find.text(
          'Please enter a password that is at least 6 characters long',
        ),
        findsOneWidget,
      );
    });

    testWidgets('does not submit when validation fails', (tester) async {
      await tester.pumpWidget(buildForm());

      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pump();

      expect(testServer.requests, isEmpty);
    });
  });

  group('toggling', () {
    testWidgets('toggles between sign in and sign up', (tester) async {
      bool? isSigningIn;
      await tester.pumpWidget(
        buildForm(onToggleSignIn: (value) => isSigningIn = value),
      );

      await tester.tap(find.byKey(const ValueKey('toggleSignInButton')));
      await tester.pumpAndSettle();

      expect(isSigningIn, isFalse);
      expect(find.widgetWithText(ElevatedButton, 'Sign Up'), findsOneWidget);
    });
  });

  group('confirm password field', () {
    testWidgets('is shown only when signing up', (tester) async {
      await tester.pumpWidget(
        buildForm(
          isInitiallySigningIn: false,
          showConfirmPasswordField: true,
        ),
      );

      expect(find.text('Confirm Password'), findsOneWidget);
    });

    testWidgets('shows an error when passwords do not match', (tester) async {
      await tester.pumpWidget(
        buildForm(
          isInitiallySigningIn: false,
          showConfirmPasswordField: true,
        ),
      );

      await tester.enterText(
        find.byType(TextFormField).first,
        'valid@example.com',
      );
      await tester.enterText(find.byType(TextFormField).at(1), 'password1');
      await tester.enterText(find.byType(TextFormField).at(2), 'password2');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
      await tester.pump();

      expect(find.text('Passwords do not match'), findsOneWidget);
    });
  });

  group('sign in', () {
    testWidgets('calls onSignInComplete on success', (tester) async {
      AuthResponse? response;
      await tester.pumpWidget(
        buildForm(onSignInComplete: (r) => response = r),
      );

      await tester.enterText(
        find.byType(TextFormField).first,
        'valid@example.com',
      );
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pumpAndSettle();

      expect(response, isNotNull);
      expect(response!.user, isNotNull);
      expect(testServer.lastRequest!.url.path, contains('token'));
      expect(testServer.lastBody['email'], 'valid@example.com');
    });

    testWidgets('shows an error snack bar when sign in fails', (tester) async {
      await tester.pumpWidget(buildForm());
      testServer.responder = (_) =>
          errorResponse('Invalid login credentials', statusCode: 400);

      await tester.enterText(
        find.byType(TextFormField).first,
        'valid@example.com',
      );
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pumpAndSettle();

      expect(find.text('Invalid login credentials'), findsOneWidget);
    });

    testWidgets('forwards the error to onError when provided', (tester) async {
      Object? captured;
      await tester.pumpWidget(buildForm(onError: (e) => captured = e));
      testServer.responder = (_) =>
          errorResponse('Invalid login credentials', statusCode: 400);

      await tester.enterText(
        find.byType(TextFormField).first,
        'valid@example.com',
      );
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pumpAndSettle();

      expect(captured, isA<AuthException>());
    });
  });

  group('sign up', () {
    testWidgets('calls onSignUpComplete on success', (tester) async {
      AuthResponse? response;
      await tester.pumpWidget(
        buildForm(
          isInitiallySigningIn: false,
          onSignUpComplete: (r) => response = r,
        ),
      );

      await tester.enterText(
        find.byType(TextFormField).first,
        'new@example.com',
      );
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
      await tester.pumpAndSettle();

      expect(response, isNotNull);
      expect(testServer.lastRequest!.url.path, contains('signup'));
    });

    testWidgets('sends metadata fields with the sign up request', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildForm(
          isInitiallySigningIn: false,
          metadataFields: [
            MetaDataField(label: 'Username', key: 'username'),
          ],
        ),
      );

      expect(find.text('Username'), findsOneWidget);

      await tester.enterText(
        find.byType(TextFormField).first,
        'new@example.com',
      );
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Username'),
        'supauser',
      );
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
      await tester.pumpAndSettle();

      expect(testServer.lastBody['data'], containsPair('username', 'supauser'));
    });

    testWidgets('blocks sign up until a required checkbox is checked', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildForm(
          isInitiallySigningIn: false,
          metadataFields: [
            BooleanMetaDataField(
              key: 'terms',
              label: 'I agree to the terms',
              isRequired: true,
            ),
          ],
        ),
      );

      await tester.enterText(
        find.byType(TextFormField).first,
        'new@example.com',
      );
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
      await tester.pump();

      expect(find.text('This field is required'), findsOneWidget);
      expect(testServer.requests, isEmpty);

      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
      await tester.pumpAndSettle();

      expect(testServer.lastRequest!.url.path, contains('signup'));
    });
  });

  group('password recovery', () {
    testWidgets('reveals the reset button after tapping forgot password', (
      tester,
    ) async {
      bool? recovering;
      await tester.pumpWidget(
        buildForm(onToggleRecoverPassword: (value) => recovering = value),
      );

      await tester.tap(find.text('Forgot your password?'));
      await tester.pumpAndSettle();

      expect(recovering, isTrue);
      expect(
        find.widgetWithText(ElevatedButton, 'Send password reset email'),
        findsOneWidget,
      );
      expect(find.text('Enter your password'), findsNothing);
    });

    testWidgets('sends the reset email and reports the address', (
      tester,
    ) async {
      String? resetEmail;
      await tester.pumpWidget(
        buildForm(onPasswordResetEmailSent: (email) => resetEmail = email),
      );

      await tester.tap(find.text('Forgot your password?'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byType(TextFormField).first,
        'reset@example.com',
      );
      await tester.tap(
        find.widgetWithText(ElevatedButton, 'Send password reset email'),
      );
      await tester.pumpAndSettle();

      expect(resetEmail, 'reset@example.com');
      expect(testServer.requests.last.url.path, contains('recover'));
    });

    testWidgets('shows the OTP fields when useOtpForPasswordRecovery is set', (
      tester,
    ) async {
      await tester.pumpWidget(buildForm(useOtpForPasswordRecovery: true));

      await tester.tap(find.text('Forgot your password?'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byType(TextFormField).first,
        'reset@example.com',
      );
      await tester.tap(
        find.widgetWithText(ElevatedButton, 'Send password reset email'),
      );
      await tester.pumpAndSettle();

      expect(find.text('Enter OTP code'), findsOneWidget);
      expect(find.text('Enter new password'), findsOneWidget);
      expect(
        find.widgetWithText(ElevatedButton, 'Change Password'),
        findsOneWidget,
      );
    });
  });
}
