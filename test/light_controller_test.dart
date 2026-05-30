import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soft_light/features/light/data/light_storage.dart';
import 'package:soft_light/features/light/data/screen_brightness_service.dart';
import 'package:soft_light/features/light/domain/light_preset.dart';
import 'package:soft_light/features/light/domain/light_session_state.dart';
import 'package:soft_light/features/light/state/light_controller.dart';

class _FakeLightStorage extends LightStorage {
  List<LightPreset> storedCustomPresets = <LightPreset>[];
  LightSessionState? storedSession;

  @override
  Future<List<LightPreset>> loadCustomPresets() async => storedCustomPresets;

  @override
  Future<LightSessionState?> loadSession() async => storedSession;

  @override
  Future<void> saveCustomPresets(List<LightPreset> presets) async {
    storedCustomPresets = List<LightPreset>.from(presets);
  }

  @override
  Future<void> saveSession(LightSessionState state) async {
    storedSession = state;
  }
}

class _FakeScreenBrightnessService implements ScreenBrightnessService {
  double value = 0.76;

  @override
  Future<double?> readBrightness() async => value;

  @override
  Future<void> setBrightness(double value) async {
    this.value = value;
  }
}

void main() {
  test('controller initializes with 12 built-in presets', () async {
    final LightController controller = LightController(
      storage: _FakeLightStorage(),
      screenBrightnessService: _FakeScreenBrightnessService(),
    );

    await controller.initialize();

    expect(controller.builtInPresets, hasLength(12));
    expect(controller.selectedBuiltInIndex, 0);
    expect(controller.isLightOn, isTrue);
    expect(controller.screenBrightness, 0.76);
  });

  test('saving custom presets is capped at 8 items', () async {
    final _FakeLightStorage storage = _FakeLightStorage();
    final LightController controller = LightController(
      storage: storage,
      screenBrightnessService: _FakeScreenBrightnessService(),
    );
    await controller.initialize();

    for (int i = 0; i < 10; i++) {
      await controller.applyManualColor(Color(0xFF000000 + i));
      await controller.saveCurrentColorAsPreset('Preset $i');
    }

    expect(controller.customPresets, hasLength(8));
    expect(storage.storedCustomPresets, hasLength(8));
  });

  test('switchMode cycles through built-in and custom presets', () async {
    final LightController controller = LightController(
      storage: _FakeLightStorage(),
      screenBrightnessService: _FakeScreenBrightnessService(),
    );
    await controller.initialize();
    await controller.applyManualColor(const Color(0xFFFFD6E8));
    await controller.saveCurrentColorAsPreset('My Pink');

    await controller.switchMode(1);

    expect(controller.selectedBuiltInIndex, 0);
    expect(controller.selectedCustomIndex, isNull);

    for (int i = 0; i < 12; i++) {
      await controller.switchMode(1);
    }

    expect(controller.selectedCustomIndex, 0);
  });

  test('screen brightness changes are persisted', () async {
    final _FakeLightStorage storage = _FakeLightStorage();
    final _FakeScreenBrightnessService brightnessService =
        _FakeScreenBrightnessService();
    final LightController controller = LightController(
      storage: storage,
      screenBrightnessService: brightnessService,
    );

    await controller.initialize();
    await controller.setScreenBrightness(0.55);

    expect(controller.screenBrightness, 0.55);
    expect(brightnessService.value, 0.55);
    expect(storage.storedSession?.screenBrightness, 0.55);
  });
}
