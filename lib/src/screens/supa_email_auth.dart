import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/src/utils/constants.dart';
import 'package:supabase_auth_ui/src/utils/supabase_auth_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum AuthAction { signIn, signUp }

class SupaEmailAuth extends StatefulWidget {
  final AuthAction authAction;
  final String? redirectUrl;
  final void Function(GotrueSessionResponse response)? onSuccess;
  final bool Function(GoTrueException error)? onError;

  const SupaEmailAuth(
      {Key? key,
      required this.authAction,
      this.redirectUrl,
      this.onSuccess,
      this.onError})
      : super(key: key);

  @override
  State<SupaEmailAuth> createState() => _SupaEmailAuthState();
}

class _SupaEmailAuthState extends State<SupaEmailAuth> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  final _supaAuth = SupabaseAuthUi();

  bool isLoading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSigningIn = widget.authAction == AuthAction.signIn;

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
            child: (isLoading)
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 1.5,
                    ),
                  )
                : Text(
                    isSigningIn ? 'Sign In' : 'Sign Up',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              if (!_formKey.currentState!.validate()) {
                return;
              }
              try {
                if (isSigningIn == false) {
                  try {
                    await _supaAuth.createNewEmailUser(
                        _email.text, _password.text,
                        redirectUrl: widget.redirectUrl);
                  } on GoTrueException catch (error) {
                    if (error.message != "User already registered") rethrow;
                  }
                }
                // Always call SignIn to support case where the user exists, or no email confirmation are needed
                final result = await _supaAuth.signInExistingUser(
                    _email.text, _password.text);
                widget.onSuccess?.call(result);
                if (mounted) {
                  successSnackBar(context, 'Successfully signed in !');
                }
              } on GoTrueException catch (error) {
                if (widget.onError == null ||
                    widget.onError?.call(error) == false) {
                  await warningSnackBar(context, error.message);
                }
              } catch (error) {
                await warningSnackBar(
                    context, 'Unexpected error has occurred: $error');
              }
              if (mounted) {
                setState(() {
                  isLoading = false;
                });
              }
            },
          ),
          spacer(10),
        ],
      ),
    );
  }
}
