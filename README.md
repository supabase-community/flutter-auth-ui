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
)
// Create a Signin form
SupaEmailAuth(
    authAction: AuthAction.signIn,
    redirectUrl: kIsWeb
          ? null
          : 'io.supabase.flutter://reset-callback/'
)
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

## onSuccess / onError callbacks

For `SupaSocialsAuth`, `SupaEmailAuth`, `SupaResetPassword` and `SupaMagicAuth` it is possible to specify a ```onSuccess``` and a ```onError``` callback.

```onSuccess``` will be called when the *Supabase* operation succeeds with the object returned from *GoTrue*.
```onError``` will be called when the *Supabase* operation fails because of *GoTrue* with a *GotrueException* as a parameter.

```dart
SupaEmailAuth(
    authAction: AuthAction.signIn,
    redirectUrl: kIsWeb
          ? null
          : 'io.supabase.flutter://reset-callback/',
    onSuccess: (response) {
        if (response.user != null) {
            // navigate('home');
        }
    },
    onError: (error) {
        if (error.message == "Email not confirmed") {
            // navigate("wait_for_email");
            return true; // we handled the error
        }
        return false; // false to let the library display an error message.
    },
);
```
