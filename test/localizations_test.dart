import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

void main() {
  test('SupaEmailAuthLocalization exposes sensible defaults', () {
    const localization = SupaEmailAuthLocalization();

    expect(localization.enterEmail, 'Enter your email');
    expect(localization.signIn, 'Sign In');
    expect(localization.signUp, 'Sign Up');
    expect(localization.confirmPasswordError, 'Passwords do not match');
  });

  test('SupaEmailAuthLocalization values can be overridden', () {
    const localization = SupaEmailAuthLocalization(
      signIn: 'Connexion',
      signUp: 'Inscription',
    );

    expect(localization.signIn, 'Connexion');
    expect(localization.signUp, 'Inscription');
    expect(localization.enterEmail, 'Enter your email');
  });

  test('SupaMagicAuthLocalization exposes sensible defaults', () {
    const localization = SupaMagicAuthLocalization();

    expect(localization.continueWithMagicLink, 'Continue with magic Link');
    expect(localization.checkYourEmail, 'Check your email inbox!');
  });

  test('SupaPhoneAuthLocalization exposes sensible defaults', () {
    const localization = SupaPhoneAuthLocalization();

    expect(localization.enterPhoneNumber, 'Enter your phone number');
    expect(
      localization.validPhoneNumberError,
      'Please enter a valid phone number',
    );
  });

  test('SupaResetPasswordLocalization exposes sensible defaults', () {
    const localization = SupaResetPasswordLocalization();

    expect(localization.updatePassword, 'Update Password');
  });

  test('SupaVerifyPhoneLocalization exposes sensible defaults', () {
    const localization = SupaVerifyPhoneLocalization();

    expect(localization.verifyPhone, 'Verify Phone');
    expect(localization.enterCodeSent, 'Enter the code sent');
  });

  test('SupaSocialsAuthLocalization defaults to an empty label map', () {
    const localization = SupaSocialsAuthLocalization();

    expect(localization.successSignInMessage, 'Successfully signed in!');
    expect(localization.oAuthButtonLabels, isEmpty);
  });
}
