import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/creator_glow_session_state.dart';
import '../domain/light_preset.dart';
import '../domain/light_session_state.dart';

class LightStorage {
  static const String _customPresetsKey = 'soft_light_custom_presets_v2';
  static const String _sessionKey = 'soft_light_session_v2';
  static const String _creatorSessionKey = 'soft_light_creator_session_v1';

  Future<List<LightPreset>> loadCustomPresets() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(_customPresetsKey);
    if (raw == null || raw.isEmpty) {
      return <LightPreset>[];
    }

    try {
      final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map(
            (dynamic item) => LightPreset.fromMap(item as Map<String, dynamic>),
          )
          .toList(growable: false);
    } catch (_) {
      return <LightPreset>[];
    }
  }

  Future<void> saveCustomPresets(List<LightPreset> presets) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(
      presets
          .map((LightPreset preset) => preset.toMap())
          .toList(growable: false),
    );
    await prefs.setString(_customPresetsKey, encoded);
  }

  Future<LightSessionState?> loadSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(_sessionKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }

    try {
      final Map<String, dynamic> decoded =
          jsonDecode(raw) as Map<String, dynamic>;
      return LightSessionState.fromMap(decoded);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveSession(LightSessionState state) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, jsonEncode(state.toMap()));
  }

  Future<CreatorGlowSessionState?> loadCreatorSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(_creatorSessionKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }

    try {
      final Map<String, dynamic> decoded =
          jsonDecode(raw) as Map<String, dynamic>;
      return CreatorGlowSessionState.fromMap(decoded);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveCreatorSession(CreatorGlowSessionState state) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_creatorSessionKey, jsonEncode(state.toMap()));
  }
}
