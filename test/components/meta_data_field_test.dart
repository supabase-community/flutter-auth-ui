import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

import '../test_utils.dart';

void main() {
  group('MetaDataField', () {
    test('stores its label, key, validator and icon', () {
      validator(String? _) => null;
      const icon = Icon(Icons.person);
      final field = MetaDataField(
        label: 'Username',
        key: 'username',
        validator: validator,
        prefixIcon: icon,
      );

      expect(field.label, 'Username');
      expect(field.key, 'username');
      expect(field.validator, validator);
      expect(field.prefixIcon, icon);
    });
  });

  group('BooleanMetaDataField', () {
    test('defaults value to false and isRequired to false', () {
      final field = BooleanMetaDataField(label: 'Consent', key: 'consent');

      expect(field.value, isFalse);
      expect(field.isRequired, isFalse);
      expect(field.checkboxPosition, ListTileControlAffinity.platform);
      expect(field.label, 'Consent');
    });

    test('asserts that either a label or rich label spans are provided', () {
      expect(
        () => BooleanMetaDataField(key: 'consent'),
        throwsAssertionError,
      );
    });

    test('accepts rich label spans without a plain label', () {
      final field = BooleanMetaDataField(
        key: 'terms',
        richLabelSpans: [const TextSpan(text: 'I agree')],
      );

      expect(field.label, isEmpty);
      expect(field.richLabelSpans, isNotNull);
    });

    testWidgets('getLabelWidget renders plain text from the label', (
      tester,
    ) async {
      final field = BooleanMetaDataField(label: 'Consent', key: 'consent');

      await tester.pumpWidget(
        wrapForTest(Builder(builder: field.getLabelWidget)),
      );

      expect(find.text('Consent'), findsOneWidget);
      expect(find.byType(RichText), findsWidgets);
    });

    testWidgets('getLabelWidget renders the rich label spans', (tester) async {
      final field = BooleanMetaDataField(
        key: 'terms',
        richLabelSpans: [
          const TextSpan(text: 'I agree to the '),
          TextSpan(
            text: 'Terms',
            recognizer: TapGestureRecognizer()..onTap = () {},
          ),
        ],
      );

      await tester.pumpWidget(
        wrapForTest(Builder(builder: field.getLabelWidget)),
      );

      final richText = tester.widget<RichText>(find.byType(RichText).first);
      expect(richText.text.toPlainText(), 'I agree to the Terms');
    });
  });
}
