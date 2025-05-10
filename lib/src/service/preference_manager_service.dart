import 'dart:async';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesManager {
  static SharedPreferences? _preferences;
  static Completer<void>? _initializationCompleter;

  PreferencesManager._();

  static Future<void> initialize() async {
    if (_initializationCompleter != null) {
      return _initializationCompleter!.future;
    }

    _initializationCompleter = Completer<void>();
    log('PreferencesManager: Initializing SharedPreferences...');

    try {
      _preferences = await SharedPreferences.getInstance();
      _initializationCompleter!.complete();
      log('PreferencesManager: Initialization Completed');
    } catch (e) {
      _initializationCompleter!.completeError(e);
      log('PreferencesManager: Initialization Failed: $e');
      rethrow;
    }
  }

  static SharedPreferences get preferences {
    if (_preferences == null) {
      throw StateError('PreferencesManager not initialized. Call initialize() before accessing preferences.');
    }
    return _preferences!;
  }

  static Future<void> cleanAllPreferences() async {
    await _preferences?.clear();
  }
}
