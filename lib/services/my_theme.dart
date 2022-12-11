import "package:flutter/material.dart";


// This class sets the theme of the app.
class MyTheme {


  // Light mode.
  static ThemeData light = ThemeData(
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blue,
      elevation: 0,
    ),
    brightness: Brightness.light,
    primarySwatch: Colors.blue,

    // Elevated button.
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
      ),
    ),
  );


  // Dark mode.
  static ThemeData dark = ThemeData(
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blue[700],
      elevation: 0,
    ),
    brightness: Brightness.dark,

    // Elevated button.
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[700],
      ),
    ),
  );


}