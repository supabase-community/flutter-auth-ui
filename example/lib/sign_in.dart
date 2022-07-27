import 'package:flutter/material.dart';
import 'package:supa_flutter_auth/supa_flutter_auth.dart';

class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

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
              authAction: AuthAction.signIn,
              redirectUrl: '/home',
            ),
            TextButton(
                    child: const Text(
                      'Forgot Password? Click here',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      // Navigator.pushNamed(context, '/forgot-password');
                    },
                  ),
                  TextButton(
                    child: const Text(
                      'Don\'t have an account? Sign Up',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/');
                    },
                  ),
          ],
        ),
      ),
    );
  }
}