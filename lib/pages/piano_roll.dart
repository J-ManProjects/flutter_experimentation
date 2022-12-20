import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_experimentation/services/piano.dart";


class PianoRoll extends StatefulWidget {
  const PianoRoll({Key? key}) : super(key: key);

  @override
  State<PianoRoll> createState() => _PianoRollState();
}

class _PianoRollState extends State<PianoRoll> {

  @override
  void initState() {
    super.initState();

    // Make fullscreen.
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // Force landscape mode.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.grey[900],
            ),
          ),
          Piano(selectedNote: "A4"),
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
