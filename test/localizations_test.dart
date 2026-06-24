import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

void main() {
  test('delegate supports English and rejects unsupported locales', () {
    const delegate = SupabaseAuthUILocalizations.delegate;

    expect(delegate.isSupported(const Locale('en')), isTrue);
    expect(delegate.isSupported(const Locale('xx')), isFalse);
  });

  test('supportedLocales contains English', () {
    expect(
      SupabaseAuthUILocalizations.supportedLocales,
      contains(const Locale('en')),
    );
  });

  test('English localization exposes the expected strings', () async {
    final localization = await SupabaseAuthUILocalizations.delegate.load(
      const Locale('en'),
    );

    expect(localization.enterEmail, 'Enter your email');
    expect(localization.signIn, 'Sign In');
    expect(localization.signUp, 'Sign Up');
    expect(localization.confirmPasswordError, 'Passwords do not match');
    expect(localization.continueWithMagicLink, 'Continue with magic Link');
    expect(localization.checkYourEmail, 'Check your email inbox!');
    expect(localization.enterPhoneNumber, 'Enter your phone number');
    expect(localization.updatePassword, 'Update Password');
    expect(localization.verifyPhone, 'Verify Phone');
    expect(localization.enterCodeSent, 'Enter the code sent');
    expect(localization.successSignInMessage, 'Successfully signed in!');
  });

  test('continueWithProvider interpolates the provider name', () async {
    final localization = await SupabaseAuthUILocalizations.delegate.load(
      const Locale('en'),
    );

    expect(
      localization.continueWithProvider('GitHub'),
      'Continue with GitHub',
    );
  });
}
