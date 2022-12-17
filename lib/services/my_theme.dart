import "package:flutter/material.dart";


// This class sets the theme of the app.
class MyTheme {
  static List<String> colorNames = ["Red", "Green", "Blue"];

  // Light mode.
  static ThemeData light = ThemeData(
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blue,
      elevation: 0,
      centerTitle: true,
    ),
    brightness: Brightness.light,
    primarySwatch: Colors.blue,

    // Elevated button.
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        textStyle: TextStyle(
          letterSpacing: 1.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );


  // Dark mode.
  static ThemeData dark = ThemeData(
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blue[700],
      elevation: 0,
      centerTitle: true,
    ),
    brightness: Brightness.dark,

    // Elevated button.
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[700],
        textStyle: TextStyle(
          letterSpacing: 1.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );


  // Returns the dark mode status.
  static bool isDarkMode(context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    return brightness == Brightness.dark;
  }


  // Returns the light mode status.
  static bool isLightMode(context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    return brightness == Brightness.light;
  }


  // Returns the possible piano tile highlighting colours.
  static Map getHighlightColors(context) {
    return MyTheme.isDarkMode(context) ? {
      MyTheme.colorNames[0]: Colors.red[700],
      MyTheme.colorNames[1]: Colors.green[700],
      MyTheme.colorNames[2]: Colors.blue[700],
    } : {
      MyTheme.colorNames[0]: Colors.red,
      MyTheme.colorNames[1]: Colors.green,
      MyTheme.colorNames[2]: Colors.blue,
    };
  }


}