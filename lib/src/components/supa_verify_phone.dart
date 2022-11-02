import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/src/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// UI component for verifying phone number
class SupaVerifyPhone extends StatefulWidget {
  /// Method to be called when the auth action is success
  final void Function(AuthResponse response) onSuccess;

  /// Method to be called when the auth action threw an excepction
  final void Function(Object error)? onError;

  const SupaVerifyPhone({
    Key? key,
    required this.onSuccess,
    this.onError,
  }) : super(key: key);

  @override
  State<SupaVerifyPhone> createState() => _SupaVerifyPhoneState();
}

class _SupaVerifyPhoneState extends State<SupaVerifyPhone> {
  Map? data;
  final _formKey = GlobalKey<FormState>();
  final _code = TextEditingController();

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
              label: Text('Enter the code sent'),
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
                final response = await supaClient.auth.verifyOTP(
                  phone: data!["phone"],
                  token: _code.text,
                  type: OtpType.sms,
                );
                widget.onSuccess(response);
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
              if (mounted) {
                setState(() {
                  _code.text = '';
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
