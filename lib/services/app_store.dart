import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/memorial.dart';
import '../models/settings.dart';

/// The family's remembrance days and the user's choices, saved on the
/// device only.
class AppStore {
  AppStore(this._prefs);

  static Future<AppStore> load() async =>
      AppStore(await SharedPreferences.getInstance());

  static const _memorialsKey = 'memorials';
  static const _settingsKey = 'settings';
  static const _askedPermissionKey = 'askedPermission';
  static const _languageChoiceKey = 'languageChoice';

  final SharedPreferences _prefs;

  List<Memorial> memorials() {
    final raw = _prefs.getString(_memorialsKey);
    if (raw == null) return [];
    final result = <Memorial>[];
    for (final item in jsonDecode(raw) as List) {
      try {
        result.add(Memorial.fromJson(item as Map<String, dynamic>));
      } on Object {
        // One unreadable entry must not hide the others.
      }
    }
    return result;
  }

  Future<void> saveMemorials(List<Memorial> memorials) => _prefs.setString(
    _memorialsKey,
    jsonEncode([for (final m in memorials) m.toJson()]),
  );

  Settings settings() {
    final raw = _prefs.getString(_settingsKey);
    if (raw == null) return const Settings();
    try {
      return Settings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on Object {
      return const Settings();
    }
  }

  Future<void> saveSettings(Settings settings) =>
      _prefs.setString(_settingsKey, jsonEncode(settings.toJson()));

  bool get askedPermission => _prefs.getBool(_askedPermissionKey) ?? false;

  Future<void> markAskedPermission() =>
      _prefs.setBool(_askedPermissionKey, true);

  /// The language picked in the app ("vi", "zh_Hant"...); null means "same
  /// as the phone".
  String? get languageChoice => _prefs.getString(_languageChoiceKey);

  Future<void> saveLanguageChoice(String? language) => language == null
      ? _prefs.remove(_languageChoiceKey)
      : _prefs.setString(_languageChoiceKey, language);
}
