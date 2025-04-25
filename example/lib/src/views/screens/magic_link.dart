import 'dart:developer';

import 'package:example/src/core/app_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

import '../../core/constants.dart';

class MagicLink extends StatelessWidget {
  const MagicLink({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Magic Link'),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            SupaMagicAuth(
              onSuccess: (response) {
               log('Magic Link Sign In Success: ${response.toJson()}');
               
              },
              redirectUrl: kIsWeb
                  ? null
                  : 'io.supabase.flutterquickstart://login-callback',
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
