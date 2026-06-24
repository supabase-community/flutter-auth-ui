import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

void main() {
  test('SupaAuthAction has signIn and signUp values', () {
    expect(SupaAuthAction.values, [
      SupaAuthAction.signIn,
      SupaAuthAction.signUp,
    ]);
  });
}
