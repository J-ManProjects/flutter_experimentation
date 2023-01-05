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
  late List<ListButton> buttons;

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

    // All onscreen buttons.
    buttons = [

      // Interactive piano button.
      ListButton(
        context: context,
        title: "Piano Touch",
        page: "/piano_touch",
      ),

      // Piano bar button.
      ListButton(
        context: context,
        title: "Piano Bar",
        page: "/piano_bar",
      ),

      // Sliding animations button.
      ListButton(
        context: context,
        title: "Sliding Animations",
        page: "/sliding_animations",
      ),

      // Generate sounds.
      ListButton(
        context: context,
        title: "Sound Generator",
        page: "/sound",
      ),

      // Sliding animations button.
      ListButton(
        context: context,
        title: "Color Changing Animations",
        page: "/color_animations",
      ),

      // Piano roll button.
      ListButton(
        context: context,
        title: "Piano Roll",
        page: "/piano_roll",
      ),

      // File manager (read and write storage).
      ListButton(
        context: context,
        title: "File Reading & Writing",
        page: "/files",
      ),

      // Simple audio recorder and audio playback.
      ListButton(
        context: context,
        title: "Record & Playback Audio",
      ),

      // Function in C++ testing.
      ListButton(
        context: context,
        title: "Functions in C++",
      ),

      // Exit the app.
      ListButton(
        context: context,
        title: "Exit",
        page: "_exit_",
      ),
    ];

    return SafeArea(
      child: Scaffold(
        body: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: buttons.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(
                  buttons[index].title,
                  style: TextStyle(
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: buttons[index].function,
                enabled: buttons[index].isEnabled(),
              ),
            );
          },
        ),
      ),
    );
  }
}


// The button title and function housing class.
class ListButton {
  String title;
  void Function()? function;

  ListButton({required context, required this.title, String page = ""}) {
    switch (page) {
      case "":
        function = null;
        break;
      case "_exit_":
        function = (() {
          exit(0);
        });
        break;
      default:
        function = (() {
          Navigator.pushNamed(context, page);
        });
    }
  }

  // Indicates if the button is enabled.
  bool isEnabled() {
    return function != null;
  }
}