import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/src/components/supa_password_field.dart';
import 'package:supabase_auth_ui/src/l10n/l10n_extension.dart';
import 'package:supabase_auth_ui/src/utils/constants.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

/// UI component to create a phone + password signin/ signup form
class SupaPhoneAuth extends StatefulWidget {
  /// Whether the user is sining in or signin up
  final SupaAuthAction authAction;

  /// Method to be called when the auth action is success
  final void Function(AuthResponse response) onSuccess;

  /// Method to be called when the auth action threw an exception
  final void Function(Object error)? onError;

  /// Whether to show snack bars
  final bool showSnackBars;

  /// Whether pressing Enter on the on-screen keyboard should automatically
  /// submit the form.
  ///
  /// When set to `false`, the user must explicitly click the submit button
  /// to proceed with the authentication process.
  ///
  /// Defaults to `true` for backward compatibility.
  final bool enableAutomaticFormSubmission;

  const SupaPhoneAuth({
    super.key,
    required this.authAction,
    required this.onSuccess,
    this.onError,
    this.showSnackBars = true,
    this.enableAutomaticFormSubmission = true,
  });

  @override
  State<SupaPhoneAuth> createState() => _SupaPhoneAuthState();
}

class _SupaPhoneAuthState extends State<SupaPhoneAuth> {
  final _formKey = GlobalKey<FormState>();
  final _phone = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    final localization = context.l10n;
    final isSigningIn = widget.authAction == SupaAuthAction.signIn;
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      final AuthResponse response;
      if (isSigningIn) {
        response = await supabase.auth.signInWithPassword(
          phone: _phone.text,
          password: _password.text,
        );
      } else {
        final user = supabase.auth.currentUser;
        if (user?.isAnonymous == true) {
          await supabase.auth.updateUser(
            UserAttributes(
              phone: _phone.text,
              password: _password.text,
            ),
          );
          response = AuthResponse(session: supabase.auth.currentSession);
        } else {
          response = await supabase.auth.signUp(
            phone: _phone.text,
            password: _password.text,
          );
        }
      }
      if (!mounted) return;
      widget.onSuccess(response);
    } catch (error) {
      if (!mounted) return;
      handleAuthError(
        context,
        error,
        onError: widget.onError,
        showSnackBars: widget.showSnackBars,
        unexpectedErrorText: localization.unexpectedError,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = context.l10n;
    final isSigningIn = widget.authAction == SupaAuthAction.signIn;
    return AutofillGroup(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              autofillHints: const [AutofillHints.telephoneNumber],
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return localization.validPhoneNumberError;
                }
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.phone),
                label: Text(localization.enterPhoneNumber),
              ),
              controller: _phone,
            ),
            spacer(16),
            SupaPasswordField(
              controller: _password,
              labelText: localization.enterPassword,
              prefixIcon: const Icon(Icons.lock),
              autofillHints: isSigningIn
                  ? [AutofillHints.password]
                  : [AutofillHints.newPassword],
              textInputAction: TextInputAction.done,
              validator: defaultPasswordValidator(
                localization.passwordLengthError,
              ),
              onFieldSubmitted: (_) async {
                if (widget.enableAutomaticFormSubmission) {
                  await _submitForm();
                }
              },
            ),
            spacer(16),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text(
                isSigningIn ? localization.signIn : localization.signUp,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            spacer(10),
          ],
        ),
      ),
    );
  }
}
