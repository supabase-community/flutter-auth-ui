import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/src/components/supa_password_field.dart';
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

  /// Localization for the form
  final SupaPhoneAuthLocalization localization;

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
    this.localization = const SupaPhoneAuthLocalization(),
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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    final localization = widget.localization;
    final isSigningIn = widget.authAction == SupaAuthAction.signIn;
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      if (isSigningIn) {
        final response = await supabase.auth.signInWithPassword(
          phone: _phone.text,
          password: _password.text,
        );
        widget.onSuccess(response);
      } else {
        late final AuthResponse response;
        final user = supabase.auth.currentUser;
        if (user?.isAnonymous == true) {
          await supabase.auth.updateUser(
            UserAttributes(
              phone: _phone.text,
              password: _password.text,
            ),
          );
        } else {
          response = await supabase.auth.signUp(
            phone: _phone.text,
            password: _password.text,
          );
        }
        if (!mounted) return;
        widget.onSuccess(response);
      }
    } on AuthException catch (error) {
      if (widget.onError == null && widget.showSnackBars && mounted) {
        context.showErrorSnackBar(error.message);
      } else {
        widget.onError?.call(error);
      }
    } catch (error) {
      if (widget.onError == null && widget.showSnackBars && mounted) {
        context.showErrorSnackBar('${localization.unexpectedError}: $error');
      } else {
        widget.onError?.call(error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = widget.localization;
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
              validator: (value) {
                if (value == null || value.isEmpty || value.length < 6) {
                  return localization.passwordLengthError;
                }
                return null;
              },
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
