import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_constants.dart';
import '../database/app_database.dart';

class ThemeModeNotifier extends Notifier<ThemeMode> {
  bool _hasUserModified = false;

  @override
  ThemeMode build() {
    _loadSavedTheme();
    return ThemeMode.light;
  }

  Future<void> _loadSavedTheme() async {
    try {
      final isTesting = WidgetsBinding.instance.runtimeType.toString().contains('Test');
      if (isTesting && !AppDatabase.instance.hasOpenDatabase) return;
      final saved = await AppDatabase.instance.getSetting(AppConstants.settingThemeMode);
      if (!_hasUserModified && saved == 'dark') {
        state = ThemeMode.dark;
      }
    } catch (_) {
      // Ignore in isolated tests without initialized SQLite
    }
  }

  void toggleTheme() {
    _hasUserModified = true;
    final next = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    state = next;
    _persistTheme(next);
  }

  void setTheme(ThemeMode mode) {
    _hasUserModified = true;
    state = mode;
    _persistTheme(mode);
  }

  Future<void> _persistTheme(ThemeMode mode) async {
    try {
      final isTesting = WidgetsBinding.instance.runtimeType.toString().contains('Test');
      if (isTesting && !AppDatabase.instance.hasOpenDatabase) return;
      await AppDatabase.instance.setSetting(
        AppConstants.settingThemeMode,
        mode == ThemeMode.dark ? 'dark' : 'light',
      );
    } catch (_) {}
  }
}

final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);
