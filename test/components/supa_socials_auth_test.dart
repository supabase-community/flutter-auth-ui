import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

import '../test_utils.dart';

void main() {
  setUpAll(initializeSupabaseForTest);
  setUp(() => testServer.reset());

  testWidgets('shows an ErrorWidget when the provider list is empty', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapForTest(
        SupaSocialsAuth(socialProviders: const [], onSuccess: (_) {}),
      ),
    );

    expect(find.byType(ErrorWidget), findsOneWidget);
  });

  testWidgets('renders a labelled button per provider in iconAndText mode', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapForTest(
        SupaSocialsAuth(
          socialProviders: const [
            OAuthProvider.github,
            OAuthProvider.google,
          ],
          onSuccess: (_) {},
        ),
      ),
    );

    expect(find.text('Continue with Github'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);
    // `ElevatedButton.icon` returns an `ElevatedButton` subclass on some
    // Flutter versions, which `find.byType` would miss, so match by predicate.
    expect(
      find.byWidgetPredicate((widget) => widget is ElevatedButton),
      findsNWidgets(2),
    );
  });

  testWidgets('renders icon-only buttons without labels in icon mode', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapForTest(
        SupaSocialsAuth(
          socialProviders: const [OAuthProvider.github],
          socialButtonVariant: SocialButtonVariant.icon,
          onSuccess: (_) {},
        ),
      ),
    );

    expect(find.text('Continue with Github'), findsNothing);
    expect(
      find.byWidgetPredicate((widget) => widget is ElevatedButton),
      findsNothing,
    );
    expect(find.byType(InkResponse), findsOneWidget);
  });

  testWidgets('uses a custom label from oAuthButtonLabels when provided', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapForTest(
        SupaSocialsAuth(
          socialProviders: const [OAuthProvider.azure],
          oAuthButtonLabels: {OAuthProvider.azure: 'Microsoft (Azure)'},
          onSuccess: (_) {},
        ),
      ),
    );

    expect(find.text('Microsoft (Azure)'), findsOneWidget);
  });
}
