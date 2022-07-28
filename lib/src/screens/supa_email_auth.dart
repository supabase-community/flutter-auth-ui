import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:supa_flutter_auth/supa_flutter_auth.dart';

enum AuthAction { signIn, signUp }

class SupaEmailAuth extends StatefulWidget {
  final AuthAction authAction;
  final String? redirectUrl;

  const SupaEmailAuth({Key? key, required this.authAction, this.redirectUrl})
      : super(key: key);

  @override
  _SupaEmailAuthState createState() => _SupaEmailAuthState();
}

class _SupaEmailAuthState extends State<SupaEmailAuth> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  SupabaseAuth supaAuth = SupabaseAuth();

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
              icon: Icon(Icons.email),
              border: OutlineInputBorder(),
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
              icon: Icon(Icons.lock),
              border: OutlineInputBorder(),
              hintText: 'Enter your password',
            ),
            controller: _password,
          ),
          const SizedBox(
            height: 16,
          ),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              child: Text(
                signingIn ? 'Sign In' : 'Sign Up',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate() && signingIn) {
                  final res = await supaAuth.signInExistingUser(
                      _email.text, _password.text);
                  if (res.error?.message != null) {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(res.error!.message),
                          contentTextStyle: const TextStyle(
                            backgroundColor: Colors.red,
                          ),
                        );
                      },
                    );
                    _email.text = '';
                    _password.text = '';
                  } else {
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
                    Navigator.popAndPushNamed(
                        context, widget.redirectUrl ?? '');
                  }
                } else {
                  final res = await supaAuth.createNewEmailUser(
                      _email.text, _password.text);
                  if (res.error?.message != null) {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(res.error!.message),
                          contentTextStyle: const TextStyle(
                            backgroundColor: Colors.red,
                          ),
                        );
                      },
                    );
                  } else {
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
                    Navigator.popAndPushNamed(
                        context, widget.redirectUrl ?? '');
                  }
                  _email.text = '';
                  _password.text = '';
                }
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
