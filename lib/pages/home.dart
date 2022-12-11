import "package:flutter/material.dart";


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