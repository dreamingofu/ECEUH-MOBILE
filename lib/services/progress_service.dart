import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Per-unit progress tracker. Mirrors the web app's `eceuh:progress`
/// localStorage key — same shape so users can roam between web and app.
class ProgressService extends ChangeNotifier {
  ProgressService(this._prefs);
  final SharedPreferences _prefs;
  static const _key = 'eceuh:progress';

  Map<String, String> _state = {};

  void load() {
    final raw = _prefs.getStringList(_key) ?? const [];
    _state = {
      for (final pair in raw)
        if (pair.contains('=')) pair.split('=').first: pair.split('=').last,
    };
    notifyListeners();
  }

  String? statusOf(String unitKey) => _state[unitKey];

  Future<void> setStatus(String unitKey, String? status) async {
    if (status == null) {
      _state.remove(unitKey);
    } else {
      _state[unitKey] = status;
    }
    await _prefs.setStringList(
      _key,
      _state.entries.map((e) => '${e.key}=${e.value}').toList(),
    );
    notifyListeners();
  }

  Map<String, String> snapshot() => Map.unmodifiable(_state);
}
