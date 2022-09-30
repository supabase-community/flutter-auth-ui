import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supaClient = Supabase.instance.client;

SizedBox spacer(double height) {
  return SizedBox(
    height: height,
  );
}

/// Set of extension methods to easily display a snackbar
extension ShowSnackBar on BuildContext {
  /// Displays a basic snackbar
  void showSnackBar(
    String message, {
    Color? backgroundColor,
    String? actionLabel,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      action: SnackBarAction(
        label: actionLabel ?? 'ok',
        onPressed: () {},
      ),
    ));
  }

  /// Displays a red snackbar indicating error
  void showErrorSnackBar(
    String message, {
    String? actionLabel,
  }) {
    showSnackBar(
      message,
      backgroundColor: Theme.of(this).errorColor,
      actionLabel: actionLabel,
    );
  }
}

void handleError(
    BuildContext context, Object error, void Function(Object error)? onError) {
  if (onError != null) {
    onError.call(error);
    return;
  }
  if (error is GoTrueException) {
    context.showErrorSnackBar(error.message);
  } else {
    context.showErrorSnackBar('Unexpected error has occurred: $error');
  }
}
