import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

import 'constants.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: ListView(
        padding: const EdgeInsets.all(24.0),
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
          const Divider(),
          optionText,
          spacer,
          magicSignInBtn(context),
          spacer,
          const SupaSocialsAuth(
            colored: true,
            socialProviders: [
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
          ),
        ],
      ),
    );
  }
}
