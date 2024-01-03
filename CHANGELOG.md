## 0.4.0

- BREAKING: Rename `twitter` to `x` for social provider and update branding.
- feat: Add missing social providers.
- chore: Update screenshot on readme.md.
- chore: Add screenshot for pub.dev.

## 0.3.0

- BREAKING: Update `supabase_flutter` to v2.0.1

## 0.2.1

- feat: Make `SupaSocialsAuth` success SnackBar optional [#54](https://github.com/supabase-community/flutter-auth-ui/pull/54)

## 0.2.0

- BREAKING: `SupaEmailAuth` now contains sign-up, sign-in, and forget email in a single instance [#46](https://github.com/supabase-community/flutter-auth-ui/pull/46)
- feat: update Dart dependency to < 4.0.0 and flutter dependencies to >=3.0.0

## 0.1.1

- feat: social aith buttons icon only option [#43](https://github.com/supabase-community/flutter-auth-ui/pull/43)
- feat: email suggestion on email form fields [#44](https://github.com/supabase-community/flutter-auth-ui/pull/44)

## 0.1.0+2

- fix: set splash color on colored social button to provide better UX for google auth button
- fix: use white instead of `onBackground` color for colored social button's foreground color to provide persistent design

## 0.1.0+1

- fix: make image URL on readme.md absolute so that it will be displayed properly on pub.dev

## 0.1.0

- BREAKING: remove unnecessary button styles
- BREAKING: properly style google login button
- feat: update minimum supabase_flutter version to 1.4.0
- fix: updated some of the brand colors for social auth buttons

## 0.0.1

- BREAKING: update supabase_flutter to v1.0.0

## 0.0.1-dev.4

- fix: image URL of Supabase logo in readme.md

## 0.0.1-dev.3

- BREAKING: update supabase_flutter to v1.0.0-dev.9
- BREAKING: `AuthAction` and `PhoneAuthAction` are now `SupaAuthAction`
- BREAKING: `SupabaseAuthUi` class is now removed to let users use `Supabase.instance` directly
- BREAKING: removed the success and fail dialog in favor of `onSuccess` and `onError`
- feat: introduce `onSuccess` and `onError` methods on UI components to handle successful and failed auth actions
- feat: export supabase_flutter package
- chore: added some docs on public members
- feat: add phone auth support
- fix: only validate forms upon submission
- feat: `metadataFields` has been added to add additional fields to the signup form to pass data as metadata in Supabase
  ```dart
  SupaEmailAuth(
      authAction: AuthAction.signUp,
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
      onSuccess: _handleSignupSuccess,
  )
  ```

## 0.0.1-dev.2

- fix: add github actions and fix errors in example
- fix: refactor SocialProviders by using Dart 2.17 enhanced enum
- chore: remove flutter-plugins auto generated files from version control
- fix: update social sign in button text
- fix: Replace `GotrueError` with `GoTrueException`
- fix: update supabase_flutter to v1.0.0-dev.3

## 0.0.1-dev.1

- Initial developer preview release.
