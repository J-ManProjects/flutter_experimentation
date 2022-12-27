import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_experimentation/services/notes.dart";
import "package:flutter_experimentation/services/piano.dart";
import "package:flutter_experimentation/services/bar.dart";


class PianoBar extends StatefulWidget {
  const PianoBar({Key? key}) : super(key: key);

  @override
  State<PianoBar> createState() => _PianoBarState();
}

class _PianoBarState extends State<PianoBar> {
  late int selectedPitch;

  @override
  void initState() {
    super.initState();
    selectedPitch = Notes.minPitch - 2;

    // Make fullscreen.
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // Force landscape mode.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  Widget build(BuildContext context) {

    // Cycle through selected pitches.
    Future.delayed(Duration(milliseconds: 250), () {
      try {
        setState(() {
          if (selectedPitch < Notes.maxPitch) {
            selectedPitch++;
          } else {
            selectedPitch = Notes.minPitch;
          }
        });
      } catch (e) {
        print(e);
      }

    });

    return Scaffold(
      body: Column(
        children: <Widget>[
          Bar(selectedPitch: selectedPitch),
          Piano(selectedPitch: selectedPitch),
        ],
      ),
    );
  }

  @override
  void dispose() {

    // Exit fullscreen.
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // Force portrait mode.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    super.dispose();
  }
}
