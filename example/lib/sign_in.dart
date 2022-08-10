import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

import 'constants.dart';

class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: ListView(
        padding: const EdgeInsets.all(24.0),
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
          magicSignInBtn(context),
        ],
      ),
    );
  }
}
