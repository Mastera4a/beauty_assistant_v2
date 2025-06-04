import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class AppSettingsService with ChangeNotifier {
  static final AppSettingsService _instance = AppSettingsService._internal();
  factory AppSettingsService() => _instance;

  AppSettingsService._internal();

  String currency = '€';
  String timeUnit = 'hour';
  String language = 'en';

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    currency = prefs.getString('currency') ?? '€';
    timeUnit = prefs.getString('timeUnit') ?? 'hour';
    language = prefs.getString('language') ?? 'en';
  }

  Future<void> saveSettings({
    required String currency,
    required String timeUnit,
    required String language,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currency', currency);
    await prefs.setString('timeUnit', timeUnit);
    await prefs.setString('language', language);

    this.currency = currency;
    this.timeUnit = timeUnit;
    this.language = language;
  }
}
