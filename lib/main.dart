import "package:flutter/material.dart";
import "services/themes.dart";
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


// Setup the home page.
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            // Piano roll button.
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/piano");
              },
              child: Text(
                "Piano Roll",
                style: TextStyle(
                  letterSpacing: 1.0,
                ),
              ),
            ),

            // Next button location.

          ],
        ),
      ),
    );
  }
}