import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends GetxController {
  final _key = 'isDarkMode';
  final _autoKey = 'isAutoChange';
  late SharedPreferences _prefs;
  
  Future<ThemeService> init() async {
    _prefs = await SharedPreferences.getInstance();
    if(isAutoChange){
      _applyTimeChange();
    }
    return this;
  }

  bool get isAutoChange => _prefs.getBool(_autoKey) ?? true;

  bool get isDarkMode {
    if(isAutoChange){
      final hour = DateTime.now().hour;
      return hour >= 18 || hour < 6;
    }
    return _prefs.getBool(_key) ?? true;
  }

  ThemeMode get theme => isDarkMode ? ThemeMode.dark : ThemeMode.light;
  void isToggleTheme(bool val){
    _prefs.setBool(_autoKey, val);
    if(val){
      _applyTimeChange();
    }
    update();
  }
  void switchTheme() {
    if (isAutoChange) {
      _prefs.setBool(_autoKey, false);
    }
    bool newMode = !isDarkMode;
    Get.changeThemeMode(newMode ? ThemeMode.dark : ThemeMode.light);
    _saveThemeToBox(!isDarkMode);
    update();
  }

  void _applyTimeChange(){
    final hour = DateTime.now().hour;
    bool shouldBeDark = hour > 18 || hour < 6;
    Get.changeThemeMode(shouldBeDark ? ThemeMode.dark : ThemeMode.light);
    _saveThemeToBox(shouldBeDark);
  }

  void _saveThemeToBox(bool isDark) => _prefs.setBool(_key, isDark);
}

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 18),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
      titleMedium: TextStyle(color: Colors.black),
      headlineSmall: TextStyle(color: Colors.black),
    ),
    iconTheme: const IconThemeData(color: Colors.black),
    listTileTheme: const ListTileThemeData(
      iconColor: Colors.black,
      textColor: Colors.black,
    ),
    dividerTheme: DividerThemeData(
      color: Colors.grey.shade300,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.white,
    )
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      titleMedium: TextStyle(color: Colors.white),
      headlineSmall: TextStyle(color: Colors.white),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    listTileTheme: const ListTileThemeData(
      iconColor: Colors.white,
      textColor: Colors.white,
    ),
    dividerTheme: DividerThemeData(
      color: Colors.grey.shade800,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.grey.shade900,
    )
  );
}
