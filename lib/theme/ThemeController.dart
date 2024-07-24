import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  var isDark = false.obs;

  void changeTheme() {
    isDark.value = !isDark.value;
    Get.changeThemeMode(isDark.value ? ThemeMode.dark : ThemeMode.light);
  }

  final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      background: Colors.grey.shade300,
      primary: Colors.pink.shade200,
      secondary: Colors.grey.shade100,
    ),
    appBarTheme: AppBarTheme(color: Colors.pink),

  );

  final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      background: Colors.grey.shade800,
      primary: Colors.grey.shade700,
      secondary: Colors.grey.shade600,
    ),
    appBarTheme: AppBarTheme(color: Colors.grey.shade800),
  );
}
