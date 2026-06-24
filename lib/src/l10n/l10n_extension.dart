import 'package:flutter/widgets.dart';
import 'package:supabase_auth_ui/src/l10n/generated/supabase_auth_ui_localizations.dart';
import 'package:supabase_auth_ui/src/l10n/generated/supabase_auth_ui_localizations_en.dart';

extension SupabaseAuthUILocalizationsX on BuildContext {
  /// The [SupabaseAuthUILocalizations] resolved from the current locale.
  ///
  /// Falls back to English when the consumer has not registered
  /// [SupabaseAuthUILocalizations.delegate] on their app, so the widgets still
  /// render readable text.
  SupabaseAuthUILocalizations get l10n =>
      SupabaseAuthUILocalizations.of(this) ?? SupabaseAuthUILocalizationsEn();
}
