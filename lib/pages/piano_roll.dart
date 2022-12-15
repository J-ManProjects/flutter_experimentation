import "dart:math";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_experimentation/services/white_piano_tile.dart";
import "package:flutter_experimentation/services/black_piano_tile.dart";
import "package:flutter_experimentation/services/notes.dart";
import "package:flutter_experimentation/services/my_theme.dart";


class PianoRoll extends StatefulWidget {
  const PianoRoll({Key? key}) : super(key: key);

  @override
  State<PianoRoll> createState() => _PianoRollState();
}

class _PianoRollState extends State<PianoRoll> {
  List<Widget> whiteTiles = [];
  List<Widget> blackTiles = [];
  int lowestPitch = 0;
  int highestPitch = 0;


  @override
  void initState() {
    super.initState();
    lowestPitch = Notes.minPitch;
    highestPitch = Notes.maxPitch;

    // Make fullscreen.
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }


  @override
  Widget build(BuildContext context) {
    print("Building piano roll state");

    // Create all piano tiles.
    populatePianoTiles(
      whiteTiles: whiteTiles,
      blackTiles: blackTiles,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Piano roll"),
      ),
      drawer: leftDrawer(),
      body: Stack(
        children: <Widget>[

          // White tiles.
          Column(
            children: whiteTiles,
          ),

          // Black tiles.
          Column(
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
    int prevPitch = 0;

    // Add the necessary blank space at the bottom.
    String note = Notes.pitchToNote(lowestPitch)[0];
    print("Bottom note:  $note");
    int flex = (note == "B" || note == "E") ? 3 : 1;
    blackTiles.insert(0, blankSpace(flex: flex));

    // Add all notes in between.
    for (int pitch = lowestPitch; pitch <= highestPitch; pitch++) {
      note = Notes.pitchToNote(pitch);

      // Add white piano tile.
      if (note.length == 2) {
        whiteTiles.insert(0, WhitePianoTile(note: note));
        blackTiles.insert(0, blankSpace(flex: 2));
      } else {

        // Add blank space for two semitones.
        if (prevPitch != 0 && pitch - prevPitch > 2) {
          blackTiles.insert(0, blankSpace(flex: 2));
        }

        // Add black piano tile.
        blackTiles.insert(0, BlackPianoTile());
        prevPitch = pitch;
      }
    }

    // Add the necessary blank space on top.
    note = Notes.pitchToNote(highestPitch)[0];
    print("Top note:  $note");
    flex = (note == "C" || note == "F") ? 3 : 1;
    blackTiles.insert(0, blankSpace(flex: flex));
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


  // The complete left drawer layout and functionality.
  Widget leftDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[

          // Drawer heading.
          DrawerHeader(
            decoration: BoxDecoration(
              color: MyTheme.isDarkMode(context)
                  ? Colors.blue[700]
                  : Colors.blue,
            ),
            child: Center(
              child: Text(
                "Layout settings",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,       
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),

          // Highest note.
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              "Set the highest note:",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(Notes.minNote),
              ),
              Expanded(
                child: Slider(
                  min: Notes.minPitch.toDouble(),
                  max: Notes.maxPitch.toDouble(),
                  divisions: 64,
                  value: highestPitch.toDouble(),
                  label: Notes.pitchToNote(highestPitch),
                  onChanged: (value) {
                    updateHighestPitch(value);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(Notes.maxNote),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  updateHighestPitch(highestPitch-1);
                },
              ),
              Expanded(
                child: Center(
                  child: Text(
                    Notes.pitchToNote(highestPitch),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  updateHighestPitch(highestPitch+1);
                },
              ),
            ],
          ),

          // Slider divider.
          Divider(height: 3),

          // Lowest note.
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              "Set the lowest note:",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(Notes.minNote),
              ),
              Expanded(
                child: Slider(
                  min: Notes.minPitch.toDouble(),
                  max: Notes.maxPitch.toDouble(),
                  divisions: 64,
                  value: lowestPitch.toDouble(),
                  label: Notes.pitchToNote(lowestPitch),
                  onChanged: (value) {
                    updateLowestPitch(value);
                  }
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(Notes.maxNote),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  updateLowestPitch(lowestPitch-1);
                },
              ),
              Expanded(
                child: Center(
                  child: Text(
                    Notes.pitchToNote(lowestPitch),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  updateLowestPitch(lowestPitch+1);
                },
              ),
            ],
          ),

        ],
      ),
    );
  }


  // Update the lowest pitch value.
  void updateLowestPitch(double value) {
    if (value >= Notes.minPitch && value <= Notes.maxPitch) {
      int prevPitch = lowestPitch;
      setState(() {
        lowestPitch = max(value.round(), Notes.minPitch);
        if (Notes.pitchToNote(lowestPitch).length == 3) {
          lowestPitch += (lowestPitch > prevPitch) ? 1 : -1;
        }
        highestPitch = max(lowestPitch, highestPitch);
      });
    }
  }


  // Update the highest pitch value.
  void updateHighestPitch(double value) {
    if (value >= Notes.minPitch && value <= Notes.maxPitch) {
      int prevPitch = highestPitch;
      setState(() {
        highestPitch = value.round();
        if (Notes.pitchToNote(highestPitch).length == 3) {
          highestPitch += (highestPitch > prevPitch) ? 1 : -1;
        }
        lowestPitch = min(lowestPitch, highestPitch);
      });
    }
  }


}