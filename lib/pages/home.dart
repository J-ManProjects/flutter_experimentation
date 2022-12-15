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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            // Piano roll button.
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/piano");
              },
              child: Text("Piano Roll"),
            ),

            // Generate sounds.
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/sound");
              },
              child: Text("Sound Generator"),
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