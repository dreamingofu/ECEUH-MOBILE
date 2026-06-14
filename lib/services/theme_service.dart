import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends ChangeNotifier {
  ThemeService(this._prefs);
  final SharedPreferences _prefs;
  static const _key = 'ee-theme';

  ThemeMode _mode = ThemeMode.light;
  ThemeMode get mode => _mode;

  void load() {
    final stored = _prefs.getString(_key);
    _mode = (stored == 'dark') ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> toggle() async {
    _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await _prefs.setString(_key, _mode == ThemeMode.dark ? 'dark' : 'light');
    notifyListeners();
  }

  Future<void> setMode(ThemeMode mode) async {
    _mode = mode;
    await _prefs.setString(_key, mode == ThemeMode.dark ? 'dark' : 'light');
    notifyListeners();
  }
}
