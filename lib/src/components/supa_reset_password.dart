import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/src/components/supa_password_field.dart';
import 'package:supabase_auth_ui/src/l10n/l10n_extension.dart';
import 'package:supabase_auth_ui/src/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// UI component to create password reset form
class SupaResetPassword extends StatefulWidget {
  /// accessToken of the user
  final String? accessToken;

  /// Whether to show snack bars
  final bool showSnackBars;

  /// Method to be called when the auth action is success
  final void Function(UserResponse response) onSuccess;

  /// Method to be called when the auth action threw an excepction
  final void Function(Object error)? onError;

  /// Whether pressing Enter on the on-screen keyboard should automatically
  /// submit the form.
  ///
  /// When set to `false`, the user must explicitly click the submit button
  /// to proceed with the authentication process.
  ///
  /// Defaults to `true` for backward compatibility.
  final bool enableAutomaticFormSubmission;

  const SupaResetPassword({
    super.key,
    this.accessToken,
    this.showSnackBars = true,
    required this.onSuccess,
    this.onError,
    this.enableAutomaticFormSubmission = true,
  });

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

  Future<void> _updatePassword() async {
    final localization = context.l10n;
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      final response = await supabase.auth.updateUser(
        UserAttributes(password: _password.text),
      );
      widget.onSuccess.call(response);
      // FIX use_build_context_synchronously
      if (!mounted) return;
      if (widget.showSnackBars) {
        context.showSnackBar(localization.passwordResetSent);
      }
    } catch (error) {
      if (!mounted) return;
      handleAuthError(
        context,
        error,
        onError: widget.onError,
        showSnackBars: widget.showSnackBars,
        unexpectedErrorText: localization.passwordLengthError,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = context.l10n;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SupaPasswordField(
            controller: _password,
            labelText: localization.enterPassword,
            prefixIcon: const Icon(Icons.lock),
            autofillHints: const [AutofillHints.newPassword],
            validator: defaultPasswordValidator(
              localization.passwordLengthError,
            ),
            onFieldSubmitted: (_) async {
              if (widget.enableAutomaticFormSubmission) {
                await _updatePassword();
              }
            },
          ),
          spacer(16),
          ElevatedButton(
            onPressed: _updatePassword,
            child: Text(
              localization.updatePassword,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          spacer(10),
        ],
      ),
    );
  }
}
