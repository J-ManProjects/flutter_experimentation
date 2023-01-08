import "package:flutter/material.dart";
import "package:flutter_experimentation/pages/home.dart";
import "package:flutter_experimentation/pages/piano_bar.dart";
import "package:flutter_experimentation/pages/piano_roll.dart";
import "package:flutter_experimentation/pages/piano_touch.dart";
import "package:flutter_experimentation/pages/record_audio.dart";
import "package:flutter_experimentation/pages/sound_generator.dart";
import "package:flutter_experimentation/pages/sliding_animations.dart";
import "package:flutter_experimentation/pages/color_animations.dart";
import "package:flutter_experimentation/pages/file_management.dart";
import "package:flutter_experimentation/services/my_theme.dart";


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
        "/piano_touch": (context) => PianoTouch(),
        "/piano_bar": (context) => PianoBar(),
        "/sliding_animations": (context) => SlidingAnimations(),
        "/sound": (context) => SoundGenerator(),
        "/color_animations": (context) => ColorAnimations(),
        "/piano_roll": (context) => PianoRoll(),
        "/files": (context) => FileManagement(),
        "/record": (context) => RecordAudio(),
      },
    );
  }
}