import 'package:flutter/material.dart';

AppBar appBar(String title) => AppBar(
      title: Text(title),
      automaticallyImplyLeading: false,
    );

const optionText = Text(
  'Or',
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
  textAlign: TextAlign.center,
);

const spacer = SizedBox(
  height: 12,
);

ElevatedButton signInBtn(
  BuildContext context,
  IconData icon,
  String labelText,
  void Function() onPressed,
) {
  return ElevatedButton.icon(
    icon: Icon(icon),
    style: ButtonStyle(
      padding: MaterialStateProperty.all(
        const EdgeInsets.all(18),
      ),
    ),
    onPressed: onPressed,
    label: Text(
      labelText,
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
  );
}
