import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

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

final supa = Supabase.instance.client;
