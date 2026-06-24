import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_auth_ui/src/components/supa_password_field.dart';

import '../test_utils.dart';

void main() {
  testWidgets('obscures the text by default', (tester) async {
    await tester.pumpWidget(
      wrapForTest(
        SupaPasswordField(
          controller: TextEditingController(),
          labelText: 'Password',
        ),
      ),
    );

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.obscureText, isTrue);
    expect(find.byIcon(Icons.visibility_off), findsOneWidget);
  });

  testWidgets('toggles visibility when the suffix icon is tapped', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapForTest(
        SupaPasswordField(
          controller: TextEditingController(),
          labelText: 'Password',
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.visibility_off));
    await tester.pump();

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.obscureText, isFalse);
    expect(find.byIcon(Icons.visibility), findsOneWidget);
  });

  testWidgets('runs the provided validator', (tester) async {
    final formKey = GlobalKey<FormState>();
    await tester.pumpWidget(
      wrapForTest(
        Form(
          key: formKey,
          child: SupaPasswordField(
            controller: TextEditingController(),
            labelText: 'Password',
            validator: (value) => 'always invalid',
          ),
        ),
      ),
    );

    formKey.currentState!.validate();
    await tester.pump();

    expect(find.text('always invalid'), findsOneWidget);
  });

  testWidgets('renders the provided label and prefix icon', (tester) async {
    await tester.pumpWidget(
      wrapForTest(
        SupaPasswordField(
          controller: TextEditingController(),
          labelText: 'My password',
          prefixIcon: const Icon(Icons.lock),
        ),
      ),
    );

    expect(find.text('My password'), findsOneWidget);
    expect(find.byIcon(Icons.lock), findsOneWidget);
  });
}
