import 'package:example/phone_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

import './home.dart';
import './sign_in.dart';
import './magic_link.dart';
import './update_password.dart';
import 'phone_sign_in.dart';
import './verify_phone.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// TODO: replace with your credentials
  await Supabase.initialize(
    url: 'https://yoursupabaseurl.supabase.co',
    anonKey: 'your_anon_key',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/sign_in': (context) => const SignIn(),
        '/magic_link': (context) => const MagicLink(),
        '/update_password': (context) => const UpdatePassword(),
        '/phone_sign_in': (context) => const PhoneSignIn(),
        '/phone_sign_up': (context) => const PhoneSignUp(),
        '/verify_phone': (context) => const VerifyPhone(),
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (BuildContext context) => const Scaffold(
            body: Center(
              child: Text(
                'Not Found',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
