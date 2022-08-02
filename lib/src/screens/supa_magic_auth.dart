import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/src/utils/supabase_auth.dart';

class SupaMagicAuth extends StatefulWidget {
  final String? redirectUrl;

  const SupaMagicAuth({Key? key, this.redirectUrl}) : super(key: key);

  @override
  _SupaMagicAuthState createState() => _SupaMagicAuthState();
}

class _SupaMagicAuthState extends State<SupaMagicAuth> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  SupabaseAuth supaAuth = SupabaseAuth();

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
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
            child: const Text(
              'Sign Up with Magic Link',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final res =
                    await supaAuth.createNewPasswordlessUser(_email.text);
                if (res.error?.message != null) {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(res.error!.message),
                        contentTextStyle: const TextStyle(
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
                  );
                  _email.text = '';
                } else {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AlertDialog(
                        title: Text('Success!'),
                        contentTextStyle: TextStyle(
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                  );
                  if (!mounted) return;
                  Navigator.popAndPushNamed(context, widget.redirectUrl ?? '');
                }
              }
            },
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
