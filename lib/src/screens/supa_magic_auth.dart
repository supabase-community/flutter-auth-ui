import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/src/utils/constants.dart';
import 'package:supabase_auth_ui/src/utils/supabase_auth_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupaMagicAuth extends StatefulWidget {
  final String? redirectUrl;
  final void Function(GotrueSessionResponse response)? onSuccess;
  final bool Function(GoTrueException error)? onError;

  const SupaMagicAuth(
      {Key? key, this.redirectUrl, this.onSuccess, this.onError})
      : super(key: key);

  @override
  State<SupaMagicAuth> createState() => _SupaMagicAuthState();
}

class _SupaMagicAuthState extends State<SupaMagicAuth> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  final _supaAuth = SupabaseAuthUi();

  bool isLoading = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                : const Text(
                    'Continue with magic Link',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              if (!_formKey.currentState!.validate()) {
                return;
              }
              try {
                final result = await _supaAuth.createNewPasswordlessUser(
                    _email.text,
                    redirectUrl: widget.redirectUrl);
                widget.onSuccess?.call(result);
                if (mounted) {
                  successSnackBar(context, 'Created passwordless user !');
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
