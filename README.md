# flutter-auth-ui

A simple library of predefined widgets to easily and quickly create a auth compooents using Flutter and Supabase. 

> :warning: **Developer Preview**: This is a developer preview and there maybe some breaking changes until we release v0.0.1. 

[supabase/supabase/master/packages/common/assets/images/supabase-logo-wordmark--dark.svg]

![Supabase Auth UI](https://raw.githubusercontent.com/supabase-community/flutter-auth-ui/main/assets/supabase_auth_ui.png "UI Sample")

## Email Auth

Use a `SupaEmailAuth` widget to create an email and password signin/ signup form.

```dart
// Create a Signup form
SupaEmailAuth(
    authAction: AuthAction.signUp,
    redirectUrl: '/home',
),
// Create a Signin form
SupaEmailAuth(
    authAction: AuthAction.signIn,
    redirectUrl: '/home',
),
```

## Magic Link Auth

Use `SupaMagicAuth` widget to create a magic link signIn form.

```dart
SupaMagicAuth()
```

## Reset password

Use `SupaResetPassword` to create a password reset form.

```dart
SupaResetPassword(accessToken: session.accessToken)
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
)
```