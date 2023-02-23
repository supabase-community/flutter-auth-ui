# flutter-auth-ui :iphone:
<p float="left">
<img src="https://raw.githubusercontent.com/supabase/supabase/master/packages/common/assets/images/supabase-logo-wordmark--dark.png"  width="60%" height="50%" />
</p>
A simple library of predefined widgets to easily and quickly create auth components using Flutter and Supabase.

> :warning: **Developer Preview**: This is a developer preview and there maybe some breaking changes until we release v1.0.0.

![Supabase Auth UI](https://raw.githubusercontent.com/supabase-community/flutter-auth-ui/main/assets/supabase_auth_ui.png "UI Sample")

## Email Auth

Use a `SupaEmailAuth` widget to create an email and password signin/ signup form.

You can pass `metadataFields` to add additional fields to the signup form to pass as metadata to Supabase.

```dart
// Create a Signup form
SupaEmailAuth(
  authAction: SupaAuthAction.signUp,
  redirectUrl: kIsWeb ? null : 'io.supabase.flutter://reset-callback/',
  onSuccess: (AuthResponse response) {
    // do something, for example: navigate('home');
  },
  onError: (error) {
    // do something, for example: navigate("wait_for_email");
  },
  metadataFields: [
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
  ],
),
// Create a Signin form
SupaEmailAuth(
  authAction: SupaAuthAction.signIn,
  redirectUrl: kIsWeb ? null : 'io.supabase.flutter://reset-callback/',
  onSuccess: (AuthResponse response) {
    // do something, for example: navigate('home');
  },
  onError: (error) {
    // do something, for example: navigate("wait_for_email");
  },
),
```

## Magic Link Auth

Use `SupaMagicAuth` widget to create a magic link signIn form.

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

## Social Auth

Use `SupaSocialsAuth` to create list of social login buttons.

```dart
SupaSocialsAuth(
    socialProviders: [
        SocialProviders.apple,
        SocialProviders.google,
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

## Theming

This library uses bare Flutter components so that you can control the appearance of the components using your own theme.
