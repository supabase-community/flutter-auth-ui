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
