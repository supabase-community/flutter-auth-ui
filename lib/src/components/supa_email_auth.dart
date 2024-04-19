import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/src/localizations/supa_email_auth_localization.dart';
import 'package:supabase_auth_ui/src/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Information about the metadata to pass to the signup form
///
/// You can use this object to create additional fields that will be passed to the metadata of the user upon signup.
/// For example, in order to create additional `username` field, you can use the following:
/// ```dart
/// MetaDataField(label: 'Username', key: 'username')
/// ```
///
/// Which will update the user's metadata in like the following:
///
/// ```dart
/// { 'username': 'Whatever your user entered' }
/// ```
class MetaDataField {
  /// Label of the `TextFormField` for this metadata
  final String label;

  /// Key to be used when sending the metadata to Supabase
  final String key;

  /// Validator function for the metadata field
  final String? Function(String?)? validator;

  /// Icon to show as the prefix icon in TextFormField
  final Icon? prefixIcon;

  MetaDataField({
    required this.label,
    required this.key,
    this.validator,
    this.prefixIcon,
  });
}

/// {@template supa_email_auth}
/// UI component to create email and password signup/ signin form
///
/// ```dart
/// SupaEmailAuth(
///   onSignInComplete: (response) {
///     // handle sign in complete here
///   },
///   onSignUpComplete: (response) {
///     // handle sign up complete here
///   },
/// ),
/// ```
/// {@endtemplate}
class SupaEmailAuth extends StatefulWidget {
  /// The URL to redirect the user to when clicking on the link on the
  /// confirmation link after signing up.
  final String? redirectTo;

  /// Callback for the user to complete a sign in.
  final void Function(AuthResponse response) onSignInComplete;

  /// Callback for the user to complete a signUp.
  ///
  /// If email confirmation is turned on, the user is
  final void Function(AuthResponse response) onSignUpComplete;

  /// Callback for sending the password reset email
  final void Function()? onPasswordResetEmailSent;

  /// Callback for when the auth action threw an exception
  ///
  /// If set to `null`, a snack bar with error color will show up.
  final void Function(Object error)? onError;

  /// Set of additional fields to the signup form that will become
  /// part of the user_metadata
  final List<MetaDataField>? metadataFields;

  /// Additional properties for user_metadata on signup
  final Map<String, dynamic>? extraMetadata;

  /// Localization for the form
  final SupaEmailAuthLocalization localization;

  /// {@macro supa_email_auth}
  const SupaEmailAuth({
    Key? key,
    this.redirectTo,
    required this.onSignInComplete,
    required this.onSignUpComplete,
    this.onPasswordResetEmailSent,
    this.onError,
    this.metadataFields,
    this.extraMetadata,
    this.localization = const SupaEmailAuthLocalization(),
  }) : super(key: key);

  @override
  State<SupaEmailAuth> createState() => _SupaEmailAuthState();
}

