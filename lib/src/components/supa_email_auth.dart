import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/src/utils/supa_auth_action.dart';
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

/// UI component to create email and password signup/ signin form
class SupaEmailAuth extends StatefulWidget {
  /// Whether the user is sining in or signin up
  final SupaAuthAction authAction;

  /// `redirectUrl` to be passed to the `.signIn()` or `signUp()` methods
  ///
  /// Typically used to pass a DeepLink
  final String? redirectUrl;

  /// Method to be called when the auth action is success
  final void Function(GotrueSessionResponse response) onSuccess;

  /// Method to be called when the auth action threw an excepction
  final void Function(Object error)? onError;

  final List<MetaDataField>? metadataFields;

  const SupaEmailAuth({
    Key? key,
    required this.authAction,
    this.redirectUrl,
    required this.onSuccess,
    this.onError,
    this.metadataFields,
  })  : assert(metadataFields == null || authAction == SupaAuthAction.signUp,
            'metadataFields can only be used for signUp'),
        super(key: key);

  @override
  State<SupaEmailAuth> createState() => _SupaEmailAuthState();
}

class _SupaEmailAuthState extends State<SupaEmailAuth> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  late final Map<MetaDataField, TextEditingController> _metadataControllers;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _metadataControllers = Map.fromEntries((widget.metadataFields ?? []).map(
        (metadataField) => MapEntry(metadataField, TextEditingController())));
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    for (final controller in _metadataControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSigningIn = widget.authAction == SupaAuthAction.signIn;

    return Form(
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
              label: Text('Enter your email'),
            ),
            controller: _email,
          ),
          spacer(16),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty || value.length < 6) {
                return 'Please enter a password that is at least 6 characters long';
              }
              return null;
            },
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.lock),
              label: Text('Enter your password'),
            ),
            obscureText: true,
            controller: _password,
          ),
          spacer(16),
          if (widget.metadataFields != null)
            ...widget.metadataFields!
                .map((metadataField) => [
                      TextFormField(
                        controller: _metadataControllers[metadataField],
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
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 1.5,
                    ),
                  )
                : Text(
                    isSigningIn ? 'Sign In' : 'Sign Up',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
            onPressed: () async {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              setState(() {
                _isLoading = true;
              });
              try {
                late final GotrueSessionResponse response;
                if (isSigningIn) {
                  response = await supaClient.auth.signIn(
                    email: _email.text,
                    password: _password.text,
                  );
                } else {
                  response = await supaClient.auth.signUp(
                    _email.text,
                    _password.text,
                    options: AuthOptions(
                      redirectTo: widget.redirectUrl,
                    ),
                    userMetadata: widget.metadataFields == null
                        ? null
                        : _metadataControllers.map<String, dynamic>(
                            (metaDataField, controller) =>
                                MapEntry(metaDataField.key, controller.text)),
                  );
                }
                widget.onSuccess.call(response);
                if (mounted) {
                  context.showSnackBar('Successfully signed in!');
                }
              } on GoTrueException catch (error) {
                if (widget.onError == null) {
                  context.showErrorSnackBar(error.message);
                  widget.onError?.call(error);
                }
              } catch (error) {
                context
                    .showErrorSnackBar('Unexpected error has occurred: $error');
                widget.onError?.call(error);
              }
              if (mounted) {
                setState(() {
                  _isLoading = false;
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
