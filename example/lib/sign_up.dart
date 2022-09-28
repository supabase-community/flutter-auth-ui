import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

import 'constants.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('auth ui example'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          SupaEmailAuth(
            authAction: AuthAction.signUp,
            redirectUrl: '/home',
            onSuccess: (_) {
              Navigator.of(context).pushReplacementNamed('/home');
            },
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
          signInBtn(context, Icons.email, 'Sign in with Magic Link', () {
            Navigator.popAndPushNamed(context, '/magic_link');
          }),
          spacer,
          signInBtn(context, Icons.phone, 'Sign up with Phone', () {
            Navigator.popAndPushNamed(context, '/phone_sign_up');
          }),
          spacer,
          SupaSocialsAuth(
            colored: true,
            socialProviders: const [
              SocialProviders.apple,
              SocialProviders.azure,
              SocialProviders.bitbucket,
              SocialProviders.discord,
              SocialProviders.facebook,
              SocialProviders.github,
              SocialProviders.gitlab,
              SocialProviders.google,
              SocialProviders.slack,
              SocialProviders.spotify,
              SocialProviders.twitch,
              SocialProviders.twitter,
            ],
            onSuccess: () {
              Navigator.of(context).pushReplacementNamed('/home');
            },
          ),
        ],
      ),
    );
  }
}
