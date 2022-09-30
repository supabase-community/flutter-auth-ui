import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_auth_ui/src/utils/constants.dart';

/// UI component to create password reset form
class SupaResetPassword extends StatefulWidget {
  /// accessToken of the user
  final String? accessToken;

  /// Method to be called when the auth action is success
  final void Function(GotrueUserResponse response) onSuccess;

  /// Method to be called when the auth action threw an excepction
  final void Function(Object error)? onError;

  const SupaResetPassword({
    Key? key,
    this.accessToken,
    required this.onSuccess,
    this.onError,
  }) : super(key: key);

  @override
  State<SupaResetPassword> createState() => _SupaResetPasswordState();
}

class _SupaResetPasswordState extends State<SupaResetPassword> {
  final _formKey = GlobalKey<FormState>();
  final _password = TextEditingController();

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accessToken =
        widget.accessToken ?? supaClient.auth.currentSession!.accessToken;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
            controller: _password,
          ),
          spacer(16),
          ElevatedButton(
            child: const Text(
              'Update Password',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              try {
                final response = await supaClient.auth.api.updateUser(
                  accessToken,
                  UserAttributes(
                    password: _password.text,
                  ),
                );
                widget.onSuccess.call(response);
              } catch (error) {
                handleError(context, error, widget.onError);
              }
            },
          ),
          spacer(10),
        ],
      ),
    );
  }
}
