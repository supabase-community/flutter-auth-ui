import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

import 'constants.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Sign Up'),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          SupaEmailAuth(
            authAction: SupaAuthAction.signUp,
            redirectUrl: '/home',
            onSuccess: (_) {
              Navigator.of(context).pushReplacementNamed('/home');
            },
            metadataFields: [
              MetaDataField(
                prefixIcon: const Icon(Icons.person),
                label: 'Username',
                key: 'username',
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Please enter something';
                  }
                  return null;
                },
              ),
            ],
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
          const Divider(),
          optionText,
          spacer,
          ElevatedButton.icon(
            onPressed: () {
              Navigator.popAndPushNamed(context, '/magic_link');
            },
            icon: const Icon(Icons.email),
            label: const Text('Sign in with Magic Link'),
          ),
          spacer,
          ElevatedButton.icon(
            onPressed: () {
              Navigator.popAndPushNamed(context, '/phone_sign_up');
            },
            icon: const Icon(Icons.phone),
            label: const Text('Sign up with Phone'),
          ),
          spacer,
          SupaSocialsAuth(
            colored: true,
            socialProviders: SocialProviders.values,
            onSuccess: (session) {
              Navigator.of(context).pushReplacementNamed('/home');
            },
          ),
        ],
      ),
    );
  }
}
