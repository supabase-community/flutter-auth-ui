import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

import 'constants.dart';

class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Sign In'),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          SupaEmailAuth(
            authAction: SupaAuthAction.signIn,
            onSuccess: (response) {
              Navigator.of(context).pushReplacementNamed('/home');
            },
          ),
          TextButton(
            child: const Text(
              'Forgot Password? Click here',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/forgot_password');
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
          const Divider(),
          optionText,
          spacer,
          ElevatedButton.icon(
            icon: const Icon(Icons.email),
            onPressed: () {
              Navigator.popAndPushNamed(context, '/magic_link');
            },
            label: const Text('Sign in with Magic Link'),
          ),
          spacer,
          ElevatedButton.icon(
            onPressed: () {
              Navigator.popAndPushNamed(context, '/phone_sign_in');
            },
            icon: const Icon(Icons.phone),
            label: const Text('Sign in with Phone'),
          ),
        ],
      ),
    );
  }
}
