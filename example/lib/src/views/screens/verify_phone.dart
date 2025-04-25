import 'dart:developer';

import 'package:example/src/core/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

import '../../core/constants.dart';

class VerifyPhone extends StatelessWidget {
  const VerifyPhone({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Verify Phone'),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            SupaVerifyPhone(
              onSuccess: (response) {
                log("Verify Phone Success: $response");
               
              },
            ),
            TextButton(
              child: const Text(
                'Forgot Password? Click here',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                context.goNamed(AppRoute.updatePassword.name);
              },
            ),
            TextButton(
              child: const Text(
                'Take me back to Sign Up',
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
