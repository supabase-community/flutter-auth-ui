import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/src/utils/supabase_auth_ui.dart';
import 'package:supabase_auth_ui/src/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupaVerifyPhone extends StatefulWidget {
  final String? redirectUrl;

  const SupaVerifyPhone({Key? key, this.redirectUrl}) : super(key: key);

  @override
  State<SupaVerifyPhone> createState() => _SupaVerifyPhoneState();
}

class _SupaVerifyPhoneState extends State<SupaVerifyPhone> {
  Map? data;
  final _formKey = GlobalKey<FormState>();
  final _code = TextEditingController();

  SupabaseAuthUi supaAuth = SupabaseAuthUi();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)?.settings.arguments;
    if (args != null) data = args as Map;
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the one time code sent';
              }
              return null;
            },
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.code),
              hintText: 'Enter the code sent',
            ),
            controller: _code,
          ),
          spacer(16),
          ElevatedButton(
            child: const Text(
              'Verify Phone',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              try {
                await supaAuth.verifyPhoneUser(data!["phone"], _code.text);
                if (!mounted) return;
                await successSnackBar(context, 'Successfully verified !');
                if (mounted) {
                  Navigator.popAndPushNamed(context, widget.redirectUrl ?? '/');
                }
              } on GoTrueException catch (error) {
                await warningSnackBar(context, error.message);
              } catch (error) {
                await warningSnackBar(
                    context, 'Unexpected error has occurred: $error');
              }
              setState(() {
                _code.text = '';
              });
            },
          ),
          spacer(10),
        ],
      ),
    );
  }
}
