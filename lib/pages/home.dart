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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            // Piano roll button.
            ElevatedButton(
              onPressed: () async {
                await Navigator.pushNamed(context, "/piano");

                // Exit fullscreen.
                SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
              },
              child: Text("Piano Roll"),
            ),

            // Generate sounds.
            ElevatedButton(
              onPressed: () {},
              child: Text("Sound Generator"),
            ),

            // Function in C++ testing.
            ElevatedButton(
              onPressed: () {},
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
    );
  }
}