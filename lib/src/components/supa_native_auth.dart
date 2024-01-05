import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_auth_ui/src/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupaNativeAuth extends StatefulWidget {
  /// Web Client ID and iOS Client ID that you registered with Google Cloud.
  final String webClientId, iosClientId;

  /// Callback for the user to complete a sign in.
  final void Function(AuthResponse response) onSignInComplete;

  /// Callback for the user to complete a signUp.
  final void Function(AuthResponse response) onSignUpComplete;

  const SupaNativeAuth({
    super.key,
    required this.webClientId,
    required this.iosClientId,
    required this.onSignInComplete,
    required this.onSignUpComplete,
  });

  @override
  State<SupaNativeAuth> createState() => _SupaNativeAuthState();
}

class _SupaNativeAuthState extends State<SupaNativeAuth> {
  /// Performs Google sign in on Android and iOS
  Future<AuthResponse> _googleSignIn(webClientId, iosClientId) async {
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

  /// Performs Apple sign in on iOS or macOS
  Future<AuthResponse> _appleSignIn() async {
    final rawNonce = supabase.auth.generateRawNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce,
    );

    final idToken = credential.identityToken;
    if (idToken == null) {
      throw const AuthException(
          'Could not find ID Token from generated credential.');
    }

    return supabase.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
      nonce: rawNonce,
    );
  }

  @override
  Widget build(BuildContext context) {
    final webClientId = widget.webClientId;
    final iosClientId = widget.iosClientId;
    return ElevatedButton(
        onPressed: () async {
          Platform.isAndroid
              ? await _googleSignIn(webClientId, iosClientId)
              : Platform.isIOS
                  ? await _appleSignIn()
                  : null;
        },
        child: const Text('Sign in with Google'));
  }
}
