import 'package:supabase_flutter/supabase_flutter.dart';

SupabaseClient supaClient = Supabase.instance.client;

class SupabaseAuthUi {
  initSupabase(String url, String anonKey) {
    Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
  }

  // email-password sign up
  Future<GotrueSessionResponse> createNewEmailUser(
      String email, String password) async {
    final res = await supaClient.auth.signUp(email, password);

    return res;
  }

  // email-password sign in
  Future<GotrueSessionResponse> signInExistingUser(
      String email, String password) async {
    final res = await supaClient.auth.signIn(
      email: email,
      password: password,
    );

    return res;
  }

  // phone auth with password and verification step
  Future<GotrueSessionResponse> createNewPhoneUser(
      String phone, String password) async {
    final res = await supaClient.auth.signUpWithPhone(phone, password);

    return res;
  }

  // verify phone user OTP
  Future<GotrueSessionResponse> verifyPhoneUser(String phone, String token,
      [String? redirectUrl]) async {
    final res = await supaClient.auth.verifyOTP(
      phone,
      token,
      options: AuthOptions(redirectTo: redirectUrl),
    );

    return res;
  }

  Future<GotrueSessionResponse> signInUserWithPhone(
      String phone, String password) async {
    final res = await supaClient.auth.signIn(
      phone: phone,
      password: password,
    );

    return res;
  }

  // email magic link sign in
  Future<GotrueSessionResponse> createNewPasswordlessUser(String email) async {
    final res = await supaClient.auth.signIn(
      email: email,
    );

    return res;
  }

  // social login with Google
  Future<bool?> socialSignIn(String socialProvider, [String? redirectUrl]) async {
    final provider = Provider.values.byName(socialProvider); 
    return await supaClient.auth.signInWithProvider(provider,
        options: AuthOptions(redirectTo: redirectUrl));
  }

  // sign out active user
  Future<GotrueResponse> signOutActiveUser() async {
    final res = await supaClient.auth.signOut();

    return res;
  }

  // sends user a reset password email, redirectTo - screen user comes back to
  Future<GotrueJsonResponse> sendResetPasswordEmail(String email,
      [String? redirectUrl]) async {
    final res = await supaClient.auth.api.resetPasswordForEmail(
      email,
      options: AuthOptions(
        redirectTo: redirectUrl ?? '',
      ),
    );

    return res;
  }

  // update user password
  Future<GotrueUserResponse> updateUserPassword(
      String accessToken, String password) async {
    final res = await supaClient.auth.api.updateUser(
      accessToken,
      UserAttributes(password: password),
    );

    return res;
  }

  // get active user
  User? getActiveUser() {
    final user = supaClient.auth.currentUser;

    return user;
  }
}
