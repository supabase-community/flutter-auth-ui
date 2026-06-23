import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

import 'constants.dart';

class SignInPrefilled extends StatelessWidget {
  const SignInPrefilled({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    void navigateHome(AuthResponse response) {
      Navigator.of(context).pushReplacementNamed('/home');
    }

    return Scaffold(
      appBar: appBar('Sign In (Prefilled)'),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          SupaEmailAuth(
            prefilledEmail: "mail@example.com",
            prefilledPassword: "password",
            redirectTo: kIsWeb ? null : 'io.supabase.flutter://',
            onSignInComplete: navigateHome,
            onSignUpComplete: navigateHome,
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
              BooleanMetaDataField(
                label: 'Keep me up to date with the latest news and updates.',
                key: 'marketing_consent',
                checkboxPosition: ListTileControlAffinity.leading,
              ),
              BooleanMetaDataField(
                key: 'terms_agreement',
                isRequired: true,
                checkboxPosition: ListTileControlAffinity.leading,
                richLabelSpans: [
                  const TextSpan(text: 'I have read and agree to the '),
                  TextSpan(
                    text: 'Terms and Conditions',
                    style: const TextStyle(
                      color: Colors.blue,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Handle tap on Terms and Conditions
                      },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
