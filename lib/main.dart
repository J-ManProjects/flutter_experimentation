import "package:flutter/material.dart";


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

      // Light mode.
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),

      // Dark mode.
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.indigo,
      ),

      // Configure routes.
      initialRoute: "/home",
      routes: {
        "/home": (context) => Home(),
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
        child: Text("Hello world"),
      ),
    );
  }
}