import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:supa_flutter_auth/supa_flutter_auth.dart';

class EmailPasswordAuth extends StatefulWidget {
  final String titleText;

  const EmailPasswordAuth({Key? key, required this.titleText}) : super(key: key);

  @override
  _EmailPasswordAuthState createState() => _EmailPasswordAuthState();
}

class _EmailPasswordAuthState extends State<EmailPasswordAuth> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

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
    return Center(
      child: Container(
        width: 800,
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.titleText,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
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
                    widget.titleText == 'Sign In' ? 'Sign In' : 'Sign Up',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate() &&
                        widget.titleText == 'Sign In') {
                      final res = await SupabaseAuth()
                          .signInExistingUser(_email.text, _password.text);
                      if (res.error?.message != null) {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(title: Text(res.error!.message),);
                            // AlertUI(
                            //   headerText: 'Error',
                            //   bodyText: res.error!.message,
                            //   closeAlertBtnText: 'Got it',
                            // );
                          },
                        );
                        _email.text = '';
                        _password.text = '';
                        // Navigator.pushNamed(context, '/');
                      } else {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const AlertDialog(title: Text('Success!'),);
                            // const AlertUI(
                            //   headerText: 'Success!',
                            //   bodyText:
                            //       'Registration successfully, taking you to home screen',
                            //   closeAlertBtnText: 'Got it',
                            // );
                          },
                        );
                        // Navigator.popAndPushNamed(context, '/home');
                      }
                    } else {
                      final res = await SupabaseAuth()
                          .createNewEmailUser(_email.text, _password.text);
                      if (res.error?.message != null) {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(title: Text(res.error!.message),);
                            // AlertUI(
                            //   headerText: 'Error',
                            //   bodyText: res.error!.message,
                            //   closeAlertBtnText: 'Got it',
                            // );
                          },
                        );
                        // Navigator.popAndPushNamed(context, '/');
                      } else {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const AlertDialog(title: Text('Success!'),);
                            // const AlertUI(
                            //   headerText: 'Success!',
                            //   bodyText:
                            //       'Registration successfully, taking you to home screen',
                            //   closeAlertBtnText: 'Got it',
                            // );
                          },
                        );
                        // Navigator.popAndPushNamed(context, '/home');
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
              if (widget.titleText == 'Sign In')
                Column(
                  children: [
                    TextButton(
                      child: const Text(
                        'Forgot Password? Click here',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        // Navigator.pushNamed(context, '/forgot-password');
                      },
                    ),
                    TextButton(
                      child: const Text(
                        'Don\'t have an account? Sign Up',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        // Navigator.pushNamed(context, '/sign-up');
                      },
                    ),
                  ],
                ),
              if (widget.titleText == 'Sign Up')
                TextButton(
                  child: const Text(
                    'Already have an account? Sign In',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    // Navigator.pushNamed(context, '/');
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}