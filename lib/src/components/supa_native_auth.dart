import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_auth_ui/src/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum NativeProviders { apple, google }

class SupaNativeAuth extends StatefulWidget {
  final String webClientId, iosClientId;
  const SupaNativeAuth(
      {super.key, required this.webClientId, required this.iosClientId});

  @override
  State<SupaNativeAuth> createState() => _SupaNativeAuthState();
}

class _SupaNativeAuthState extends State<SupaNativeAuth> {
  Future<AuthResponse> _googleSignIn(webClientId, iosClientId) async {
    /// TODO: update the Web client ID with your own.
    ///
    /// Web Client ID that you registered with Google Cloud.
    // const webClientId = 'my-web.apps.googleusercontent.com';

    /// TODO: update the iOS client ID with your own.
    ///
    /// iOS Client ID that you registered with Google Cloud.
    // const iosClientId = 'my-ios.apps.googleusercontent.com';

    // Google sign in on Android will work without providing the Android
    // Client ID registered on Google Cloud.

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    return supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  @override
  Widget build(BuildContext context) {
    final webClientId = widget.webClientId;
    final iosClientId = widget.iosClientId;
    return ElevatedButton(
        onPressed: () async {
          await _googleSignIn(webClientId, iosClientId);
        },
        child: const Text('Sign in with Google'));
  }
}
