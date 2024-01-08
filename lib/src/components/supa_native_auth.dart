import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_auth_ui/src/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthType {
  GoogleAuthType? google;
  bool apple;

  AuthType({this.google, required this.apple});
}

class GoogleAuthType {
  /// Web Client ID and iOS Client ID that you registered with Google Cloud.
  /// Needed for Sign in with Google
  String webClientId;
  String iosClientId;

  GoogleAuthType({required this.webClientId, required this.iosClientId});
}

class SupaNativeAuth extends StatefulWidget {
  /// Defines native auth providers to show in the form
  final AuthType authType;

  /// Method to be called when the auth action is success
  final void Function(Session) onSuccess;

  /// Method to be called when the auth action threw an excepction
  final void Function(Object error)? onError;

  /// Whether to show a SnackBar after a successful sign in
  final bool showSuccessSnackBar;

  const SupaNativeAuth({
    super.key,
    required this.authType,
    required this.onSuccess,
    this.onError,
    this.showSuccessSnackBar = true,
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

  Widget _nativeAuthBtn(
      IconData icon, String label, Future Function() signInMethod) {
    return ElevatedButton.icon(
      onPressed: () async {
        try {
          await signInMethod();
        } on AuthException catch (error) {
          if (widget.onError == null && context.mounted) {
            context.showErrorSnackBar(error.message);
          } else {
            widget.onError?.call(error);
          }
        } catch (error) {
          if (widget.onError == null && context.mounted) {
            context.showErrorSnackBar('Unexpected error has occurred: $error');
          } else {
            widget.onError?.call(error);
          }
        }
      },
      icon: Icon(icon),
      label: Text(label),
    );
  }

  late final StreamSubscription<AuthState> _gotrueSubscription;

  @override
  void initState() {
    super.initState();
    _gotrueSubscription =
        Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null && mounted) {
        widget.onSuccess.call(session);
        if (widget.showSuccessSnackBar) {
          context.showSnackBar('Successfully signed in!');
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _gotrueSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final provider = widget.authType;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (provider.google != null)
          _nativeAuthBtn(
            FontAwesomeIcons.google,
            'Sign in with Google',
            () => _googleSignIn(
              provider.google!.webClientId,
              provider.google!.iosClientId,
            ),
          ),
        if (provider.apple)
          _nativeAuthBtn(
            FontAwesomeIcons.apple,
            'Sign in with Apple',
            _appleSignIn,
          ),
      ],
    );
  }
}
