import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_experimentation/services/midi_sequences.dart";
import "package:flutter_experimentation/services/my_theme.dart";
import "package:flutter_experimentation/services/piano.dart";
import "package:flutter_experimentation/services/roll.dart";
import "package:flutter_midi/flutter_midi.dart";


class PianoRoll extends StatefulWidget {
  const PianoRoll({Key? key}) : super(key: key);

  @override
  State<PianoRoll> createState() => _PianoRollState();
}

class _PianoRollState extends State<PianoRoll> {
  late bool addRoll;
  late FlutterMidi midi;
  late int selectedRollPitch;
  late int selectedPianoPitch;
  late int selectedDuration;
  late bool isPlaying;
  late int pianoFlex;
  late Widget topWidget;
  late Widget separator;


  @override
  void initState() {
    super.initState();
    selectedRollPitch = 0;
    selectedPianoPitch = 0;
    selectedDuration = 0;
    isPlaying = false;
    addRoll = true;

    // The percentage of the screen (flex) the piano takes.
    pianoFlex = 20;

    // Configure the midi playback.
    midi = FlutterMidi();
    prepareMidi();

    // Make fullscreen.
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // Force landscape mode.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);

    // Configure the piano and roll separator.
    separator = Container(
      height: 8,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Colors.black,
            Colors.brown[900] as Color,
            Colors.black,
          ],
        ),
      ),
    );
  }


  // Prepare the midi sound font.
  void prepareMidi() async {
    midi.unmute();
    String asset = "assets/sf2/Piano.sf2";
    ByteData data = await rootBundle.load(asset);
    midi.prepare(sf2: data);
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

    // The piano roll if playing, the play button otherwise.
    if (isPlaying) {
      if (addRoll) {
        topWidget = Roll(
          selectedPitch: selectedRollPitch,
          milliseconds: selectedDuration,
          pianoFlex: pianoFlex,
        );
      }
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
                    // List<int> sequence = Sequence.chromaticScale();
                    List<int> sequence = Sequence.odeToJoy();
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
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    // "Play chromatic scale",
                    "Play Ode to Joy",
                    style: TextStyle(
                      letterSpacing: 1,
                      fontSize: 16,
                      color: Colors.white,
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

          // Either the play button or the piano roll.
          topWidget,

          // The gradient filled separator.
          separator,

          // The piano tiles.
          Piano(
            selectedPitch: selectedPianoPitch,
            pianoFlex: pianoFlex,
          ),
        ],
      ),
    );
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


  // Plays the melody based on the given list of notes.
  void playMelody({required List<Note> notes}) async {

    // Swap to roll.
    setState(() {
      isPlaying = true;
    });

    // Iterate through all notes.
    for (var note in notes) {

      // Skip zero pitches.
      if (note.pitch == 0) {
        await Future.delayed(Duration(milliseconds: note.duration));
        continue;
      }

      // First set the roll pitch and duration.
      setState(() {
        selectedRollPitch = note.pitch;
        selectedDuration = note.duration;
        addRoll = true;
      });

      // Set the midi playback.
      Future.delayed(Duration(milliseconds: 1200), () {
        midi.playMidiNote(midi: note.pitch);
        Future.delayed(Duration(milliseconds: note.duration), () {
          midi.stopMidiNote(midi: note.pitch);
        });
      });

      // Set the piano pitch.
      Future.delayed(Duration(milliseconds: 1500), () {
        setState(() {
          selectedPianoPitch = note.pitch;
          addRoll = false;
        });
      });

      // Delay for note's duration before continuing to next note.
      await Future.delayed(Duration(milliseconds: note.duration), () {
      });
    }

    // Swap back to play button final note.
    Future.delayed(Duration(milliseconds: notes.last.duration+1500), () {
      setState(() {
        selectedRollPitch = 0;
        selectedPianoPitch = 0;
        selectedDuration = 0;
        isPlaying = false;
      });
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