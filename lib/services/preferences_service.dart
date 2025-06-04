import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_settings.dart';

class PreferencesService {
  static const _key = 'user_settings';

  Future<void> saveUserSettings(UserSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(settings.toMap());
    await prefs.setString(_key, jsonString);
  }

  Future<UserSettings?> getUserSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return null;
    final map = json.decode(jsonString);
    return UserSettings.fromMap(map);
  }
}
