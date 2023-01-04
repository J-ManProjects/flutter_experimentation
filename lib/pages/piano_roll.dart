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
  late List<String> sequenceTitles;
  late Map sequences;
  late String selectedSequence;
  late bool addRoll;
  late FlutterMidi midi;
  late int selectedRollPitch;
  late int selectedPianoPitch;
  late int selectedDuration;
  late bool isPlaying;
  late int pianoFlex;
  late Widget topWidget;
  late Widget separator;
  late Widget piano;


  @override
  void initState() {
    selectedRollPitch = 0;
    selectedPianoPitch = 0;
    selectedDuration = 0;
    isPlaying = false;
    addRoll = true;

    // The percentage of the screen (flex) the piano takes.
    pianoFlex = 20;

    // The default piano tiles.
    piano = Piano(pianoFlex: pianoFlex);

    // Configure the midi playback.
    midi = FlutterMidi();
    prepareMidi();

    // Make fullscreen.
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // Force landscape mode.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);

    // Populate the list of sequences.
    sequenceTitles = [
      "Chromatic Scale (x1)",
      "Chromatic Scale (x2)",
      "Chromatic Scale (x4)",
      "Beethoven's Ode to Joy",
      "Brahms' Hungarian Dance No. 5",
    ];
    sequences = {
      sequenceTitles[0]: Sequence.chromaticScale(count: 80),
      sequenceTitles[1]: Sequence.chromaticScale(count: 40),
      sequenceTitles[2]: Sequence.chromaticScale(count: 20),
      sequenceTitles[3]: Sequence.odeToJoy(),
      sequenceTitles[4]: Sequence.hungarianDanceNo5(),
    };

    // Hungarian Dance No. 5 by default.
    selectedSequence = sequenceTitles[1];

    // Configure the piano and roll separator.
    separator = Container(
      height: 6,
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

    super.initState();
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  playMelody(sequence: sequences[selectedSequence]);
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
                padding: const EdgeInsets.only(top: 16),
                child: DropdownButton(
                  value: selectedSequence,
                  items: sequenceTitles.map((String title) {
                    return DropdownMenuItem(
                      value: title,
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (newSequence) {
                    setState(() {
                      selectedSequence = newSequence!;
                    });
                  },
                ),
              ),
            ],
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
          piano,
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


  // Plays the melody based on the given sequence.
  void playMelody({required List<int> sequence}) async {

    // Convert to a sequence of notes.
    List<Note> notes = sequenceToNotes(sequence: sequence);

    // Create the duration objects.
    Duration duration1200 = Duration(milliseconds: 1200);
    Duration duration1500 = Duration(milliseconds: 1500);

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
      Future.delayed(duration1200, () async {
        midi.playMidiNote(midi: note.pitch);
        Future.delayed(Duration(milliseconds: note.duration), () {
          midi.stopMidiNote(midi: note.pitch);
        });
      });

      // Set the piano pitch.
      Future.delayed(duration1500, () {
        setState(() {
          selectedPianoPitch = note.pitch;
          addRoll = false;
          piano = Piano(
            selectedPitch: selectedPianoPitch,
            pianoFlex: pianoFlex,
          );
        });
      });

      // Delay for note's duration before continuing to next note.
      await Future.delayed(Duration(milliseconds: note.duration));
    }

    // Swap back to play button final note.
    await Future.delayed(Duration(milliseconds: notes.last.duration+2000), () {
      setState(() {
        selectedRollPitch = 0;
        selectedPianoPitch = 0;
        selectedDuration = 0;
        addRoll = false;
        isPlaying = false;
        piano = Piano(pianoFlex: pianoFlex);
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