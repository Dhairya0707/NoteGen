import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider extends ChangeNotifier {
  static const String themeKey = 'isDarkMode';
  final Box settingsBox = Hive.box('settings'); // Hive box for storage

  ThemeMode _themeMode;

  ThemeProvider()
      : _themeMode = (Hive.box('settings').get(themeKey, defaultValue: false))
            ? ThemeMode.dark
            : ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme(bool isDarkMode) {
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    settingsBox.put(themeKey, isDarkMode); // Save to Hive
    notifyListeners(); // Notify listeners to rebuild UI
  }
}
