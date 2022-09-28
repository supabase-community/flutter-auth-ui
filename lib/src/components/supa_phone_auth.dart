import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/src/utils/auth_action.dart';
import 'package:supabase_auth_ui/src/utils/constants.dart';
import 'package:supabase_auth_ui/src/utils/supabase_auth_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupaPhoneAuth extends StatefulWidget {
  final AuthAction phoneAuthAction;
  final String? redirectUrl;

  /// Method to be called when the auth action is success
  final void Function(GotrueSessionResponse response) onSuccess;

  /// Method to be called when the auth action threw an excepction
  final bool Function(Object error)? onError;

  const SupaPhoneAuth({
    Key? key,
    required this.phoneAuthAction,
    this.redirectUrl,
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

  final SupabaseAuthUi _supaAuth = SupabaseAuthUi();

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
    final isSigningIn = widget.phoneAuthAction == AuthAction.signIn;
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
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
              hintText: 'Enter your phone number',
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
              hintText: 'Enter your password',
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
              if (isSigningIn) {
                try {
                  final response = await _supaAuth.signInUserWithPhone(
                      _phone.text, _password.text);
                  if (!mounted) return;
                  context.showSnackBar('Successfully signed in !');
                  widget.onSuccess(response);
                } on GoTrueException catch (error) {
                  context.showErrorSnackBar(error.message);
                  widget.onError?.call(error);
                } catch (error) {
                  context.showErrorSnackBar(
                      'Unexpected error has occurred: $error');
                  widget.onError?.call(error);
                }
              } else {
                try {
                  final response = await _supaAuth.createNewPhoneUser(
                      _phone.text, _password.text);
                  if (!mounted) return;
                  context.showSnackBar('Successfully created !');
                  widget.onSuccess(response);
                } on GoTrueException catch (error) {
                  context.showErrorSnackBar(error.message);
                  widget.onError?.call(error);
                } catch (error) {
                  context.showErrorSnackBar(
                      'Unexpected error has occurred: $error');
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
