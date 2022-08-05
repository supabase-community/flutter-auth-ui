import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

import 'constants.dart';

class MagicLink extends StatelessWidget {
  const MagicLink({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SupaMagicAuth(),
            TextButton(
              child: const Text(
                'Already have an account? Sign In',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/sign_in');
              },
            ),
            TextButton(
              child: const Text(
                'Test Google sign in',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                // await SupabaseAuthUi().signInWithGoogle();
              },
            ),
          ],
        ),
      ),
    );
  }
}
