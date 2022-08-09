import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/src/utils/supabase_auth_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum AuthAction { signIn, signUp }

class SupaEmailAuth extends StatefulWidget {
  final AuthAction authAction;
  final String? redirectUrl;

  const SupaEmailAuth({Key? key, required this.authAction, this.redirectUrl})
      : super(key: key);

  @override
  State<SupaEmailAuth> createState() => _SupaEmailAuthState();
}

class _SupaEmailAuthState extends State<SupaEmailAuth> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  SupabaseAuthUi supaAuth = SupabaseAuthUi();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signingIn = widget.authAction == AuthAction.signIn;

    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            validator: (value) {
              if (value == null ||
                  value.isEmpty ||
                  !EmailValidator.validate(_email.text)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.email),
              hintText: 'Enter your email',
            ),
            controller: _email,
          ),
          const SizedBox(
            height: 16,
          ),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty || value.length < 6) {
                return 'Please enter a password that is atleast 6 characters long';
              }
              return null;
            },
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.lock),
              hintText: 'Enter your password',
            ),
            obscureText: true,
            controller: _password,
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
            child: Text(
              signingIn ? 'Sign In' : 'Sign Up',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              if (signingIn) {
                try {
                  await supaAuth.signInExistingUser(
                      _email.text, _password.text);
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AlertDialog(
                        title: Text('Success!'),
                        contentTextStyle: TextStyle(
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                  );
                  if (!mounted) return;
                  Navigator.popAndPushNamed(context, widget.redirectUrl ?? '');
                } on GoTrueException catch (error) {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(error.message),
                        contentTextStyle: const TextStyle(
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
                  );
                } catch (error) {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AlertDialog(
                        title: Text('Unexpected error has occured'),
                        contentTextStyle: TextStyle(
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
                  );
                }
              } else {
                try {
                  await supaAuth.createNewEmailUser(
                      _email.text, _password.text);
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AlertDialog(
                        title: Text('Success!'),
                        contentTextStyle: TextStyle(
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
                  );
                  if (!mounted) return;
                  Navigator.popAndPushNamed(context, widget.redirectUrl ?? '');
                } on GoTrueException catch (error) {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(error.message),
                        contentTextStyle: const TextStyle(
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
                  );
                } catch (error) {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AlertDialog(
                        title: Text('Unexpected error has occured'),
                        contentTextStyle: TextStyle(
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
                  );
                }
              }
              setState(() {
                _email.text = '';
                _password.text = '';
              });
            },
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
