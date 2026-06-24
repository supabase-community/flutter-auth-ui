<br />
<p align="center">
  <a href="https://supabase.com">
    <img alt="Supabase Logo" width="300" src="https://raw.githubusercontent.com/supabase/supabase/master/packages/common/assets/images/logo-preview.jpg">
  </a>

  <h1 align="center">supabase_auth_ui</h1>

  <p align="center">
    A simple library of predefined widgets to easily and quickly create auth components using Flutter and <a href="https://supabase.com">Supabase</a>.
  </p>

  <p align="center">
    <a href="https://supabase.com/docs/guides/auth">Guides</a>
    ·
    <a href="https://pub.dev/documentation/supabase_auth_ui/latest/">Reference Docs</a>
  </p>
</p>

<div align="center">

[![Package](https://img.shields.io/pub/v/supabase_auth_ui.svg)](https://pub.dev/packages/supabase_auth_ui)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](#license)

</div>

![Supabase Auth UI](https://raw.githubusercontent.com/supabase-community/supabase_auth_ui/main/screenshots/supabase_auth_ui.png 'Supabase Auth UI Sample')

## Email Auth

Use a `SupaEmailAuth` widget to create an email and password signin/ signup form.
It also contains a button to toggle to display a forgot password form.

You can pass `metadataFields` to add additional fields to the signup form to pass as metadata to Supabase.

You need to setup deep links in your app to if you have enabled email confirmation. Learn more about deep links on the [supabase_flutter README](https://pub.dev/packages/supabase_flutter#deep-links).

```dart
// Create a Email sign-in/sign-up form
SupaEmailAuth(
  redirectTo: kIsWeb ? null : 'io.mydomain.myapp://callback',
  onSignInComplete: (response) {
    // do something, for example: navigate('home');
  },
  onSignUpComplete: (response) {
    // do something, for example: navigate("wait_for_email");
  },
  metadataFields: [
    // Creates an additional TextField for string metadata, for example:
    // {'username': 'exampleUsername'}
    MetaDataField(
      prefixIcon: const Icon(Icons.person),
      label: 'Username',
      key: 'username',
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Please enter something';
        }
        return null;
      },
    ),

    // Creates a CheckboxListTile for boolean metadata, for example:
    // {'marketing_consent': true}
    BooleanMetaDataField(
      label: 'I wish to receive marketing emails',
      key: 'marketing_consent',
      checkboxPosition: ListTileControlAffinity.leading,
    ),
    // Supports interactive text. Fields can be marked as required, blocking form
    // submission unless the checkbox is checked.
    BooleanMetaDataField(
      key: 'terms_agreement',
      isRequired: true,
      checkboxPosition: ListTileControlAffinity.leading,
      richLabelSpans: [
        const TextSpan(
            text: 'I have read and agree to the '),
        TextSpan(
          text: 'Terms and Conditions',
          style: const TextStyle(
            color: Colors.blue,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              // do something, for example: navigate("terms_and_conditions");
            },
        ),
      ],
    ),
  ],
)
```

You can prefill the email and/or password fields by passing `prefilledEmail` and `prefilledPassword`. The corresponding fields will be initialized with these values, which the user can still edit.

```dart
SupaEmailAuth(
  prefilledEmail: 'mail@example.com',
  prefilledPassword: 'password',
  onSignInComplete: (response) {
    // do something, for example: navigate('home');
  },
  onSignUpComplete: (response) {
    // do something, for example: navigate("wait_for_email");
  },
),
```

`SupaEmailAuth` exposes a few more options worth knowing about:

- `passwordValidator`: provide your own password validation function to enforce password rules.
- `showConfirmPasswordField`: show a "confirm password" field on the sign-up form.
- `useOtpForPasswordRecovery`: recover the password with a one-time code instead of a magic link.
- `extraMetadata`: pass static metadata on sign up that isn't tied to a form field.
- `resetPasswordRedirectTo`: the deep link to redirect to after a password reset email.
- `onPasswordResetEmailSent`, `onToggleSignIn`, `onToggleRecoverPassword`: callbacks for the corresponding events.
- `prefixIconEmail`, `prefixIconPassword`, `prefixIconOtp`: override the default field icons.

## Magic Link Auth

Use `SupaMagicAuth` widget to create a magic link signIn form. You need to setup deep links in your app to use magic link. Learn more about deep links on the [supabase_flutter README](https://pub.dev/packages/supabase_flutter#deep-links).

```dart
SupaMagicAuth(
  redirectUrl: kIsWeb ? null : 'io.supabase.flutter://login-callback/',
  onSuccess: (Session response) {
    // do something, for example: navigate('home');
  },
  onError: (error) {
    // do something, for example: navigate("wait_for_email");
  },
),
```

## Reset password

Use `SupaResetPassword` to create a password reset form.

```dart
SupaResetPassword(
  accessToken: supabase.auth.currentSession?.accessToken,
  onSuccess: (UserResponse response) {
    // do something, for example: navigate('home');
  },
  onError: (error) {
    // do something, for example: navigate("wait_for_email");
  },
),
```

## Phone Auth

Use `SupaPhoneAuth` to create a phone and password sign-in/sign-up form. Pass `SupaAuthAction.signIn` or `SupaAuthAction.signUp` to control which action the form performs.

```dart
SupaPhoneAuth(
  authAction: SupaAuthAction.signUp,
  onSuccess: (AuthResponse response) {
    // do something, for example: navigate('home');
  },
),
```

After signing up, use `SupaVerifyPhone` to verify the phone number with the OTP code that was sent over SMS.

```dart
SupaVerifyPhone(
  onSuccess: (AuthResponse response) {
    // do something, for example: navigate('home');
  },
),
```

## Social Auth

Use `SupaSocialsAuth` to create list of social login buttons. You need to setup deep links in your app to use social auth. Learn more about deep links on the [supabase_flutter README](https://pub.dev/packages/supabase_flutter#deep-links).

```dart
SupaSocialsAuth(
    socialProviders: [
        OAuthProvider.apple,
        OAuthProvider.google,
    ],
    colored: true,
    redirectUrl: kIsWeb
          ? null
          : 'io.supabase.flutter://login-callback/',
    onSuccess: (Session response) {
        // do something, for example: navigate('home');
    },
    onError: (error) {
        // do something, for example: navigate("wait_for_email");
    },
),
```

### Native Google and Apple sign in

On mobile and desktop you can use the native sign in dialogs instead of the
browser-based OAuth flow. `SupaSocialsAuth` falls back to the web OAuth flow on
any platform where the native flow is not available or not configured, so it is
safe to leave these options enabled across all platforms.

Before wiring up the UI, configure the providers in your Supabase project and
in each platform as described in the
[native Google sign in](https://supabase.com/docs/guides/auth/social-login/auth-google?platform=flutter#using-native-sign-in)
and
[native Apple sign in](https://supabase.com/docs/guides/auth/social-login/auth-apple?platform=flutter#using-native-sign-in)
guides.

#### Native Google

Native Google sign in is used when you pass a `nativeGoogleAuthConfig` and the
client ID for the current platform is set. Otherwise the web OAuth flow is used.

- On Android, set `webClientId`.
- On iOS, set `iosClientId`.

The client IDs are the ones you registered with Google Cloud. See the
[`google_sign_in`](https://pub.dev/packages/google_sign_in) package for the
required platform setup (iOS URL scheme, etc.).

#### Native Apple

Native Apple sign in is enabled by default (`enableNativeAppleAuth: true`) and is
used on iOS and macOS. On other platforms the web OAuth flow is used. It requires
the "Sign in with Apple" capability to be added to your app in Xcode. See the
[`sign_in_with_apple`](https://pub.dev/packages/sign_in_with_apple) package for
the platform setup.

```dart
SupaSocialsAuth(
    socialProviders: [
        OAuthProvider.apple,
        OAuthProvider.google,
    ],
    // Enables native Google sign in on Android and iOS.
    nativeGoogleAuthConfig: const NativeGoogleAuthConfig(
        webClientId: 'YOUR_WEB_CLIENT_ID',
        iosClientId: 'YOUR_IOS_CLIENT_ID',
    ),
    // Native Apple sign in is used on iOS and macOS by default.
    enableNativeAppleAuth: true,
    onSuccess: (Session response) {
        // do something, for example: navigate('home');
    },
),
```

`SupaSocialsAuth` also supports:

- `socialButtonVariant`: render the buttons as `SocialButtonVariant.iconAndText` (default) or `SocialButtonVariant.icon` for icon-only buttons.
- `scopes`: request additional OAuth scopes per provider.
- `queryParams`: pass custom query parameters per provider.
- `colored`: use the provider brand colors (defaults to `true`).
- `authScreenLaunchMode`: control how the OAuth browser screen is launched.

## Theming

This library uses bare Flutter components so that you can control the appearance of the components using your own theme. The fields and buttons respect your `ThemeData`, so styling them through `InputDecorationTheme`, `ElevatedButtonTheme`, and the rest of your app theme works as expected.

See the theme example in [`example/lib/sign_in.dart`](example/lib/sign_in.dart).

## Example

A full example app covering every widget is available in the [`example`](example) directory.

## Controlling Form Submission Behavior

All auth components (`SupaEmailAuth`, `SupaPhoneAuth`, `SupaMagicAuth`, and `SupaResetPassword`) support the `enableAutomaticFormSubmission` parameter to control whether pressing Enter/Done on the on-screen keyboard automatically submits the form.

By default, this is set to `true` for backward compatibility, which means pressing Enter will submit the form. If you want users to be forced to explicitly tap the submit button, set this to `false`:

```dart
SupaEmailAuth(
  redirectTo: kIsWeb ? null : 'io.mydomain.myapp://callback',
  enableAutomaticFormSubmission: false, // Disable auto-submit on Enter
  onSignInComplete: (response) {
    // do something, for example: navigate('home');
  },
  onSignUpComplete: (response) {
    // do something, for example: navigate("wait_for_email");
  },
),
```

This applies to all auth components:

```dart
// Phone Auth
SupaPhoneAuth(
  authAction: SupaAuthAction.signIn,
  enableAutomaticFormSubmission: false,
  onSuccess: (response) {
    // handle success
  },
),

// Magic Link Auth
SupaMagicAuth(
  redirectUrl: kIsWeb ? null : 'io.supabase.flutter://login-callback/',
  enableAutomaticFormSubmission: false,
  onSuccess: (Session response) {
    // handle success
  },
),

// Reset Password
SupaResetPassword(
  accessToken: supabase.auth.currentSession?.accessToken,
  enableAutomaticFormSubmission: false,
  onSuccess: (UserResponse response) {
    // handle success
  },
),
```

## Localization

The widgets resolve their strings through Flutter's standard localization
mechanism. Register `SupabaseAuthUILocalizations.delegate` on your app and the
strings are picked from the active locale:

```dart
MaterialApp(
  localizationsDelegates: SupabaseAuthUILocalizations.localizationsDelegates,
  supportedLocales: SupabaseAuthUILocalizations.supportedLocales,
  home: const MyHomePage(),
);
```

`SupabaseAuthUILocalizations.localizationsDelegates` bundles the package
delegate together with the `GlobalMaterialLocalizations`,
`GlobalWidgetsLocalizations`, and `GlobalCupertinoLocalizations` delegates. If
you already register your own delegates, add `SupabaseAuthUILocalizations.delegate`
to your existing list instead.

The package ships English (`en`) out of the box and falls back to it when no
delegate is registered.

### Translating or overriding strings

To translate the UI or reword it, supply your own
`LocalizationsDelegate<SupabaseAuthUILocalizations>` that returns a subclass of
`SupabaseAuthUILocalizations` with the strings you want, and register it before
the bundled delegate:

```dart
class MyAuthLocalizations extends SupabaseAuthUILocalizations {
  MyAuthLocalizations() : super('en');

  @override
  String get signIn => 'Log in';

  @override
  String get signUp => 'Create account';

  // ...override the rest as needed.
}

class MyAuthLocalizationsDelegate
    extends LocalizationsDelegate<SupabaseAuthUILocalizations> {
  const MyAuthLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'en';

  @override
  Future<SupabaseAuthUILocalizations> load(Locale locale) =>
      SynchronousFuture(MyAuthLocalizations());

  @override
  bool shouldReload(covariant LocalizationsDelegate old) => false;
}
```

The social sign-in button labels can be customized per provider through the
`oAuthButtonLabels` parameter on `SupaSocialsAuth`:

```dart
SupaSocialsAuth(
  socialProviders: const [OAuthProvider.azure],
  oAuthButtonLabels: {OAuthProvider.azure: 'Microsoft (Azure)'},
  onSuccess: (session) {
    // do something, for example: navigate('home');
  },
),
```

## Contributing

- Fork the repo on [GitHub](https://github.com/supabase-community/supabase_auth_ui)
- Clone the project to your own machine
- Commit changes to your own branch
- Push your work back up to your fork
- Submit a Pull request so that we can review your changes and merge

## License

This repo is licensed under MIT.

## Resources

- [Supabase Flutter SDK (`supabase_flutter`)](https://github.com/supabase/supabase-flutter)
- [Quickstart: Flutter](https://supabase.com/docs/guides/with-flutter)
- [Flutter Tutorial: building a Flutter chat app](https://supabase.com/blog/flutter-tutorial-building-a-chat-app)
- [Flutter Tutorial - Part 2: Authentication and Authorization with RLS](https://supabase.com/blog/flutter-authentication-and-authorization-with-rls)
