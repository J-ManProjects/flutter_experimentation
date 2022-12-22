import "dart:io";
import "package:flutter/material.dart";
import "package:flutter/services.dart";


// Setup the home page.
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    super.initState();

    // Exit fullscreen.
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // Force portrait mode.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 96),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              // Interactive piano button.
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/piano_touch");
                },
                child: Text("Piano Touch"),
              ),

              // Piano roll button.
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/piano_roll");
                },
                child: Text("Piano Roll"),
              ),

              // Animations button.
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/animations");
                },
                child: Text("Animations"),
              ),

              // Generate sounds.
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/sound");
                },
                child: Text("Sound Generator"),
              ),

              // File manager (read and write storage).
              ElevatedButton(
                onPressed: null,
                child: Text("File Reading/Writing"),
              ),

              // Simple audio recorder and audio playback.
              ElevatedButton(
                onPressed: null,
                child: Text("Record/Playback Audio"),
              ),

              // Function in C++ testing.
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  final snackBar = customSnackBar("Functions in C++");
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: Text("Functions in C++"),
              ),

              // Exit the app.
              ElevatedButton(
                onPressed: () {
                  exit(0);
                },
                child: Text("Exit"),
              ),

            ],
          ),
        ),
      ),
    );
  }


  // The snack bar with not implemented message.
  SnackBar customSnackBar(String title) {
    return SnackBar(
      content: Text("'$title' not implemented yet"),
      action: SnackBarAction(
        label: "OK",
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
  }
}