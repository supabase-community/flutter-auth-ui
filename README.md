<br />
<p align="center">
  <a href="https://supabase.com">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/supabase/supabase/master/packages/common/assets/images/supabase-logo-wordmark--dark.svg">
      <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/supabase/supabase/master/packages/common/assets/images/supabase-logo-wordmark--light.svg">
      <img alt="Supabase Logo" width="300" src="https://raw.githubusercontent.com/supabase/supabase/master/packages/common/assets/images/logo-preview.jpg">
    </picture>
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
        // Or use some other custom widget.
        WidgetSpan()
      ],
    ),
  ]),
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

## Magic Link Auth

Use `SupaMagicAuth` widget to create a magic link signIn form. You need to setup deep links in your app to use magic link. Learn more about deep links on the [supabase_flutter README](https://pub.dev/packages/supabase_flutter#deep-links).

```dart
SupaMagicAuth(
  redirectUrl: kIsWeb ? null : 'io.supabase.flutter://reset-callback/',
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
          : 'io.supabase.flutter://reset-callback/',
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

## Theming

This library uses bare Flutter components so that you can control the appearance of the components using your own theme.
See theme example in example/lib/sign_in.dart

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
  redirectUrl: kIsWeb ? null : 'io.supabase.flutter://reset-callback/',
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

Every widget accepts a `localization` parameter you can use to override the default English strings, for example to translate the UI or reword it.

```dart
SupaEmailAuth(
  localization: const SupaEmailAuthLocalization(
    enterEmail: 'What\'s your email?',
    enterPassword: 'Enter your password',
    signIn: 'Log in',
    signUp: 'Create account',
  ),
  onSignInComplete: (response) {
    // do something, for example: navigate('home');
  },
  onSignUpComplete: (response) {
    // do something, for example: navigate("wait_for_email");
  },
),
```

Each widget has its own localization class with the strings it uses: `SupaEmailAuthLocalization`, `SupaMagicAuthLocalization`, `SupaPhoneAuthLocalization`, `SupaResetPasswordLocalization`, `SupaSocialsAuthLocalization`, and `SupaVerifyPhoneLocalization`.

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
