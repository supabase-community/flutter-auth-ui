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

  /// The URL to redirect the user to when clicking on the link on the
  /// password recovery link.
  ///
  /// If unspecified, the [redirectTo] value will be used.
  final String? resetPasswordRedirectTo;

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

  /// Callback for toggling between sign in and sign up
  final void Function(bool isSigningIn)? onToggleSignIn;

  /// Callback for toggling between sign-in/ sign-up and password recovery
  final void Function(bool isRecoveringPassword)? onToggleRecoverPassword;

  /// Set of additional fields to the signup form that will become
  /// part of the user_metadata
  final List<MetaDataField>? metadataFields;

  /// Additional properties for user_metadata on signup
  final Map<String, dynamic>? extraMetadata;

  /// Localization for the form
  final SupaEmailAuthLocalization localization;

  /// Use icon in UI
  final bool isPrefixIcons;

  /// {@macro supa_email_auth}
  const SupaEmailAuth({
    super.key,
    this.redirectTo,
    this.resetPasswordRedirectTo,
    required this.onSignInComplete,
    required this.onSignUpComplete,
    this.onPasswordResetEmailSent,
    this.onError,
    this.onToggleSignIn,
    this.onToggleRecoverPassword,
    this.metadataFields,
    this.extraMetadata,
    this.localization = const SupaEmailAuthLocalization(),
    this.isPrefixIcons = true,
  });

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
  bool _isRecoveringPassword = false;

  /// Whether the user is signing in or signing up
  bool _isSigningIn = true;

  /// Focus node for email field
  final FocusNode _emailFocusNode = FocusNode();

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
              autovalidateMode: AutovalidateMode.onUserInteraction,
              autofocus: true,
              focusNode: _emailFocusNode,
              textInputAction: _isRecoveringPassword
                  ? TextInputAction.done
                  : TextInputAction.next,
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    !EmailValidator.validate(_emailController.text)) {
                  return localization.validEmailError;
                }
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: widget.isPrefixIcons ? const Icon(Icons.email) : null,
                label: Text(localization.enterEmail),
              ),
              controller: _emailController,
              onFieldSubmitted: (_) {
                if (_isRecoveringPassword) {
                  _passwordRecovery();
                }
              },
            ),
            if (!_isRecoveringPassword) ...[
              spacer(16),
              TextFormField(
                autofillHints: _isSigningIn
                    ? [AutofillHints.password]
                    : [AutofillHints.newPassword],
                autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  prefixIcon: widget.isPrefixIcons ? const Icon(Icons.email) : null,
                  label: Text(localization.enterPassword),
                ),
                obscureText: true,
                controller: _passwordController,
                onFieldSubmitted: (_) {
                  if (widget.metadataFields == null || _isSigningIn) {
                    _signInSignUp();
                  }
                },
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
                            onFieldSubmitted: (_) {
                              if (metadataField !=
                                  widget.metadataFields!.last) {
                                FocusScope.of(context).nextFocus();
                              } else {
                                _signInSignUp();
                              }
                            },
                          ),
                          spacer(16),
                        ])
                    .expand((element) => element),
              ElevatedButton(
                onPressed: _signInSignUp,
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
              ),
              spacer(16),
              if (_isSigningIn) ...[
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isRecoveringPassword = true;
                    });
                    widget.onToggleRecoverPassword?.call(_isRecoveringPassword);
                  },
                  child: Text(localization.forgotPassword),
                ),
              ],
              TextButton(
                key: const ValueKey('toggleSignInButton'),
                onPressed: () {
                  setState(() {
                    _isRecoveringPassword = false;
                    _isSigningIn = !_isSigningIn;
                  });
                  widget.onToggleSignIn?.call(_isSigningIn);
                  widget.onToggleRecoverPassword?.call(_isRecoveringPassword);
                },
                child: Text(_isSigningIn
                    ? localization.dontHaveAccount
                    : localization.haveAccount),
              ),
            ],
            if (_isSigningIn && _isRecoveringPassword) ...[
              spacer(16),
              ElevatedButton(
                onPressed: _passwordRecovery,
                child: Text(localization.sendPasswordReset),
              ),
              spacer(16),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isRecoveringPassword = false;
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

  void _signInSignUp() async {
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
        final user = supabase.auth.currentUser;
        late final AuthResponse response;
        if (user?.isAnonymous == true) {
          await supabase.auth.updateUser(
            UserAttributes(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
              data: _resolveData(),
            ),
            emailRedirectTo: widget.redirectTo,
          );
          final newSession = supabase.auth.currentSession;
          response = AuthResponse(session: newSession);
        } else {
          response = await supabase.auth.signUp(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            emailRedirectTo: widget.redirectTo,
            data: _resolveData(),
          );
        }
        widget.onSignUpComplete.call(response);
      }
    } on AuthException catch (error) {
      if (widget.onError == null && mounted) {
        context.showErrorSnackBar(error.message);
      } else {
        widget.onError?.call(error);
      }
      _emailFocusNode.requestFocus();
    } catch (error) {
      if (widget.onError == null && mounted) {
        context.showErrorSnackBar(
            '${widget.localization.unexpectedError}: $error');
      } else {
        widget.onError?.call(error);
      }
      _emailFocusNode.requestFocus();
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _passwordRecovery() async {
    try {
      if (!_formKey.currentState!.validate()) {
        // Focus on email field if validation fails
        _emailFocusNode.requestFocus();
        return;
      }
      setState(() {
        _isLoading = true;
      });

      final email = _emailController.text.trim();
      await supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: widget.resetPasswordRedirectTo ?? widget.redirectTo,
      );
      widget.onPasswordResetEmailSent?.call();
      // FIX use_build_context_synchronously
      if (!mounted) return;
      context.showSnackBar(widget.localization.passwordResetSent);
      setState(() {
        _isRecoveringPassword = false;
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
