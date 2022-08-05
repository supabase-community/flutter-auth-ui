import 'package:flutter/material.dart';

final appBar = AppBar(
  title: const Text('auth ui example'),
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

dynamic magicSignInBtn(BuildContext context) {
    return ElevatedButton(
    style: ButtonStyle(
      padding: MaterialStateProperty.all(
        const EdgeInsets.all(18),
      ),
    ),
    child: const Text(
      'Sign In with Magic Link',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
    onPressed: () {
      Navigator.pushNamed(context, '/magic_link');
    },
  );
}