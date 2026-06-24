import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_auth_ui/src/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('defaultPasswordValidator', () {
    final validate = defaultPasswordValidator('too short');

    test('returns the error for a null value', () {
      expect(validate(null), 'too short');
    });

    test('returns the error for an empty value', () {
      expect(validate(''), 'too short');
    });

    test('returns the error for a value shorter than 6 characters', () {
      expect(validate('12345'), 'too short');
    });

    test('returns null for a value with exactly 6 characters', () {
      expect(validate('123456'), isNull);
    });

    test('returns null for a value longer than 6 characters', () {
      expect(validate('1234567'), isNull);
    });
  });

  group('handleAuthError', () {
    testWidgets('calls onError when provided and never shows a snack bar', (
      tester,
    ) async {
      Object? captured;
      late BuildContext capturedContext;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                capturedContext = context;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      final error = Exception('boom');
      handleAuthError(
        capturedContext,
        error,
        onError: (e) => captured = e,
        showSnackBars: true,
        unexpectedErrorText: 'Unexpected',
      );
      await tester.pump();

      expect(captured, error);
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('shows the message of an AuthException in a snack bar', (
      tester,
    ) async {
      late BuildContext capturedContext;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                capturedContext = context;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      handleAuthError(
        capturedContext,
        const AuthException('Invalid credentials'),
        onError: null,
        showSnackBars: true,
        unexpectedErrorText: 'Unexpected',
      );
      await tester.pump();

      expect(find.text('Invalid credentials'), findsOneWidget);
    });

    testWidgets('prefixes non-auth errors with the unexpected error text', (
      tester,
    ) async {
      late BuildContext capturedContext;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                capturedContext = context;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      handleAuthError(
        capturedContext,
        'plain error',
        onError: null,
        showSnackBars: true,
        unexpectedErrorText: 'Unexpected',
      );
      await tester.pump();

      expect(find.text('Unexpected: plain error'), findsOneWidget);
    });

    testWidgets('does not show a snack bar when showSnackBars is false', (
      tester,
    ) async {
      late BuildContext capturedContext;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                capturedContext = context;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      handleAuthError(
        capturedContext,
        const AuthException('Invalid credentials'),
        onError: null,
        showSnackBars: false,
        unexpectedErrorText: 'Unexpected',
      );
      await tester.pump();

      expect(find.byType(SnackBar), findsNothing);
    });
  });

  group('ShowSnackBar extension', () {
    testWidgets('showSnackBar displays the message with a default action', (
      tester,
    ) async {
      late BuildContext capturedContext;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                capturedContext = context;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      capturedContext.showSnackBar('Hello');
      await tester.pump();

      expect(find.text('Hello'), findsOneWidget);
      expect(find.text('ok'), findsOneWidget);
    });

    testWidgets('showErrorSnackBar uses the error container colors', (
      tester,
    ) async {
      late BuildContext capturedContext;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                capturedContext = context;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      capturedContext.showErrorSnackBar('Bad');
      await tester.pump();

      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      final theme = Theme.of(capturedContext);
      expect(snackBar.backgroundColor, theme.colorScheme.errorContainer);
    });
  });

  test('spacer returns a SizedBox of the given height', () {
    final box = spacer(24);
    expect(box.height, 24);
  });
}
