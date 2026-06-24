import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

SizedBox spacer(double height) {
  return SizedBox(
    height: height,
  );
}

/// Default validator shared by the password fields.
///
/// Ensures the password is non-empty and at least 6 characters long.
String? Function(String?) defaultPasswordValidator(String lengthError) {
  return (value) {
    if (value == null || value.isEmpty || value.length < 6) {
      return lengthError;
    }
    return null;
  };
}

/// Handles an error thrown by an auth action in the same way across all forms.
///
/// Calls [onError] when provided, otherwise shows an error snack bar (when
/// [showSnackBars] is `true` and the [context] is still mounted). [AuthException]s
/// show their message, while any other error is prefixed with [unexpectedErrorText].
void handleAuthError(
  BuildContext context,
  Object error, {
  required void Function(Object error)? onError,
  required bool showSnackBars,
  required String unexpectedErrorText,
}) {
  if (onError == null && showSnackBars && context.mounted) {
    final message = error is AuthException
        ? error.message
        : '$unexpectedErrorText: $error';
    context.showErrorSnackBar(message);
  } else {
    onError?.call(error);
  }
}

/// Set of extension methods to easily display a snackbar
extension ShowSnackBar on BuildContext {
  /// Displays a basic snackbar
  void showSnackBar(
    String message, {
    Color? textColor,
    Color? backgroundColor,
    String? actionLabel,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: textColor == null ? null : TextStyle(color: textColor),
        ),
        backgroundColor: backgroundColor,
        action: SnackBarAction(
          label: actionLabel ?? 'ok',
          onPressed: () {},
        ),
      ),
    );
  }

  /// Displays a red snackbar indicating error
  void showErrorSnackBar(
    String message, {
    String? actionLabel,
  }) {
    showSnackBar(
      message,
      textColor: Theme.of(this).colorScheme.onErrorContainer,
      backgroundColor: Theme.of(this).colorScheme.errorContainer,
      actionLabel: actionLabel,
    );
  }
}
