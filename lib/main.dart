import "package:flutter/material.dart";
import "services/my_theme.dart";
import "pages/home.dart";
import "pages/piano_roll.dart";


// Run the app here.
void main() {
  runApp(MyApp());
}


// Define the contents of the app.
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Experimentation",
      theme: MyTheme.light,
      darkTheme: MyTheme.dark,
      initialRoute: "/home",
      routes: {
        "/home": (context) => Home(),
        "/piano": (context) => PianoRoll(),
      },
    );
  }
}