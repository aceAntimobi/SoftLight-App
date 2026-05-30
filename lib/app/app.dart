import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../core/utils/locale_resolver.dart';
import '../features/light/presentation/soft_light_home_page.dart';
import '../l10n/app_strings.dart';

class SoftLightApp extends StatefulWidget {
  const SoftLightApp({super.key});

  @override
  State<SoftLightApp> createState() => _SoftLightAppState();
}

class _SoftLightAppState extends State<SoftLightApp>
    with WidgetsBindingObserver {
  Locale _appLocale = const Locale('en');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _appLocale = resolveSupportedLocale(
      WidgetsBinding.instance.platformDispatcher.locales,
      AppStrings.supportedLocales,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    setState(() {
      _appLocale = resolveSupportedLocale(locales, AppStrings.supportedLocales);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      locale: _appLocale,
      onGenerateTitle: (BuildContext context) =>
          AppStrings.of(context).appTitle,
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: AppStrings.supportedLocales,
      theme: const CupertinoThemeData(brightness: Brightness.dark),
      home: const SoftLightHomePage(),
    );
  }
}
