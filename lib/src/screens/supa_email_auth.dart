import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/src/utils/constants.dart';
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

  final _supaAuth = SupabaseAuthUi();

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
          spacer(16),
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
          spacer(16),
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
                  await _supaAuth.signInExistingUser(
                      _email.text, _password.text);
                  if (!mounted) return;
                  await successAlert(context);
                  if (mounted) {
                    Navigator.popAndPushNamed(
                        context, widget.redirectUrl ?? '/');
                  }
                } on GoTrueException catch (error) {
                  await warningAlert(context, error.message);
                } catch (error) {
                  await warningAlert(context, 'Unexpected error has occured');
                }
              } else {
                try {
                  await _supaAuth.createNewEmailUser(
                      _email.text, _password.text);
                  if (!mounted) return;
                  await successAlert(context);
                  if (mounted) {
                    Navigator.popAndPushNamed(
                        context, widget.redirectUrl ?? '/');
                  }
                } on GoTrueException catch (error) {
                  await warningAlert(context, error.message);
                } catch (error) {
                  await warningAlert(context, 'Unexpected error has occured');
                }
              }
              setState(() {
                _email.text = '';
                _password.text = '';
              });
            },
          ),
          spacer(10),
        ],
      ),
    );
  }
}
