import 'package:flutter/material.dart';

/// Internal password field component with visibility toggle
class SupaPasswordField extends StatefulWidget {
  /// Controller for the password field
  final TextEditingController controller;

  /// Validator function for the password field
  final String? Function(String?)? validator;

  /// Label text for the password field
  final String labelText;

  /// Prefix icon for the password field
  final Widget? prefixIcon;

  /// Autofill hints for the password field
  final Iterable<String>? autofillHints;

  /// Text input action for the password field
  final TextInputAction? textInputAction;

  /// Callback when field is submitted
  final void Function(String)? onFieldSubmitted;

  /// Whether the field should auto-validate
  final AutovalidateMode? autovalidateMode;

  const SupaPasswordField({
    super.key,
    required this.controller,
    this.validator,
    required this.labelText,
    this.prefixIcon,
    this.autofillHints,
    this.textInputAction,
    this.onFieldSubmitted,
    this.autovalidateMode,
  });

  @override
  State<SupaPasswordField> createState() => _SupaPasswordFieldState();
}

class _SupaPasswordFieldState extends State<SupaPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      obscureText: _obscureText,
      autofillHints: widget.autofillHints,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      autovalidateMode: widget.autovalidateMode,
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon,
        label: Text(widget.labelText),
        suffixIcon: Tooltip(
          message: _obscureText ? 'Show password' : 'Hide password',
          child: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ),
      ),
    );
  }
}
