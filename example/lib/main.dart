import 'package:example/phone_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

import './home.dart';
import './sign_up.dart';
import './sign_in.dart';
import './magic_link.dart';
import './forgot_password.dart';
import './update_password.dart';
import 'phone_sign_in.dart';
import './verify_phone.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await SupabaseAuthUi().initSupabase(
    dotenv.env['SUPABASE_URL']!,
    dotenv.env['SUPABASE_ANON_KEY']!,
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
        primarySwatch: Colors.blue,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SignUp(),
        '/sign_in': (context) => const SignIn(),
        '/magic_link': (context) => const MagicLink(),
        '/forgot_password': (context) => const ForgotPassword(),
        '/update_password': (context) => const UpdatePassword(),
        '/phone_sign_in': (context) => const PhoneSignIn(),
        '/phone_sign_up': (context) => const PhoneSignUp(),
        '/verify_phone': (context) => const VerifyPhone(),
        '/home': (context) => const Home(),
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
