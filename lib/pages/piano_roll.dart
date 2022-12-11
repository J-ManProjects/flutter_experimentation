import "package:flutter/material.dart";
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

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[

            // White tiles.
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: whiteTiles,
            ),

            // Black tiles.
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: blackTiles,
            ),
          ],
        ),
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

    for (int p = 48; p <= 48+12; p++) {
      note = Notes.pitchToNote(p);
      if (note.length == 2) {
        whiteTiles.add(WhitePianoTile(note: note));
        blackTiles.add(BlackPianoTile(note: ""));
      } else {
        if (prevNote != "") {
          if (Notes.noteToPitch(note) - Notes.noteToPitch(prevNote) > 2) {
            blackTiles.add(BlackPianoTile(note: ""));
          }
        }
        blackTiles.add(BlackPianoTile(note: note));
        prevNote = note;
      }
      print(prevNote);
    }
    blackTiles.add(BlackPianoTile(note: ""));
  }
}
