import "package:flutter/material.dart";
import "package:flutter_experimentation/services/notes.dart";


class Roll extends StatefulWidget {
  final int selectedPitch;
  const Roll({
    this.selectedPitch = 0,
    Key? key,
  }) : super(key: key);

  @override
  State<Roll> createState() => _RollState();
}

class _RollState extends State<Roll> {
  final List<int> naturals = [0, 2, 4, 5, 7, 9, 11];
  final List<int> sharps = [1, 3, 6, 8, 10];
  List<Widget> rolls = [];

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

    // Align the roll animation.
    alignRoll(selectedPitch: selectedPitch, rolls: rolls);

    return Expanded(
      flex: 3,
      child: Stack(
        children: <Widget>[
          Container(
            color: Colors.grey[900],
          ),
          Row(children: rolls),
        ],
      ),
    );
  }


  // Align the roll to the selected pitch.
  void alignRoll({
    required List<Widget> rolls,
    int selectedPitch = 0,
  }) {
    rolls.clear();
    if (selectedPitch < lowestPitch || selectedPitch > highestPitch) {
      return;
    }

    // Align for natural notes.
    if (naturals.contains(selectedPitch % 12)) {
      for (int pitch = lowestPitch; pitch <= highestPitch; pitch++) {
        if (sharps.contains(pitch % 12)) {
          continue;
        }
        if (pitch == selectedPitch) {
          rolls.add(Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 0.75,
                  color: Colors.black54,
                ),
                borderRadius: BorderRadius.circular(2),
                color: Colors.green,
              ),
            ),
          ));
        } else {
          rolls.add(blankSpace(flex: 1));
        }
      }
    }

    // Align for sharps.
    else {
      int prevPitch = 0;

      int note = lowestPitch % 12;
      int flex = (note == 11 || note == 4) ? 3 : 1;
      rolls.add(blankSpace(flex: flex));

      for (int pitch = lowestPitch; pitch <= highestPitch; pitch++) {
        if (naturals.contains(pitch % 12)) {
          rolls.add(blankSpace(flex: 2));
          continue;
        }

        if (prevPitch != 0 && pitch - prevPitch > 2) {
          rolls.add(blankSpace(flex: 2));
        }
        if (pitch == selectedPitch) {
          rolls.add(Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 0.75,
                  color: Colors.black54,
                ),
                borderRadius: BorderRadius.circular(2),
                color: Colors.green[700],
              ),
            ),
          ));
        } else {
          rolls.add(blankSpace(flex: 2));
        }
        prevPitch = pitch;
      }

      note = highestPitch % 12;
      flex = (note == 0 || note == 5) ? 3 : 1;
      rolls.add(blankSpace(flex: flex));
    }

  }


  // Add a blank space in between black piano tiles.
  Widget blankSpace({required int flex}) {
    return Expanded(
      flex: flex,
      child: SizedBox(),
    );
  }
}
