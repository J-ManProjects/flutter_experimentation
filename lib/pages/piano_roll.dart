import "package:flutter/material.dart";
import "package:flutter_experimentation/services/piano_tile.dart";
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
    whiteTiles = generateWhiteTiles();

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: whiteTiles,
        ),
      ),
    );
  }


  // Generate all white piano tiles.
  List<Widget> generateWhiteTiles() {
    List<Widget> tiles = [];
    String note;
    for (int p = 48; p <= 48+12; p++) {
      note = Notes.pitchToNote(p);
      if (note.length == 2) {
        tiles.add(Expanded(child: PianoTile(note: note)));
      }
    }
    return tiles;
  }
}
