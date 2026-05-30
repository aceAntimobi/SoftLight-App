import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:screen_brightness/screen_brightness.dart';

abstract class ScreenBrightnessService {
  Future<double?> readBrightness();

  Future<void> setBrightness(double value);
}

class DeviceScreenBrightnessService implements ScreenBrightnessService {
  DeviceScreenBrightnessService({ScreenBrightness? plugin})
    : _plugin = plugin ?? ScreenBrightness.instance;

  final ScreenBrightness _plugin;

  @override
  Future<double?> readBrightness() async {
    if (kIsWeb) {
      return null;
    }
    try {
      final double value = await _plugin.application;
      return value;
    } on PlatformException {
      return null;
    } on MissingPluginException {
      return null;
    }
  }

  @override
  Future<void> setBrightness(double value) async {
    if (kIsWeb) {
      return;
    }
    try {
      await _plugin.setApplicationScreenBrightness(value.clamp(0.0, 1.0));
    } on PlatformException {
      // Ignore platform failures and keep the app usable.
    } on MissingPluginException {
      // Tests and unsupported platforms may not provide the plugin.
    }
  }
}
