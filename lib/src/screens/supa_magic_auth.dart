import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/src/utils/supabase_auth_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_auth_ui/src/utils/constants.dart';

class SupaMagicAuth extends StatefulWidget {
  final String? redirectUrl;

  const SupaMagicAuth({Key? key, this.redirectUrl}) : super(key: key);

  @override
  State<SupaMagicAuth> createState() => _SupaMagicAuthState();
}

class _SupaMagicAuthState extends State<SupaMagicAuth> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  SupabaseAuthUi supaAuth = SupabaseAuthUi();

  @override
  void initState() {
    super.initState();
  }

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
            child: const Text(
              'Sign Up with Magic Link',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              try {
                await supaAuth.createNewPasswordlessUser(_email.text);
                await successAlert(context);
                if (!mounted) return;
                Navigator.popAndPushNamed(context, widget.redirectUrl ?? '');
              } on GotrueError catch (error) {
                await warningAlert(context, error.message);
              } catch (error) {
                await warningAlert(context, 'Unexpected error has occured');
              }
              setState(() {
                _email.text = '';
              });
            },
          ),
          spacer(10),
        ],
      ),
    );
  }
}
