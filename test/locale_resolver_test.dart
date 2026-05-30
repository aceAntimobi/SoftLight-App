import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soft_light/core/utils/locale_resolver.dart';

void main() {
  test('returns supported locale when language matches', () {
    final Locale locale = resolveSupportedLocale(
      const <Locale>[Locale('zh', 'CN')],
      const <Locale>[Locale('en'), Locale('zh')],
    );

    expect(locale.languageCode, 'zh');
  });

  test('falls back to english when locale is unsupported', () {
    final Locale locale = resolveSupportedLocale(
      const <Locale>[Locale('fr', 'FR')],
      const <Locale>[Locale('en'), Locale('zh')],
    );

    expect(locale.languageCode, 'en');
  });
}
