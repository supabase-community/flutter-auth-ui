import 'dart:developer';

import 'package:example/src/core/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';


import '../../core/constants.dart';

class PhoneSignIn extends StatelessWidget {
  const PhoneSignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Phone Sign In'),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            SupaPhoneAuth(
              authAction: SupaAuthAction.signIn,
              onSuccess: (AuthResponse response) {
                log('Phone Sign In Success: $response');
              },
            ),
            TextButton(
              child: const Text(
                'Don\'t have an account? Sign Up',
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
