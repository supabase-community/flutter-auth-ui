import 'package:flutter/material.dart';
import 'package:supa_flutter_auth/supa_flutter_auth.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('auth ui example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SupaEmailAuth(
              authAction: AuthAction.signUp,
              redirectUrl: '/home',
            ),
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
                  await SupabaseAuth().signInWithGoogle();
                },
              ),
          ],
        ),
      ),
    );
  }
}
