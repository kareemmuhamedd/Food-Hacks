import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  var primaryColor = Colors.pink;
  var accentColor = Colors.amber;
  var tm = ThemeMode.system;
  String themeText = 's';

  onChanged(newColor, checkNum) async {
    checkNum == 1
        ? primaryColor = _convertToMaterialColor(newColor.hashCode)
        : accentColor = _convertToMaterialColor(newColor.hashCode);
    notifyListeners();
    SharedPreferences setPrefs = await SharedPreferences.getInstance();
    setPrefs.setInt('primaryColor', primaryColor.value);
    setPrefs.setInt('accentColor', accentColor.value);
  }

  getThemeColorsFromPrefs() async {
    SharedPreferences getPrefs = await SharedPreferences.getInstance();
    primaryColor = _convertToMaterialColor(getPrefs.getInt('primaryColor')??0xFFE91E63);
    accentColor = _convertToMaterialColor(getPrefs.getInt('accentColor')??0xFFFFC107);
    notifyListeners();
  }

  MaterialColor _convertToMaterialColor(colorVal) {
    return MaterialColor(
      colorVal,
      <int, Color>{
        50: const Color(0xFFFCE4EC),
        100: const Color(0xFFF8BBD0),
        200: const Color(0xFFF48FB1),
        300: const Color(0xFFF06292),
        400: const Color(0xFFEC407A),
        500: Color(colorVal),
        600: const Color(0xFFD81B60),
        700: const Color(0xFFC2185B),
        800: const Color(0xFFAD1457),
        900: const Color(0xFF880E4F),
      },
    );
  }

  void themeModeChange(newThemeVal) async {
    tm = newThemeVal;
    _getThemeText(tm);
    notifyListeners();
    SharedPreferences setPrefs = await SharedPreferences.getInstance();
    setPrefs.setString('themeText', themeText);
  }

  _getThemeText(ThemeMode tm) {
    if (tm == ThemeMode.system) {
      themeText = 's';
    } else if (tm == ThemeMode.light) {
      themeText = 'l';
    } else if (tm == ThemeMode.dark) {
      themeText = 'd';
    }
  }

  getThemeModeFromPrefs() async {
    SharedPreferences getPrefs = await SharedPreferences.getInstance();
    themeText = getPrefs.getString('themeText') ?? 's';
    if (themeText == 's') {
      tm = ThemeMode.system;
    } else if (themeText == 'l') {
      tm = ThemeMode.light;
    } else if (themeText == 'd') {
      tm = ThemeMode.dark;
    }
    notifyListeners();
  }
}
