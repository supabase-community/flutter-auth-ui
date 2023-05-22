import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/src/utils/constants.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

/// UI component to create a phone + password signin/ signup form
class SupaPhoneAuth extends StatefulWidget {
  /// Whether the user is sining in or signin up
  final SupaAuthAction authAction;

  /// Method to be called when the auth action is success
  final void Function(AuthResponse response) onSuccess;

  /// Method to be called when the auth action threw an excepction
  final void Function(Object error)? onError;

  const SupaPhoneAuth({
    Key? key,
    required this.authAction,
    required this.onSuccess,
    this.onError,
  }) : super(key: key);

  @override
  State<SupaPhoneAuth> createState() => _SupaPhoneAuthState();
}

class _SupaPhoneAuthState extends State<SupaPhoneAuth> {
  final _formKey = GlobalKey<FormState>();
  final _phone = TextEditingController();
  final _password = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSigningIn = widget.authAction == SupaAuthAction.signIn;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.phone),
              label: Text('Enter your phone number'),
            ),
            controller: _phone,
          ),
          spacer(16),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty || value.length < 6) {
                return 'Please enter a password that is at least 6 characters long';
              }
              return null;
            },
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.lock),
              label: Text('Enter your password'),
            ),
            obscureText: true,
            controller: _password,
          ),
          spacer(16),
          ElevatedButton(
            child: Text(
              isSigningIn ? 'Sign In' : 'Sign Up',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              try {
                if (isSigningIn) {
                  final response = await supabase.auth.signInWithPassword(
                    phone: _phone.text,
                    password: _password.text,
                  );
                  widget.onSuccess(response);
                } else {
                  final response = await supabase.auth
                      .signUp(phone: _phone.text, password: _password.text);
                  if (!mounted) return;
                  widget.onSuccess(response);
                }
              } on AuthException catch (error) {
                if (widget.onError == null) {
                  context.showErrorSnackBar(error.message);
                } else {
                  widget.onError?.call(error);
                }
              } catch (error) {
                if (widget.onError == null) {
                  context.showErrorSnackBar(
                      'Unexpected error has occurred: $error');
                } else {
                  widget.onError?.call(error);
                }
              }
              setState(() {
                _phone.text = '';
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
