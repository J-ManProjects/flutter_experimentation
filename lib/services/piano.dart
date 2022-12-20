import "package:flutter/material.dart";
import "package:flutter_experimentation/services/notes.dart";
import "package:flutter_experimentation/services/white_piano_tile.dart";
import "package:flutter_experimentation/services/black_piano_tile.dart";


class Piano extends StatefulWidget {
  final int selectedPitch;
  const Piano({
    this.selectedPitch = 0,
    Key? key,
  }) : super(key: key);

  @override
  State<Piano> createState() => _PianoState();
}

class _PianoState extends State<Piano> {
  List<Widget> whiteTiles = [];
  List<Widget> blackTiles = [];
  int lowestPitch = 0;
  int highestPitch = 0;
  late int selectedPitch;


  @override
  void initState() {
    super.initState();
    lowestPitch = Notes.minPitch;
    highestPitch = Notes.maxPitch;
  }


  @override
  Widget build(BuildContext context) {
    selectedPitch = widget.selectedPitch;

    // Create all piano tiles.
    populatePianoTiles(
      whiteTiles: whiteTiles,
      blackTiles: blackTiles,
      selectedPitch: selectedPitch,
    );

    return Expanded(
      flex: 1,
      child: Stack(
        children: <Widget>[
          Row(children: whiteTiles),
          Row(children: blackTiles),
        ],
      ),
    );
  }


  // Populate both white and black piano tiles.
  void populatePianoTiles({
    required List<Widget> whiteTiles,
    required List<Widget> blackTiles,
    int selectedPitch = 0,
  }) {
    whiteTiles.clear();
    blackTiles.clear();
    int prevPitch = 0;

    // Add the necessary blank space at the bottom.
    String note = Notes.pitchToNote(lowestPitch)[0];
    int flex = (note == "B" || note == "E") ? 3 : 1;
    blackTiles.add(blankSpace(flex: flex));

    // Add all notes in between.
    for (int pitch = lowestPitch; pitch <= highestPitch; pitch++) {
      note = Notes.pitchToNote(pitch);

      // Add white piano tile.
      if (note.length == 2) {
        whiteTiles.add(WhitePianoTile(
          note: note,
          highlight: (pitch == selectedPitch),
        ));
        blackTiles.add(blankSpace(flex: 2));
      } else {

        // Add blank space for two semitones.
        if (prevPitch != 0 && pitch - prevPitch > 2) {
          blackTiles.add(blankSpace(flex: 2));
        }

        // Add black piano tile.
        blackTiles.add(BlackPianoTile(
          note: note,
          highlight: (pitch == selectedPitch),
        ));
        prevPitch = pitch;
      }
    }

    // Add the necessary blank space on top.
    note = Notes.pitchToNote(highestPitch)[0];
    flex = (note == "C" || note == "F") ? 3 : 1;
    blackTiles.add(blankSpace(flex: flex));
  }


  // Add a blank space in between black piano tiles.
  Widget blankSpace({required int flex}) {
    return Expanded(
      flex: flex,
      child: SizedBox(),
    );
  }
}