class _SupaEmailAuthState extends State<SupaEmailAuth> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final Map<MetaDataField, TextEditingController> _metadataControllers;

  bool _isLoading = false;

  /// The user has pressed forgot password button
  bool _forgotPassword = false;

  bool _isSigningIn = true;

  @override
  void initState() {
    super.initState();
    _metadataControllers = Map.fromEntries((widget.metadataFields ?? []).map(
        (metadataField) => MapEntry(metadataField, TextEditingController())));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    for (final controller in _metadataControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = widget.localization;
    return AutofillGroup(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              textInputAction:
                  _forgotPassword ? TextInputAction.done : TextInputAction.next,
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    !EmailValidator.validate(_emailController.text)) {
                  return localization.validEmailError;
                }
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email),
                label: Text(localization.enterEmail),
              ),
              controller: _emailController,
            ),
            if (!_forgotPassword) ...[
              spacer(16),
              TextFormField(
                autofillHints: _isSigningIn
                    ? [AutofillHints.password]
                    : [AutofillHints.newPassword],
                textInputAction: widget.metadataFields != null && !_isSigningIn
                    ? TextInputAction.next
                    : TextInputAction.done,
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 6) {
                    return localization.passwordLengthError;
                  }
                  return null;
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  label: Text(localization.enterPassword),
                ),
                obscureText: true,
                controller: _passwordController,
              ),
              spacer(16),
              if (widget.metadataFields != null && !_isSigningIn)
                ...widget.metadataFields!
                    .map((metadataField) => [
                          TextFormField(
                            controller: _metadataControllers[metadataField],
                            textInputAction:
                                widget.metadataFields!.last == metadataField
                                    ? TextInputAction.done
                                    : TextInputAction.next,
                            decoration: InputDecoration(
                              label: Text(metadataField.label),
                              prefixIcon: metadataField.prefixIcon,
                            ),
                            validator: metadataField.validator,
                          ),
                          spacer(16),
                        ])
                    .expand((element) => element),
              ElevatedButton(
                child: (_isLoading)
                    ? SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.onPrimary,
                          strokeWidth: 1.5,
                        ),
                      )
                    : Text(_isSigningIn
                        ? localization.signIn
                        : localization.signUp),
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                  setState(() {
                    _isLoading = true;
                  });
                  try {
                    if (_isSigningIn) {
                      final response = await supabase.auth.signInWithPassword(
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                      );
                      widget.onSignInComplete.call(response);
                    } else {
                      final response = await supabase.auth.signUp(
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                        emailRedirectTo: widget.redirectTo,
                        data: _resolveData(),
                      );
                      widget.onSignUpComplete.call(response);
                    }
                  } on AuthException catch (error) {
                    if (widget.onError == null && context.mounted) {
                      context.showErrorSnackBar(error.message);
                    } else {
                      widget.onError?.call(error);
                    }
                  } catch (error) {
                    if (widget.onError == null && context.mounted) {
                      context.showErrorSnackBar(
                          '${localization.unexpectedError}: $error');
                    } else {
                      widget.onError?.call(error);
                    }
                  }
                  if (mounted) {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                },
              ),
              spacer(16),
              if (_isSigningIn) ...[
                TextButton(
                  onPressed: () {
                    setState(() {
                      _forgotPassword = true;
                    });
                  },
                  child: Text(localization.forgotPassword),
                ),
              ],
              TextButton(
                key: const ValueKey('toggleSignInButton'),
                onPressed: () {
                  setState(() {
                    _forgotPassword = false;
                    _isSigningIn = !_isSigningIn;
                  });
                },
                child: Text(_isSigningIn
                    ? localization.dontHaveAccount
                    : localization.haveAccount),
              ),
            ],
            if (_isSigningIn && _forgotPassword) ...[
              spacer(16),
              ElevatedButton(
                onPressed: () async {
                  try {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    setState(() {
                      _isLoading = true;
                    });

                    final email = _emailController.text.trim();
                    await supabase.auth.resetPasswordForEmail(
                      email,
                      redirectTo: widget.redirectTo,
                    );
                    widget.onPasswordResetEmailSent?.call();
                    // FIX use_build_context_synchronously
                    if (!context.mounted) return;
                    context.showSnackBar(localization.passwordResetSent);
                    setState(() {
                      _forgotPassword = false;
                    });
                  } on AuthException catch (error) {
                    widget.onError?.call(error);
                  } catch (error) {
                    widget.onError?.call(error);
                  } finally {
                    if (mounted) {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  }
                },
                child: Text(localization.sendPasswordReset),
              ),
              spacer(16),
              TextButton(
                onPressed: () {
                  setState(() {
                    _forgotPassword = false;
                  });
                },
                child: Text(localization.backToSignIn),
              ),
            ],
            spacer(16),
          ],
        ),
      ),
    );
  }

  /// Resolve the user_metadata that we will send during sign-up
  ///
  /// In case both MetadataFields and extraMetadata have the same
  /// key in their map, the MetadataFields (form fields) win
  Map<String, dynamic> _resolveData() {
    var extra = widget.extraMetadata ?? <String, dynamic>{};
    extra.addAll(_resolveMetadataFieldsData());
    return extra;
  }

  /// Resolve the user_metadata coming from the metadataFields
  Map<String, dynamic> _resolveMetadataFieldsData() {
    return widget.metadataFields != null
        ? _metadataControllers.map<String, dynamic>(
            (metaDataField, controller) =>
                MapEntry(metaDataField.key, controller.text))
        : <String, dynamic>{};
  }
}
