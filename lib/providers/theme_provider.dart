import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// A provider class for managing the theme-related state.
class ThemeProvider with ChangeNotifier {
  // Constant key for storing and retrieving theme status from SharedPreferences.
  static const THEME_STATUS = "THEME_STATUS";

  // Internal variable to track the current theme status (light or dark).
  bool _darkTheme = false;

  // Getter to access the current theme status.
  bool get getIsDarkTheme => _darkTheme;

  // Constructor that initializes the theme by calling the getTheme method.
  ThemeProvider() {
    getTheme();
  }

  // Method to set the dark theme status and save it to SharedPreferences.
  Future<void> setDarkTheme({required bool themeValue}) async {
    // Get an instance of SharedPreferences.
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Set the theme status in SharedPreferences.
    prefs.setBool(THEME_STATUS, themeValue);

    // Update the internal variable with the new theme status.
    _darkTheme = themeValue;

    // Notify listeners of the theme change.
    notifyListeners();
  }

  // Method to retrieve the theme status from SharedPreferences.
  Future<bool> getTheme() async {
    // Get an instance of SharedPreferences.
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the theme status from SharedPreferences, defaulting to false if not found.
    _darkTheme = prefs.getBool(THEME_STATUS) ?? false;

    // Notify listeners of the current theme status.
    notifyListeners();

    // Return the current theme status.
    return _darkTheme;
  }
}
