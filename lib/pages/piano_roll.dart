import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_experimentation/services/white_piano_tile.dart";
import "package:flutter_experimentation/services/black_piano_tile.dart";
import "package:flutter_experimentation/services/notes.dart";
import "package:flutter_experimentation/services/my_theme.dart";


int lowestPitch = Notes.minPitch;
int highestPitch = Notes.maxPitch;


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
    print("Building piano roll state");
    populatePianoTiles(
      whiteTiles: whiteTiles,
      blackTiles: blackTiles,
    );

    // Make fullscreen.
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return Scaffold(
      appBar: AppBar(
        title: Text("Piano roll"),
      ),
      drawer: AppDrawer(),
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
    for (int p = lowestPitch; p <= highestPitch; p++) {
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
        blackTiles.insert(0, BlackPianoTile());
        prevNote = note;
      }
    }
    blackTiles.insert(0, blankSpace(flex: 1));
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


// The complete app drawer layout and functionality.
class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  late int prevPitch;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: MyTheme.isDarkMode(context)
                ? Colors.blue[700]
                : Colors.blue,
            ),
            child: Text("Drawer Header"),
          ),

          // Lowest note.
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
            child: Text(
              "Set the lowest note:",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8),
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
                    setState(() {
                      prevPitch = lowestPitch;
                      lowestPitch = value.round();
                      if (Notes.pitchToNote(lowestPitch).length == 3) {
                        lowestPitch += (lowestPitch > prevPitch) ? 1 : -1;
                      }
                      if (lowestPitch > highestPitch) {
                        highestPitch = lowestPitch;
                      }
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(Notes.maxNote),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
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
          Divider(
            height: 2,
          ),

          // Highest note.
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
            child: Text(
              "Set the highest note:",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8),
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
                    setState(() {
                      prevPitch = highestPitch;
                      highestPitch = value.round();
                      if (Notes.pitchToNote(highestPitch).length == 3) {
                        highestPitch += (highestPitch > prevPitch) ? 1 : -1;
                      }
                      if (highestPitch < lowestPitch) {
                        lowestPitch = highestPitch;
                      }
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(Notes.maxNote),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
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
        ],
      ),
    );
  }
}
