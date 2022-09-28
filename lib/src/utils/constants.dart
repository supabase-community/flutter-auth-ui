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
