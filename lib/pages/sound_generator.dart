import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_experimentation/services/my_theme.dart";
import "package:flutter_midi/flutter_midi.dart";

import "../services/notes.dart";


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
  late String soundFont;
  late List<String> soundFonts;

  @override
  void initState() {
    super.initState();

    // The sound font list and selection.
    soundFonts = [
      "AI-APiano02trans.SF2",
      "Florestan_Piano.sf2",
      "Full Grand.sf2",
      "Grand Piano.sf2",
      "HipHopKeyz1.sf2",
      "KAWAI good piano.sf2",
      "Korg_Triton_Piano.sf2",
      "Motif ES6 Concert Piano(12Mb).SF2",
      "Motif Piano.SF2",
      "Piano Korg Triton.SF2",
      "Piano_1.sf2",
      "Piano.sf2",
      "Porter Grand Piano.sf2",
      "Roland_64VoicePiano.sf2",
      "SC55 Piano_V2.sf2",
    ];
    soundFont = soundFonts[11];

    // The note and playing status.
    note = 69;
    isPlaying = false;

    // Configure the midi playback.
    midi = FlutterMidi();
    prepareMidi(soundFont);
  }


  // Prepare the midi sound font.
  void prepareMidi(String soundFont) async {
    midi.unmute();
    String asset = "assets/sf2/$soundFont";
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

            // Select sound font.
            Text(
              "Select sound font",
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            DropdownButton(
              value: soundFont,
              items: soundFonts.map((String font) {
                return DropdownMenuItem(
                  value: font,
                  child: Text(
                    font,
                    textAlign: TextAlign.right,
                  ),
                );
              }).toList(),
              onChanged: (newSoundFont) {
                setState(() {
                  soundFont = newSoundFont!;
                });
                prepareMidi(soundFont);
              },
            ),
            Divider(
              height: 60,
              thickness: 1,
            ),

            // Play C scale.
            Text(
              "Play C scale",
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            SizedBox(
              height: 40,
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


  // Play the given midi pitch.
  Future<void> playMidiNote({required int pitch, int duration = 1000}) async {
    midi.playMidiNote(midi: pitch);
    await Future.delayed(Duration(milliseconds: duration));
    midi.stopMidiNote(midi: pitch);
  }


  // Plays the C scale.
  void playScale({required int milliseconds}) async {
    List<int> notes = [60, 62, 64, 65, 67, 69, 71, 72];
    for (int pitch in notes) {
      if (!isPlaying) {
        stopAllNotes();
        return;
      }
      await playMidiNote(pitch: pitch, duration: milliseconds);
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
