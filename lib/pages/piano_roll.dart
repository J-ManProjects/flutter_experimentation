import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_experimentation/services/white_piano_tile.dart";
import "package:flutter_experimentation/services/black_piano_tile.dart";
import "package:flutter_experimentation/services/notes.dart";


class PianoRoll extends StatefulWidget {
  const PianoRoll({Key? key}) : super(key: key);

  @override
  State<PianoRoll> createState() => _PianoRollState();
}

class _PianoRollState extends State<PianoRoll> {
  List<Widget> whiteTiles = [];
  List<Widget> blackTiles = [];


  @override
  Widget build(BuildContext context) {
    populatePianoTiles(
      whiteTiles: whiteTiles,
      blackTiles: blackTiles,
    );

    // Make fullscreen.
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return Scaffold(
      body: Stack(
        children: <Widget>[

          // White tiles.
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: whiteTiles,
          ),

          // Black tiles.
          Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: blackTiles,
          ),
        ],
      ),
    );
  }


  // Populate both white and black piano tiles.
  void populatePianoTiles({
    required List<Widget> whiteTiles,
    required List<Widget> blackTiles,
  }) {
    whiteTiles.clear();
    blackTiles.clear();
    String note;
    String prevNote = "";

    blackTiles.insert(0, blankSpace(flex: 1));
    for (int p = Notes.minPitch; p <= Notes.maxPitch; p++) {
      note = Notes.pitchToNote(p);
      if (note.length == 2) {
        whiteTiles.insert(0, WhitePianoTile(note: note));
        blackTiles.insert(0, blankSpace(flex: 2));
      } else {
        if (prevNote != "") {
          if (Notes.noteToPitch(note) - Notes.noteToPitch(prevNote) > 2) {
            blackTiles.insert(0, blankSpace(flex: 2));
          }
        }
        blackTiles.insert(0, BlackPianoTile(note: note));
        prevNote = note;
      }
    }
    blackTiles.insert(0, blankSpace(flex: 3));
  }


  // Add a blank space in between black piano tiles.
  Widget blankSpace({required int flex}) {
    return Expanded(
      flex: flex,
      child: SizedBox(
        height: 1,
      ),
    );
  }
}
