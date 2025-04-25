import 'package:example/src/core/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

import '../../core/constants.dart';

class PhoneSignUp extends StatelessWidget {
  const PhoneSignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Phone Sign Up'),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            SupaPhoneAuth(
              authAction: SupaAuthAction.signUp,
              onSuccess: (response) {
                context.goNamed(AppRoute.verifyPhone.name);
              },
            ),
            TextButton(
              child: const Text(
                'Already have an account? Sign In',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                context.goNamed(AppRoute.signInUp.name);
              },
            ),
          ],
        ),
      ),
    );
  }
}
