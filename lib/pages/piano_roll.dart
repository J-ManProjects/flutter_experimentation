import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_experimentation/services/my_theme.dart";
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
  late bool isPlaying;
  late int pianoFlex;
  late Widget topWidget;

  @override
  void initState() {
    super.initState();
    selectedPitch = 0;
    isPlaying = false;

    // The percentage of the screen (flex) the piano takes.
    pianoFlex = 20;

    // Make fullscreen.
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // Force landscape mode.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
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


  @override
  Widget build(BuildContext context) {

    if (isPlaying) {
      topWidget = Roll(
        selectedPitch: selectedPitch,
        pianoFlex: pianoFlex,
      );
    } else {
      topWidget = Expanded(
        flex: 100 - pianoFlex,
        child: Container(
          color: Colors.grey[900],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    List<int> sequence = chromaticScaleSequence();
                    List<Note> notes = sequenceToNotes(sequence: sequence);
                    playMelody(notes: notes);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                    backgroundColor: MyTheme.isDarkMode(context)
                        ? Colors.green[700]
                        : Colors.green,
                  ),
                  child: Icon(Icons.play_arrow),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Play chromatic scale",
                    style: TextStyle(
                      letterSpacing: 1,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: <Widget>[
          topWidget,
          Piano(
            selectedPitch: selectedPitch,
            pianoFlex: pianoFlex,
          ),
        ],
      ),
    );
  }


  // The sequence of the complete chromatic scale.
  List<int> chromaticScaleSequence() {
    List<int> sequence = [];
    int i, pitch;

    for (pitch = Notes.minPitch; pitch <= Notes.maxPitch; pitch++) {
      for (i = 0; i < 50; i++) {
        sequence.add(pitch);
      }
    }
    return sequence;
  }


  // Converts the MIDI sequence into a list of notes.
  List<Note> sequenceToNotes({required List<int> sequence, int dt = 10}) {
    List<Note> notes = [];
    int duration = 0;
    int start = 0;

    // Iterate through all pitches in the sequence.
    for (int i = 1; i < sequence.length; i++) {
      duration += dt;

      // Determine duration of a single note.
      if (sequence[i] != sequence[i-1]) {
        notes.add(Note(pitch: sequence[start], duration: duration));
        duration = 0;
        start = i;
      }
    }

    // Add the final entry and return the list.
    notes.add(Note(pitch: sequence[start], duration: duration));
    return notes;
  }


  void playMelody({required List<Note> notes}) async {
    setState(() {
      isPlaying = true;
    });
    for (var note in notes) {
      setState(() {
        selectedPitch = note.pitch;
      });
      await Future.delayed(Duration(milliseconds: note.duration));
    }
    setState(() {
      isPlaying = false;
      selectedPitch = 0;
    });
  }

}


// The class for housing a note's pitch and duration.
class Note {

  // The MIDI pitch.
  int pitch;

  // The duration in milliseconds.
  int duration;

  Note({required this.pitch, required this.duration});
}