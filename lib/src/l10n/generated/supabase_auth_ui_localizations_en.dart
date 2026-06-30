// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'supabase_auth_ui_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class SupabaseAuthUILocalizationsEn extends SupabaseAuthUILocalizations {
  SupabaseAuthUILocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get enterEmail => 'Enter your email';

  @override
  String get validEmailError => 'Please enter a valid email address';

  @override
  String get enterPassword => 'Enter your password';

  @override
  String get passwordLengthError =>
      'Please enter a password that is at least 6 characters long';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get forgotPassword => 'Forgot your password?';

  @override
  String get dontHaveAccount => 'Don\'t have an account? Sign up';

  @override
  String get haveAccount => 'Already have an account? Sign in';

  @override
  String get sendPasswordReset => 'Send password reset email';

  @override
  String get passwordResetSent => 'Password reset email has been sent';

  @override
  String get backToSignIn => 'Back to sign in';

  @override
  String get unexpectedError => 'An unexpected error occurred';

  @override
  String get requiredFieldError => 'This field is required';

  @override
  String get confirmPasswordError => 'Passwords do not match';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get enterOtpCode => 'Enter OTP code';

  @override
  String get enterNewPassword => 'Enter new password';

  @override
  String get changePassword => 'Change Password';

  @override
  String get passwordChangedSuccess => 'Password successfully updated';

  @override
  String get otpCodeError => 'Invalid OTP code';

  @override
  String get otpDisabledError => 'OTP disabled';

  @override
  String get enterPhoneNumber => 'Enter your phone number';

  @override
  String get validPhoneNumberError => 'Please enter a valid phone number';

  @override
  String get continueWithMagicLink => 'Continue with magic Link';

  @override
  String get checkYourEmail => 'Check your email inbox!';

  @override
  String get successSignInMessage => 'Successfully signed in!';

  @override
  String get updatePassword => 'Update Password';

  @override
  String get enterOneTimeCode => 'Please enter the one time code sent';

  @override
  String get enterCodeSent => 'Enter the code sent';

  @override
  String get verifyPhone => 'Verify Phone';

  @override
  String continueWithProvider(String provider) {
    return 'Continue with $provider';
  }
}
