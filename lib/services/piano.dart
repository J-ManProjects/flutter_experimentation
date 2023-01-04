import "package:flutter/material.dart";
import "package:flutter_experimentation/services/notes.dart";
import "package:flutter_experimentation/services/white_piano_tile.dart";
import "package:flutter_experimentation/services/black_piano_tile.dart";


class Piano extends StatefulWidget {
  final int selectedPitch;
  final int pianoFlex;
  final int milliseconds;

  const Piano({
    this.selectedPitch = 0,
    this.milliseconds = 0,
    this.pianoFlex = 20,
    Key? key,
  }) : super(key: key);

  @override
  State<Piano> createState() => _PianoState();
}

class _PianoState extends State<Piano> {
  List<Widget> whiteTiles = [];
  List<Widget> blackTiles = [];
  Map whiteIndices = {};
  Map blackIndices = {};
  Map notes = {};
  late int lowestPitch;
  late int highestPitch;
  late int selectedPitch;
  late int milliseconds;
  late int pianoFlex;
  late int whiteIndex, blackIndex;
  late String note;


  @override
  void initState() {
    super.initState();
    lowestPitch = Notes.minPitch;
    highestPitch = Notes.maxPitch;
    pianoFlex = widget.pianoFlex;

    // Create all piano tiles.
    populatePianoTiles();
  }


  @override
  Widget build(BuildContext context) {
    selectedPitch = widget.selectedPitch;
    milliseconds = widget.milliseconds;

    // If needed, replace note with highlighted one.
    if (selectedPitch > 0) {
      note = Notes.pitchToNote(selectedPitch);

      // White tiles.
      if (Notes.isNaturalNote(selectedPitch)) {
        whiteIndex = whiteIndices[selectedPitch];
        whiteTiles[whiteIndex] = WhitePianoTile(
          note: notes[whiteIndex],
          highlight: true,
        );
        Future.delayed(Duration(milliseconds: milliseconds), () {
          whiteTiles[whiteIndex] = WhitePianoTile(
            note: notes[whiteIndex],
            highlight: false,
          );
        });
      }

      // Black tiles.
      else {
        blackIndex = blackIndices[selectedPitch];
        blackTiles[blackIndex] = BlackPianoTile(
          highlight: true,
        );
        Future.delayed(Duration(milliseconds: milliseconds), () {
          blackTiles[blackIndex] = BlackPianoTile(
            highlight: false,
          );
        });
      }
    }

    // Piano layout.
    return Expanded(
      flex: pianoFlex,
      child: Stack(
        children: <Widget>[
          Row(children: whiteTiles),
          Row(children: blackTiles),
        ],
      ),
    );
  }


  // Populate both white and black piano tiles.
  void populatePianoTiles() {
    whiteTiles.clear();
    blackTiles.clear();
    int prevPitch = 0;

    // Add the necessary blank space at the bottom.
    int chroma = lowestPitch % 12;
    int flex = (chroma == 11 || chroma == 4) ? 3 : 1;
    blackTiles.add(blankSpace(flex: flex));

    // Add all notes in between.
    for (int pitch = lowestPitch; pitch <= highestPitch; pitch++) {
      note = Notes.pitchToNote(pitch);

      // Add white piano tile.
      if (note.length == 2) {
        whiteIndices[pitch] = whiteTiles.length;
        notes[whiteTiles.length] = note;
        whiteTiles.add(WhitePianoTile(
          note: note,
          highlight: false,
        ));
        blackTiles.add(blankSpace(flex: 2));
      } else {

        // Add blank space for two semitones.
        if (prevPitch != 0 && pitch - prevPitch > 2) {
          blackTiles.add(blankSpace(flex: 2));
        }

        // Add black piano tile.
        blackIndices[pitch] = blackTiles.length;
        blackTiles.add(BlackPianoTile(
          highlight: false,
        ));
        prevPitch = pitch;
      }
    }

    // Add the necessary blank space on top.
    chroma = highestPitch % 12;
    flex = (chroma == 0 || chroma == 5) ? 3 : 1;
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
