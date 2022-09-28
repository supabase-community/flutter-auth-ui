import 'package:supabase_flutter/supabase_flutter.dart';

SupabaseClient supaClient = Supabase.instance.client;

class SupabaseAuthUi {
  Future<Supabase> initSupabase(String url, String anonKey) async {
    return Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
  }

  /// Email-password sign up
  Future<GotrueSessionResponse> createNewEmailUser(
    String email,
    String password, {
    String? redirectUrl,
  }) {
    return supaClient.auth.signUp(
      email,
      password,
      options: AuthOptions(
        redirectTo: redirectUrl,
      ),
    );
  }

  /// Email-password sign in
  Future<GotrueSessionResponse> signInExistingUser(
    String email,
    String password,
  ) {
    return supaClient.auth.signIn(
      email: email,
      password: password,
    );
  }

  /// Phone auth with password and verification step
  Future<GotrueSessionResponse> createNewPhoneUser(
    String phone,
    String password,
  ) {
    return supaClient.auth.signUpWithPhone(phone, password);
  }

  /// Verify phone user OTP
  Future<GotrueSessionResponse> verifyPhoneUser(
    String phone,
    String token, [
    String? redirectUrl,
  ]) async {
    return supaClient.auth.verifyOTP(
      phone,
      token,
      options: AuthOptions(
        redirectTo: redirectUrl,
      ),
    );
  }

  Future<GotrueSessionResponse> signInUserWithPhone(
    String phone,
    String password,
  ) {
    return supaClient.auth.signIn(
      phone: phone,
      password: password,
    );
  }

  /// Email magic link sign in
  Future<GotrueSessionResponse> createNewPasswordlessUser(String email,
      {String? redirectUrl}) {
    return supaClient.auth.signIn(
      email: email,
      options: AuthOptions(
        redirectTo: redirectUrl,
      ),
    );
  }

  /// Social login with Google
  Future<bool?> socialSignIn(
    String socialProvider, {
    String? redirectUrl,
  }) {
    final provider = Provider.values.byName(socialProvider);
    return supaClient.auth.signInWithProvider(
      provider,
      options: AuthOptions(
        redirectTo: redirectUrl,
      ),
    );
  }

  /// Sign out active user
  Future<GotrueResponse> signOutActiveUser() {
    return supaClient.auth.signOut();
  }

  /// Sends user a reset password email, redirectTo - screen user comes back to
  Future<GotrueJsonResponse> sendResetPasswordEmail(
    String email, [
    String? redirectUrl,
  ]) {
    return supaClient.auth.api.resetPasswordForEmail(
      email,
      options: AuthOptions(
        redirectTo: redirectUrl,
      ),
    );
  }

  /// Update user password
  Future<GotrueUserResponse> updateUserPassword(
    String accessToken,
    String password,
  ) {
    return supaClient.auth.api.updateUser(
      accessToken,
      UserAttributes(
        password: password,
      ),
    );
  }

  /// Get active user
  User? getActiveUser() {
    return supaClient.auth.currentUser;
  }
}
