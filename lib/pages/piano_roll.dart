import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_experimentation/services/notes.dart";
import "package:flutter_experimentation/services/piano.dart";
import "package:flutter_experimentation/services/roll.dart";


class PianoRoll extends StatefulWidget {
  const PianoRoll({Key? key}) : super(key: key);

  @override
  State<PianoRoll> createState() => _PianoRollState();
}

class _PianoRollState extends State<PianoRoll> {
  late int selectedPitch;

  @override
  void initState() {
    super.initState();
    selectedPitch = Notes.minPitch;

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
      setState(() {
        if (selectedPitch < Notes.maxPitch) {
          selectedPitch++;
        } else {
          selectedPitch = Notes.minPitch;
        }
      });
    });

    return Scaffold(
      body: Column(
        children: <Widget>[
          Roll(selectedPitch: selectedPitch),
          Piano(selectedPitch: selectedPitch),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    // Exit fullscreen.
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // Force portrait mode.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }
}
