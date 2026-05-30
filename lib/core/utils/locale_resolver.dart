import 'dart:ui';

Locale resolveSupportedLocale(
  List<Locale>? locales,
  List<Locale> supportedLocales,
) {
  final List<Locale> candidates = (locales == null || locales.isEmpty)
      ? <Locale>[PlatformDispatcher.instance.locale]
      : locales;

  for (final Locale candidate in candidates) {
    for (final Locale supported in supportedLocales) {
      if (candidate.languageCode == supported.languageCode) {
        return supported;
      }
    }
  }

  return const Locale('en');
}
