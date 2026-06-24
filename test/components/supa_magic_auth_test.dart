import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

import '../test_utils.dart';

void main() {
  setUpAll(initializeSupabaseForTest);
  setUp(() => testServer.reset());

  Widget buildForm({
    void Function(Session session)? onSuccess,
    void Function(Object error)? onError,
    bool showSnackBars = true,
  }) {
    return wrapForTest(
      SupaMagicAuth(
        onSuccess: onSuccess ?? (_) {},
        onError: onError,
        showSnackBars: showSnackBars,
      ),
    );
  }

  testWidgets('renders the email field and magic link button', (tester) async {
    await tester.pumpWidget(buildForm());

    expect(find.text('Enter your email'), findsOneWidget);
    expect(
      find.widgetWithText(ElevatedButton, 'Continue with magic Link'),
      findsOneWidget,
    );
  });

  testWidgets('shows an error for an invalid email', (tester) async {
    await tester.pumpWidget(buildForm());

    await tester.enterText(find.byType(TextFormField), 'not-an-email');
    await tester.tap(
      find.widgetWithText(ElevatedButton, 'Continue with magic Link'),
    );
    await tester.pump();

    expect(find.text('Please enter a valid email address'), findsOneWidget);
    expect(testServer.requests, isEmpty);
  });

  testWidgets('sends the magic link and shows a confirmation snack bar', (
    tester,
  ) async {
    await tester.pumpWidget(buildForm());

    await tester.enterText(find.byType(TextFormField), 'magic@example.com');
    await tester.tap(
      find.widgetWithText(ElevatedButton, 'Continue with magic Link'),
    );
    await tester.pumpAndSettle();

    expect(testServer.lastRequest!.url.path, contains('otp'));
    expect(testServer.lastBody['email'], 'magic@example.com');
    expect(find.text('Check your email inbox!'), findsOneWidget);
  });

  testWidgets('shows an error snack bar when the request fails', (
    tester,
  ) async {
    await tester.pumpWidget(buildForm());
    testServer.responder = (_) => errorResponse('Rate limit exceeded');

    await tester.enterText(find.byType(TextFormField), 'magic@example.com');
    await tester.tap(
      find.widgetWithText(ElevatedButton, 'Continue with magic Link'),
    );
    await tester.pumpAndSettle();

    expect(find.text('Rate limit exceeded'), findsOneWidget);
  });
}
