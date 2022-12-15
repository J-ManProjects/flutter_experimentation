import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_experimentation/services/my_theme.dart";
import "package:flutter_midi/flutter_midi.dart";

import '../services/notes.dart';


class SoundGenerator extends StatefulWidget {
  const SoundGenerator({Key? key}) : super(key: key);

  @override
  State<SoundGenerator> createState() => _SoundGeneratorState();
}

class _SoundGeneratorState extends State<SoundGenerator> {
  late FlutterMidi midi;
  late bool isPlaying;
  late int note;
  dynamic stopColor;
  dynamic playColor;

  @override
  void initState() {
    super.initState();
    isPlaying = false;
    note = 69;
    midi = FlutterMidi();
    prepareMidi("assets/sf2/Piano.sf2");
  }


  // Prepare the midi sound font.
  void prepareMidi(String asset) async {
    midi.unmute();
    ByteData data = await rootBundle.load(asset);
    midi.prepare(sf2: data);
  }


  @override
  Widget build(BuildContext context) {
    playColor = MyTheme.isDarkMode(context) ? Colors.green[700] : Colors.green;
    stopColor = MyTheme.isDarkMode(context) ? Colors.red[700] : Colors.red;

    return Scaffold(
      appBar: AppBar(
        title: Text("Sound Generator"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Play C scale",
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            SizedBox(
              height: 60,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isPlaying = !isPlaying;
                });
                playScale(milliseconds: 500);
              },
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(20),
                backgroundColor: isPlaying ? stopColor : playColor,
              ),
              child: Icon(
                (isPlaying) ? Icons.stop : Icons.play_arrow,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }


  // Plays the C scale.
  void playScale({required int milliseconds}) async {
    List<int> notes = [60, 62, 64, 65, 67, 69, 71, 72];
    for (int pitch in notes) {
      if (!isPlaying) {
        stopAllNotes();
        return;
      }
      midi.playMidiNote(midi: pitch);
      await Future.delayed(Duration(milliseconds: milliseconds));
      midi.stopMidiNote(midi: pitch);
    }
    await Future.delayed(Duration(milliseconds: milliseconds));
    setState(() {
      isPlaying = false;
    });
  }


  // Stop playing all notes from minPitch to maxPitch.
  void stopAllNotes() {
    for (int pitch = Notes.minPitch; pitch <= Notes.maxPitch; pitch++) {
      midi.stopMidiNote(midi: pitch);
    }
  }
}
