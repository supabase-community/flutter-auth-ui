# flutter-auth-ui :iphone:
<p float="left">
<img src="https://github.com/supabase/supabase/blob/master/packages/common/assets/images/supabase-logo-wordmark--dark.png"  width="60%" height="50%" />
</p>
A simple library of predefined widgets to easily and quickly create auth components using Flutter and Supabase.

> :warning: **Developer Preview**: This is a developer preview and there maybe some breaking changes until we release v0.0.1.

![Supabase Auth UI](https://raw.githubusercontent.com/supabase-community/flutter-auth-ui/main/assets/supabase_auth_ui.png "UI Sample")

## Email Auth

Use a `SupaEmailAuth` widget to create an email and password signin/ signup form.

```dart
// Create a Signup form
SupaEmailAuth(
    authAction: AuthAction.signUp,
    redirectUrl: kIsWeb
          ? null
          : 'io.supabase.flutter://reset-callback/'
),
// Create a Signin form
SupaEmailAuth(
    authAction: AuthAction.signIn,
    redirectUrl: kIsWeb
          ? null
          : 'io.supabase.flutter://reset-callback/'
),
```

## Magic Link Auth

Use `SupaMagicAuth` widget to create a magic link signIn form.

```dart
SupaMagicAuth(redirectUrl: kIsWeb
          ? null
          : 'io.supabase.flutter://reset-callback/')
```

## Reset password

Use `SupaResetPassword` to create a password reset form.

```dart
SupaResetPassword(accessToken: session.accessToken, redirectUrl: kIsWeb
          ? null
          : 'io.supabase.flutter://reset-callback/')
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
          : 'io.supabase.flutter://reset-callback/'
)
```
