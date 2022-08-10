import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/src/utils/supabase_auth_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_auth_ui/src/utils/constants.dart';

class SupaResetPassword extends StatefulWidget {
  final String accessToken;
  final String? redirectUrl;

  const SupaResetPassword(
      {Key? key, required this.accessToken, this.redirectUrl})
      : super(key: key);

  @override
  State<SupaResetPassword> createState() => _SupaResetPasswordState();
}

class _SupaResetPasswordState extends State<SupaResetPassword> {
  final _formKey = GlobalKey<FormState>();
  final _password = TextEditingController();

  SupabaseAuthUi supaAuth = SupabaseAuthUi();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _password.dispose();
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
              if (value == null || value.isEmpty || value.length < 6) {
                return 'Please enter a password that is atleast 6 characters long';
              }
              return null;
            },
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.lock),
              hintText: 'Enter your password',
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
                await supaAuth.updateUserPassword(
                    widget.accessToken, _password.text);
                successAlert;
                if (!mounted) return;
                Navigator.popAndPushNamed(context, widget.redirectUrl ?? '/');
              } on GoTrueException catch (error) {
                await warningAlert(context, error.message);
              } catch (error) {
                await warningAlert(context, 'Unexpected error has occured');
              }
              setState(() {
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
