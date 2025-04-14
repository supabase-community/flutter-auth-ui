import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/supabase-logo-icon.png',
              height: 100,
            ),
            const SizedBox(height: 20),
            const Text(
              'Welcome to Supabase Auth UI',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 42),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}