import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/src/utils/supa_auth_action.dart';
import 'package:supabase_auth_ui/src/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// UI component to create email and password signup/ signin form
class SupaEmailAuth extends StatefulWidget {
  /// Whether the user is sining in or signin up
  final SupaAuthAction authAction;

  /// `redirectUrl` to be passed to the `.signIn()` or `signUp()` methods
  ///
  /// Typically used to pass a DeepLink
  final String? redirectUrl;

  /// Method to be called when the auth action is success
  final void Function(GotrueSessionResponse response) onSuccess;

  /// Method to be called when the auth action threw an excepction
  final void Function(Object error)? onError;

  const SupaEmailAuth({
    Key? key,
    required this.authAction,
    this.redirectUrl,
    required this.onSuccess,
    this.onError,
  }) : super(key: key);

  @override
  State<SupaEmailAuth> createState() => _SupaEmailAuthState();
}

class _SupaEmailAuthState extends State<SupaEmailAuth> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSigningIn = widget.authAction == SupaAuthAction.signIn;

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
            child: (_isLoading)
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
              if (!_formKey.currentState!.validate()) {
                return;
              }
              setState(() {
                _isLoading = true;
              });
              try {
                late final GotrueSessionResponse response;
                if (isSigningIn) {
                  response = await supaClient.auth.signIn(
                    email: _email.text,
                    password: _password.text,
                  );
                } else {
                  response = await supaClient.auth.signUp(
                    _email.text,
                    _password.text,
                    options: AuthOptions(
                      redirectTo: widget.redirectUrl,
                    ),
                  );
                }
                widget.onSuccess.call(response);
                if (mounted) {
                  context.showSnackBar('Successfully signed in !');
                }
              } on GoTrueException catch (error) {
                if (widget.onError == null) {
                  context.showErrorSnackBar(error.message);
                  widget.onError?.call(error);
                }
              } catch (error) {
                context
                    .showErrorSnackBar('Unexpected error has occurred: $error');
                widget.onError?.call(error);
              }
              if (mounted) {
                setState(() {
                  _isLoading = false;
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
