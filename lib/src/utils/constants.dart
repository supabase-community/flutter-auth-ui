import 'package:flutter/material.dart';

Future<void> successAlert(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(16),
        title: const Text(
          'Success',
          style: TextStyle(color: Colors.green),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green
              ),
            ),
          ),
        ],
      );
    },
  );
}

warningAlert(BuildContext context, String errMsg) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          errMsg,
          style: const TextStyle(color: Colors.redAccent),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.redAccent
              ),
            ),
          ),
        ],
      );
    },
  );
}

spacer(double height) {
  return SizedBox(
    height: height,
  );
}
