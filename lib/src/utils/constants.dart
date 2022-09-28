import 'package:flutter/material.dart';

Future<void> successSnackBar(BuildContext context, String succMsg) async {
  final snackBar = SnackBar(
    content: Text(style: const TextStyle(color: Colors.green), succMsg),
    action: SnackBarAction(
      label: 'Ok',
      onPressed: () {},
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Future<void> warningSnackBar(BuildContext context, String errMsg) async {
  final snackBar = SnackBar(
    content: Text(style: const TextStyle(color: Colors.redAccent), errMsg),
    action: SnackBarAction(
      label: 'Ok',
      onPressed: () {},
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

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
    Color backgroundColor = Colors.white,
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
      backgroundColor: Colors.red,
      actionLabel: actionLabel,
    );
  }
}
