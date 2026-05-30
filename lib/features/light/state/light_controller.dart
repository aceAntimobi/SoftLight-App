import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../data/light_storage.dart';
import '../data/screen_brightness_service.dart';
import '../domain/light_preset.dart';
import '../domain/light_session_state.dart';
import '../domain/timer_option.dart';

class LightController extends ChangeNotifier {
  LightController({
    LightStorage? storage,
    ScreenBrightnessService? screenBrightnessService,
  }) : _storage = storage ?? LightStorage(),
       _screenBrightnessService =
           screenBrightnessService ?? DeviceScreenBrightnessService();

  static const double minBrightness = 0.3;
  static const double maxBrightness = 1.0;
  static const double minScreenBrightness = 0.18;
  static const double maxScreenBrightness = 1.0;
  static const int maxCustomPresets = 8;
  static const List<TimerOption> timerOptions = <TimerOption>[
    TimerOption(15),
    TimerOption(30),
    TimerOption(45),
    TimerOption(60),
  ];

  final LightStorage _storage;
  final ScreenBrightnessService _screenBrightnessService;

  final List<LightPreset> builtInPresets = const <LightPreset>[
    LightPreset(
      id: 'pure-white',
      name: 'pureWhite',
      color: Color(0xFFFFFFFF),
      recommendedBrightness: 1.0,
      isBuiltIn: true,
    ),
    LightPreset(
      id: 'soft-white',
      name: 'softWhite',
      color: Color(0xFFFEFEFF),
      recommendedBrightness: 0.96,
      isBuiltIn: true,
    ),
    LightPreset(
      id: 'ivory-white',
      name: 'ivoryWhite',
      color: Color(0xFFFFFCF7),
      recommendedBrightness: 0.94,
      isBuiltIn: true,
    ),
    LightPreset(
      id: 'warm-white',
      name: 'warmWhite',
      color: Color(0xFFFFF7E8),
      recommendedBrightness: 0.93,
      isBuiltIn: true,
    ),
    LightPreset(
      id: 'warm-yellow',
      name: 'warmYellow',
      color: Color(0xFFFFF0BC),
      recommendedBrightness: 0.91,
      isBuiltIn: true,
    ),
    LightPreset(
      id: 'cool-white',
      name: 'coolWhite',
      color: Color(0xFFE5F1FF),
      recommendedBrightness: 0.9,
      isBuiltIn: true,
    ),
    LightPreset(
      id: 'pink',
      name: 'pink',
      color: Color(0xFFFFE4F1),
      recommendedBrightness: 0.89,
      isBuiltIn: true,
    ),
    LightPreset(
      id: 'cream-apricot',
      name: 'creamApricot',
      color: Color(0xFFFFF0DE),
      recommendedBrightness: 0.88,
      isBuiltIn: true,
    ),
    LightPreset(
      id: 'rose-pink',
      name: 'rosePink',
      color: Color(0xFFFFCEE2),
      recommendedBrightness: 0.88,
      isBuiltIn: true,
    ),
    LightPreset(
      id: 'focus-amber',
      name: 'focusAmber',
      color: Color(0xFFFFE3AB),
      recommendedBrightness: 0.84,
      isBuiltIn: true,
    ),
    LightPreset(
      id: 'sea-cyan',
      name: 'seaCyan',
      color: Color(0xFFD7FFF9),
      recommendedBrightness: 0.87,
      isBuiltIn: true,
    ),
    LightPreset(
      id: 'lavender',
      name: 'lavender',
      color: Color(0xFFEDE2FF),
      recommendedBrightness: 0.86,
      isBuiltIn: true,
    ),
  ];

  bool _initialized = false;
  bool _isLoading = true;
  bool _isLightOn = true;
  double _brightness = 0.92;
  double _screenBrightness = 1.0;
  int _selectedBuiltInIndex = 0;
  int? _selectedCustomIndex;
  Color? _manualColor;
  List<LightPreset> _customPresets = <LightPreset>[];
  DateTime? _timerEndAt;
  Timer? _timerTicker;

  bool get initialized => _initialized;
  bool get isLoading => _isLoading;
  bool get isLightOn => _isLightOn;
  double get brightness => _brightness;
  double get screenBrightness => _screenBrightness;
  int get selectedBuiltInIndex => _selectedBuiltInIndex;
  int? get selectedCustomIndex => _selectedCustomIndex;
  List<LightPreset> get customPresets =>
      List<LightPreset>.unmodifiable(_customPresets);
  Color? get manualColor => _manualColor;
  bool get isUsingCustomPreset => _selectedCustomIndex != null;
  bool get isUsingManualColor => _manualColor != null;
  DateTime? get timerEndAt => _timerEndAt;

