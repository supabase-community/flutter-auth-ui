import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'supabase_auth_ui_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of SupabaseAuthUILocalizations
/// returned by `SupabaseAuthUILocalizations.of(context)`.
///
/// Applications need to include `SupabaseAuthUILocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/supabase_auth_ui_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: SupabaseAuthUILocalizations.localizationsDelegates,
///   supportedLocales: SupabaseAuthUILocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the SupabaseAuthUILocalizations.supportedLocales
/// property.
abstract class SupabaseAuthUILocalizations {
  SupabaseAuthUILocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static SupabaseAuthUILocalizations? of(BuildContext context) {
    return Localizations.of<SupabaseAuthUILocalizations>(
      context,
      SupabaseAuthUILocalizations,
    );
  }

  static const LocalizationsDelegate<SupabaseAuthUILocalizations> delegate =
      _SupabaseAuthUILocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// Label for the email input field.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterEmail;

  /// Validation error shown when the email address is invalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get validEmailError;

  /// Label for the password input field.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// Validation error shown when the password is too short.
  ///
  /// In en, this message translates to:
  /// **'Please enter a password that is at least 6 characters long'**
  String get passwordLengthError;

  /// Label for the sign in button.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// Label for the sign up button.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// Label for the forgot password button.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgotPassword;

  /// Prompt shown to users without an account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign up'**
  String get dontHaveAccount;

  /// Prompt shown to users who already have an account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get haveAccount;

  /// Label for the button that sends a password reset email.
  ///
  /// In en, this message translates to:
  /// **'Send password reset email'**
  String get sendPasswordReset;

  /// Confirmation shown after a password reset email is sent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email has been sent'**
  String get passwordResetSent;

  /// Label for the button that returns to the sign in form.
  ///
  /// In en, this message translates to:
  /// **'Back to sign in'**
  String get backToSignIn;

  /// Generic error message shown when something goes wrong.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get unexpectedError;

  /// Validation error shown when a required field is empty.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get requiredFieldError;

  /// Validation error shown when the password confirmation does not match.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get confirmPasswordError;

  /// Label for the confirm password input field.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Label for the one time password input field.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP code'**
  String get enterOtpCode;

  /// Label for the new password input field.
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get enterNewPassword;

  /// Label for the change password button.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// Confirmation shown after the password is updated.
  ///
  /// In en, this message translates to:
  /// **'Password successfully updated'**
  String get passwordChangedSuccess;

  /// Validation error shown when the one time password code is invalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP code'**
  String get otpCodeError;

  /// Error shown when one time password sign in is disabled.
  ///
  /// In en, this message translates to:
  /// **'OTP disabled'**
  String get otpDisabledError;

  /// Label for the phone number input field.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterPhoneNumber;

  /// Validation error shown when the phone number is invalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get validPhoneNumberError;

  /// Label for the button that sends a magic link.
  ///
  /// In en, this message translates to:
  /// **'Continue with magic Link'**
  String get continueWithMagicLink;

  /// Confirmation shown after a magic link email is sent.
  ///
  /// In en, this message translates to:
  /// **'Check your email inbox!'**
  String get checkYourEmail;

  /// Confirmation shown after a successful social sign in.
  ///
  /// In en, this message translates to:
  /// **'Successfully signed in!'**
  String get successSignInMessage;

  /// Label for the update password button.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get updatePassword;

  /// Validation error shown when the one time code is empty.
  ///
  /// In en, this message translates to:
  /// **'Please enter the one time code sent'**
  String get enterOneTimeCode;

  /// Label for the one time code input field during phone verification.
  ///
  /// In en, this message translates to:
  /// **'Enter the code sent'**
  String get enterCodeSent;

  /// Label for the verify phone button.
  ///
  /// In en, this message translates to:
  /// **'Verify Phone'**
  String get verifyPhone;

  /// Label for a social sign in button.
  ///
  /// In en, this message translates to:
  /// **'Continue with {provider}'**
  String continueWithProvider(String provider);
}

class _SupabaseAuthUILocalizationsDelegate
    extends LocalizationsDelegate<SupabaseAuthUILocalizations> {
  const _SupabaseAuthUILocalizationsDelegate();

  @override
  Future<SupabaseAuthUILocalizations> load(Locale locale) {
    return SynchronousFuture<SupabaseAuthUILocalizations>(
      lookupSupabaseAuthUILocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_SupabaseAuthUILocalizationsDelegate old) => false;
}

SupabaseAuthUILocalizations lookupSupabaseAuthUILocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return SupabaseAuthUILocalizationsEn();
  }

  throw FlutterError(
    'SupabaseAuthUILocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
