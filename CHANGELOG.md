## 0.0.1-dev.3

- BREAKING: update supabase_flutter to v1.0.0-dev.9
- BREAKING: `AuthAction` and `PhoneAuthAction` are now `SupaAuthAction`
- BREAKING: `SupabaseAuthUi` class is now removed to let users use `Supabase.instance` directly
- feat: export supabase_flutter package
- feat: introduce `onSuccess` and `onError` methods on UI components to handle successful and failed auth actions
- chore: added some docs on public members
- feat: add phone auth support
- fix: only validate forms upon submission

## 0.0.1-dev.2

- fix: add github actions and fix errors in example
- fix: refactor SocialProviders by using Dart 2.17 enhanced enum
- chore: remove flutter-plugins auto generated files from version control
- fix: update social sign in button text
- fix: Replace `GotrueError` with `GoTrueException`
- fix: update supabase_flutter to v1.0.0-dev.3

## 0.0.1-dev.1

- Initial developer preview release. 
