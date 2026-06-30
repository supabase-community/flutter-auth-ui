import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/src/l10n/l10n_extension.dart';
import 'package:supabase_auth_ui/src/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// UI component to create magic link login form
class SupaMagicAuth extends StatefulWidget {
  /// `redirectUrl` to be passed to the `.signIn()` or `signUp()` methods
  ///
  /// Typically used to pass a DeepLink
  final String? redirectUrl;

  /// Method to be called when the auth action is success
  final void Function(Session response) onSuccess;

  /// Method to be called when the auth action threw an excepction
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

  const SupaMagicAuth({
    super.key,
    this.redirectUrl,
    required this.onSuccess,
    this.onError,
    this.showSnackBars = true,
    this.enableAutomaticFormSubmission = true,
  });

  @override
  State<SupaMagicAuth> createState() => _SupaMagicAuthState();
}

class _SupaMagicAuthState extends State<SupaMagicAuth> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  late final StreamSubscription<AuthState> _gotrueSubscription;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _gotrueSubscription = Supabase.instance.client.auth.onAuthStateChange
        .listen((data) {
          final session = data.session;
          if (session != null && mounted) {
            widget.onSuccess(session);
          }
        });
  }

  @override
  void dispose() {
    _email.dispose();
    _gotrueSubscription.cancel();
    super.dispose();
  }

  Future<void> _signInWithMagicLink() async {
    final localization = context.l10n;
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      await supabase.auth.signInWithOtp(
        email: _email.text,
        emailRedirectTo: widget.redirectUrl,
      );
      if (widget.showSnackBars && mounted) {
        context.showSnackBar(localization.checkYourEmail);
      }
    } catch (error) {
      if (mounted) {
        handleAuthError(
          context,
          error,
          onError: widget.onError,
          showSnackBars: widget.showSnackBars,
          unexpectedErrorText: localization.unexpectedError,
        );
      }
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
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
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            validator: (value) {
              if (value == null ||
                  value.isEmpty ||
                  !EmailValidator.validate(_email.text)) {
                return localization.validEmailError;
              }
              return null;
            },
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.email),
              label: Text(localization.enterEmail),
            ),
            controller: _email,
            onFieldSubmitted: (_) async {
              if (widget.enableAutomaticFormSubmission) {
                await _signInWithMagicLink();
              }
            },
          ),
          spacer(16),
          ElevatedButton(
            onPressed: _signInWithMagicLink,
            child: (_isLoading)
                ? SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.onPrimary,
                      strokeWidth: 1.5,
                    ),
                  )
                : Text(
                    localization.continueWithMagicLink,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
          ),
          spacer(10),
        ],
      ),
    );
  }
}
