import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

import '../test_utils.dart';

void main() {
  setUpAll(initializeSupabaseForTest);
  setUp(() => testServer.reset());

  testWidgets('renders the code field and verify button', (tester) async {
    await tester.pumpWidget(
      wrapWithRouteArguments(
        SupaVerifyPhone(onSuccess: (_) {}),
        {'phone': '+15551234567'},
      ),
    );

    expect(find.text('Enter the code sent'), findsOneWidget);
    expect(
      find.widgetWithText(ElevatedButton, 'Verify Phone'),
      findsOneWidget,
    );
  });

  testWidgets('shows an error when the code is empty', (tester) async {
    await tester.pumpWidget(
      wrapWithRouteArguments(
        SupaVerifyPhone(onSuccess: (_) {}),
        {'phone': '+15551234567'},
      ),
    );

    await tester.tap(find.widgetWithText(ElevatedButton, 'Verify Phone'));
    await tester.pump();

    expect(
      find.text('Please enter the one time code sent'),
      findsOneWidget,
    );
    expect(testServer.requests, isEmpty);
  });

  testWidgets('verifies the OTP and reports success', (tester) async {
    AuthResponse? response;
    await tester.pumpWidget(
      wrapWithRouteArguments(
        SupaVerifyPhone(onSuccess: (r) => response = r),
        {'phone': '+15551234567'},
      ),
    );

    await tester.enterText(find.byType(TextFormField), '123456');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Verify Phone'));
    await tester.pumpAndSettle();

    expect(response, isNotNull);
    expect(testServer.lastRequest!.url.path, contains('verify'));
    expect(testServer.lastBody['phone'], '+15551234567');
    expect(testServer.lastBody['token'], '123456');
  });

  testWidgets('clears the code field after verifying', (tester) async {
    await tester.pumpWidget(
      wrapWithRouteArguments(
        SupaVerifyPhone(onSuccess: (_) {}),
        {'phone': '+15551234567'},
      ),
    );

    await tester.enterText(find.byType(TextFormField), '123456');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Verify Phone'));
    await tester.pumpAndSettle();

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.controller!.text, isEmpty);
  });

  testWidgets('shows an error snack bar when verification fails', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapWithRouteArguments(
        SupaVerifyPhone(onSuccess: (_) {}),
        {'phone': '+15551234567'},
      ),
    );
    testServer.responder = (_) => errorResponse('Token has expired');

    await tester.enterText(find.byType(TextFormField), '123456');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Verify Phone'));
    await tester.pumpAndSettle();

    expect(find.text('Token has expired'), findsOneWidget);
  });
}
