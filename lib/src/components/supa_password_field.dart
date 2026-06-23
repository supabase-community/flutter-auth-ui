import 'package:flutter/material.dart';

/// Internal password field with a visibility toggle.
class SupaPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final AutovalidateMode? autovalidateMode;

  const SupaPasswordField({
    super.key,
    required this.controller,
    required this.labelText,
    this.validator,
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
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IconButton(
            tooltip: _obscureText ? 'Show password' : 'Hide password',
            icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => _obscureText = !_obscureText),
          ),
        ),
      ),
    );
  }
}
