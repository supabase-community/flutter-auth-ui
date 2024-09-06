import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class SupaOauthSignout {
  static Future<void> signOut() async {
    try {
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        final googleSignIn = GoogleSignIn();
        if (await googleSignIn.isSignedIn()) {
          await googleSignIn.signOut();
        }
      }
      await Supabase.instance.client.auth.signOut();
    } catch (error) {
      throw AuthException(
        'Failed to sign out: ${error.toString()}',
      );
    }
  }
}