  Duration? get remainingDuration {
    if (_timerEndAt == null) {
      return null;
    }
    final Duration remaining = _timerEndAt!.difference(DateTime.now());
    if (remaining.isNegative || remaining == Duration.zero) {
      return Duration.zero;
    }
    return remaining;
  }

  LightPreset get selectedPreset {
    if (_selectedCustomIndex != null &&
        _selectedCustomIndex! >= 0 &&
        _selectedCustomIndex! < _customPresets.length) {
      return _customPresets[_selectedCustomIndex!];
    }
    return builtInPresets[_selectedBuiltInIndex];
  }

  Color get effectiveColor => _manualColor ?? selectedPreset.color;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    _customPresets = await _storage.loadCustomPresets();
    final LightSessionState? session = await _storage.loadSession();
    if (session != null) {
      _restoreSession(session);
    } else {
      final double? currentBrightness = await _screenBrightnessService
          .readBrightness();
      if (currentBrightness != null) {
        _screenBrightness = currentBrightness.clamp(
          minScreenBrightness,
          maxScreenBrightness,
        );
      }
    }
    await _applyScreenBrightness();
    _ensureTimerState();

    _initialized = true;
    _isLoading = false;
    notifyListeners();
  }

  void _restoreSession(LightSessionState session) {
    final int builtInIndex = builtInPresets.indexWhere(
      (LightPreset preset) => preset.id == session.selectedBuiltInPresetId,
    );
    _selectedBuiltInIndex = builtInIndex >= 0 ? builtInIndex : 0;

    if (session.selectedCustomPresetId != null) {
      final int customIndex = _customPresets.indexWhere(
        (LightPreset preset) => preset.id == session.selectedCustomPresetId,
      );
      _selectedCustomIndex = session.isUsingCustomPreset && customIndex >= 0
          ? customIndex
          : null;
    }

    _brightness = session.brightness.clamp(minBrightness, maxBrightness);
    _screenBrightness = session.screenBrightness.clamp(
      minScreenBrightness,
      maxScreenBrightness,
    );
    _isLightOn = session.isLightOn;
    _manualColor = session.manualColorValue == null
        ? null
        : Color(session.manualColorValue!);
    _timerEndAt = session.timerEndsAtEpochMs == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(session.timerEndsAtEpochMs!);
  }

  Future<void> selectBuiltInPreset(int index) async {
    if (index < 0 || index >= builtInPresets.length) {
      return;
    }
    _selectedBuiltInIndex = index;
    _selectedCustomIndex = null;
    _manualColor = null;
    _brightness = builtInPresets[index].recommendedBrightness.clamp(
      minBrightness,
      maxBrightness,
    );
    _isLightOn = true;
    await _persist();
    notifyListeners();
  }

  Future<void> selectCustomPreset(int index) async {
    if (index < 0 || index >= _customPresets.length) {
      return;
    }
    _selectedCustomIndex = index;
    _manualColor = null;
    _brightness = _customPresets[index].recommendedBrightness.clamp(
      minBrightness,
      maxBrightness,
    );
    _isLightOn = true;
    await _persist();
    notifyListeners();
  }

  Future<void> applyManualColor(Color color) async {
    _selectedCustomIndex = null;
    _manualColor = color;
    _brightness = 0.9;
    _isLightOn = true;
    await _persist();
    notifyListeners();
  }

  Future<void> saveCurrentColorAsPreset(String name) async {
    final LightPreset preset = LightPreset(
      id: 'custom-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      color: effectiveColor,
      recommendedBrightness: _brightness,
      isBuiltIn: false,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    _customPresets.insert(0, preset);
    if (_customPresets.length > maxCustomPresets) {
      _customPresets = _customPresets
          .take(maxCustomPresets)
          .toList(growable: true);
    }
    _selectedCustomIndex = 0;
    _manualColor = null;
    _isLightOn = true;
    await _storage.saveCustomPresets(_customPresets);
    await _persist();
    notifyListeners();
  }

  Future<void> deleteCustomPreset(int index) async {
    if (index < 0 || index >= _customPresets.length) {
      return;
    }
    _customPresets.removeAt(index);
    if (_selectedCustomIndex == index) {
      _selectedCustomIndex = null;
      _manualColor = null;
    } else if (_selectedCustomIndex != null && _selectedCustomIndex! > index) {
      _selectedCustomIndex = _selectedCustomIndex! - 1;
    }
    await _storage.saveCustomPresets(_customPresets);
    await _persist();
    notifyListeners();
  }

  Future<void> adjustBrightnessByDrag(double deltaY) async {
    _brightness = (_brightness - deltaY * 0.0025).clamp(
      minBrightness,
      maxBrightness,
    );
    _isLightOn = true;
    await _persist();
    notifyListeners();
  }

  Future<void> setBrightness(double value) async {
    _brightness = value.clamp(minBrightness, maxBrightness);
    _isLightOn = true;
    await _persist();
    notifyListeners();
  }

  Future<void> setScreenBrightness(double value) async {
    _screenBrightness = value.clamp(minScreenBrightness, maxScreenBrightness);
    await _applyScreenBrightness();
    await _persist();
    notifyListeners();
  }

  Future<void> toggleLight() async {
    _isLightOn = !_isLightOn;
    await _persist();
    notifyListeners();
  }

  Future<void> switchMode(int step) async {
    final int total = builtInPresets.length + _customPresets.length;
    if (total <= 1) {
      return;
    }

    int currentIndex;
    if (_selectedCustomIndex != null) {
      currentIndex = builtInPresets.length + _selectedCustomIndex!;
    } else {
      currentIndex = _selectedBuiltInIndex;
    }

    final int wrapped = (currentIndex + step + total) % total;
    if (wrapped < builtInPresets.length) {
      await selectBuiltInPreset(wrapped);
      return;
    }
    await selectCustomPreset(wrapped - builtInPresets.length);
  }

  Future<void> startTimer(int minutes) async {
    if (minutes <= 0) {
      await clearTimer();
      return;
    }
    _timerEndAt = DateTime.now().add(Duration(minutes: minutes));
    _startTicker();
    await _persist();
    notifyListeners();
  }

  Future<void> clearTimer() async {
    _timerEndAt = null;
    _timerTicker?.cancel();
    _timerTicker = null;
    await _persist();
    notifyListeners();
  }

  String currentModeName(BuildContext context, List<String> builtInNames) {
    if (_selectedCustomIndex != null &&
        _selectedCustomIndex! >= 0 &&
        _selectedCustomIndex! < _customPresets.length) {
      return _customPresets[_selectedCustomIndex!].name;
    }
    return builtInNames[_selectedBuiltInIndex];
  }

  Color tonedColor() {
    return renderOutputColor(effectiveColor, _brightness);
  }

  static Color renderOutputColor(Color color, double brightness) {
    final HSLColor hsl = HSLColor.fromColor(color);
    final double normalizedBrightness = brightness.clamp(0.0, 1.0);

    if (hsl.saturation < 0.08) {
      return hsl
          .withSaturation((hsl.saturation * 0.3).clamp(0.0, 0.05))
          .withLightness((0.62 + normalizedBrightness * 0.36).clamp(0.0, 1.0))
          .toColor();
    }

    return hsl
        .withSaturation((hsl.saturation * 1.45 + 0.12).clamp(0.0, 1.0))
        .withLightness(
          (0.26 + normalizedBrightness * 0.42 + hsl.lightness * 0.14).clamp(
            0.0,
            1.0,
          ),
        )
        .toColor();
  }

  void onAppLifecycleChanged(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _ensureTimerState();
      unawaited(_applyScreenBrightness());
      notifyListeners();
      return;
    }
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      unawaited(_persist());
    }
  }

  Future<void> _applyScreenBrightness() async {
    await _screenBrightnessService.setBrightness(_screenBrightness);
  }

  Future<void> _persist() async {
    await _storage.saveSession(
      LightSessionState(
        selectedBuiltInPresetId: builtInPresets[_selectedBuiltInIndex].id,
        selectedCustomPresetId: _selectedCustomIndex == null
            ? null
            : _customPresets[_selectedCustomIndex!].id,
        isUsingCustomPreset: _selectedCustomIndex != null,
        brightness: _brightness,
        isLightOn: _isLightOn,
        manualColorValue: _manualColor?.toARGB32(),
        timerEndsAtEpochMs: _timerEndAt?.millisecondsSinceEpoch,
        screenBrightness: _screenBrightness,
      ),
    );
  }

  void _ensureTimerState() {
    if (_timerEndAt == null) {
      _timerTicker?.cancel();
      _timerTicker = null;
      return;
    }

    if (_timerEndAt!.isBefore(DateTime.now())) {
      _finishTimer();
      return;
    }
    _startTicker();
  }

  void _startTicker() {
    _timerTicker?.cancel();
    _timerTicker = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_timerEndAt == null) {
        timer.cancel();
        return;
      }
      if (!_timerEndAt!.isAfter(DateTime.now())) {
        _finishTimer();
      } else {
        notifyListeners();
      }
    });
  }

  void _finishTimer() {
    _timerTicker?.cancel();
    _timerTicker = null;
    _timerEndAt = null;
    _isLightOn = false;
    unawaited(_persist());
    notifyListeners();
  }

  @override
  void dispose() {
    _timerTicker?.cancel();
    super.dispose();
  }
}
