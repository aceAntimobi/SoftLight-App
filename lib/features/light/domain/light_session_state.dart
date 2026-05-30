class LightSessionState {
  const LightSessionState({
    required this.selectedBuiltInPresetId,
    required this.selectedCustomPresetId,
    required this.isUsingCustomPreset,
    required this.brightness,
    required this.isLightOn,
    required this.manualColorValue,
    required this.timerEndsAtEpochMs,
    required this.screenBrightness,
  });

  final String selectedBuiltInPresetId;
  final String? selectedCustomPresetId;
  final bool isUsingCustomPreset;
  final double brightness;
  final bool isLightOn;
  final int? manualColorValue;
  final int? timerEndsAtEpochMs;
  final double screenBrightness;

  factory LightSessionState.fromMap(Map<String, dynamic> map) {
    return LightSessionState(
      selectedBuiltInPresetId:
          map['selectedBuiltInPresetId'] as String? ?? 'pure-white',
      selectedCustomPresetId: map['selectedCustomPresetId'] as String?,
      isUsingCustomPreset: map['isUsingCustomPreset'] as bool? ?? false,
      brightness: (map['brightness'] as num?)?.toDouble() ?? 0.9,
      isLightOn: map['isLightOn'] as bool? ?? true,
      manualColorValue: map['manualColorValue'] as int?,
      timerEndsAtEpochMs: map['timerEndsAtEpochMs'] as int?,
      screenBrightness: (map['screenBrightness'] as num?)?.toDouble() ?? 1.0,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'selectedBuiltInPresetId': selectedBuiltInPresetId,
      'selectedCustomPresetId': selectedCustomPresetId,
      'isUsingCustomPreset': isUsingCustomPreset,
      'brightness': brightness,
      'isLightOn': isLightOn,
      'manualColorValue': manualColorValue,
      'timerEndsAtEpochMs': timerEndsAtEpochMs,
      'screenBrightness': screenBrightness,
    };
  }
}
