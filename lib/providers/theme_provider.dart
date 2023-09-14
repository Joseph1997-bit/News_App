import 'package:flutter/material.dart';

import '../services/dark_theme_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemePreferences darkThemePreferences = ThemePreferences();
  bool _darkTheme = false;
  //getDarkTheme degiskeni veya ona atilan degeri kullanarak title,renk ve icon degistirebiliriz
  bool get getDarkTheme => _darkTheme;

  //set metoduna atilan switch/renk degeri _darkTheme ile getDarkTheme'e atip baska sayfada kullanabiliriz
  set setDarkTheme(bool value) {
    _darkTheme = value;
    darkThemePreferences.setDarkTheme(value);//switch icon'dan gelen bool degeri setDarkTheme metoduna atip uygulamanin rengi kaydetmek icin
    notifyListeners();
  }
}
