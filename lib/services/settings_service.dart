import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends ChangeNotifier {
  // Общие настройки
  int _allowedExcess = 20; // км/ч (нештрафуемый порог)
  double _comfortableDeceleration = 2.0; // м/с²
  bool _voiceEnabled = true;
  bool _vibrationEnabled = true;

  // Настройки собеседника
  bool _companionEnabled = false;
  int _companionFrequencyMinutes = 3; // 2=часто, 3=средне, 5=редко
  bool _jokesEnabled = true;

  // Режимы
  bool _demoMode = false;
  bool _mode100 = false; // Режим "100 км/ч"

  // Getters
  int get allowedExcess => _allowedExcess;
  double get comfortableDeceleration => _comfortableDeceleration;
  bool get voiceEnabled => _voiceEnabled;
  bool get vibrationEnabled => _vibrationEnabled;
  bool get companionEnabled => _companionEnabled;
  int get companionFrequencyMinutes => _companionFrequencyMinutes;
  bool get jokesEnabled => _jokesEnabled;
  bool get demoMode => _demoMode;
  bool get mode100 => _mode100;

  SettingsService() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _allowedExcess = prefs.getInt('allowed_excess') ?? 20;
    _comfortableDeceleration = prefs.getDouble('comfortable_deceleration') ?? 2.0;
    _voiceEnabled = prefs.getBool('voice_enabled') ?? true;
    _vibrationEnabled = prefs.getBool('vibration_enabled') ?? true;
    _companionEnabled = prefs.getBool('companion_enabled') ?? false;
    _companionFrequencyMinutes = prefs.getInt('companion_frequency') ?? 3;
    _jokesEnabled = prefs.getBool('jokes_enabled') ?? true;
    notifyListeners();
  }

  Future<void> setAllowedExcess(int value) async {
    _allowedExcess = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('allowed_excess', value);
    notifyListeners();
  }

  Future<void> setComfortableDeceleration(double value) async {
    _comfortableDeceleration = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('comfortable_deceleration', value);
    notifyListeners();
  }

  Future<void> setVoiceEnabled(bool value) async {
    _voiceEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('voice_enabled', value);
    notifyListeners();
  }

  Future<void> setVibrationEnabled(bool value) async {
    _vibrationEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('vibration_enabled', value);
    notifyListeners();
  }

  Future<void> setCompanionEnabled(bool value) async {
    _companionEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('companion_enabled', value);
    notifyListeners();
  }

  Future<void> setCompanionFrequency(int minutes) async {
    _companionFrequencyMinutes = minutes;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('companion_frequency', minutes);
    notifyListeners();
  }

  Future<void> setJokesEnabled(bool value) async {
    _jokesEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('jokes_enabled', value);
    notifyListeners();
  }

  void setDemoMode(bool value) {
    _demoMode = value;
    notifyListeners();
  }

  void setMode100(bool value) {
    _mode100 = value;
    notifyListeners();
  }
}
