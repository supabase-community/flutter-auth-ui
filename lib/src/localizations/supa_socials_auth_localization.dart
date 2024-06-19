import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class SupaSocialsAuthLocalization {
  final String updatePassword;
  final String successSignInMessage;
  final String unexpectedError;
  final String continueWith;

  /// Overrides the name of the OAuth provider shown on the sign-in button.
  ///
  /// ```dart
  /// SupaSocialsAuth(
  ///   socialProviders: const [OAuthProvider.azure],
  ///   localization: const SupaSocialsAuthLocalization(
  ///     oAuthProviderLabelOverrides: {
  ///       OAuthProvider.azure: 'Microsoft (Azure)'
  ///     },
  ///   ),
  ///   onSuccess: (session) {
  ///     // sHandle success
  ///   },
  /// ),
  /// ```
  final Map<OAuthProvider, String> oAuthProviderLabelOverrides;

  const SupaSocialsAuthLocalization({
    this.updatePassword = 'Update Password',
    this.successSignInMessage = 'Successfully signed in!',
    this.unexpectedError = 'An unexpected error occurred',
    this.continueWith = 'Continue with',
    this.oAuthProviderLabelOverrides = const {},
  });
}
