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
      alignNaturalNotes(rolls: rolls, selectedPitch: selectedPitch);
    }

    // Align for sharps.
    else {
      alignSharps(rolls: rolls, selectedPitch: selectedPitch);
    }
  }


  // Align the roll for natural notes.
  void alignNaturalNotes({
    required List<Widget> rolls,
    required int selectedPitch,
  }) {
    for (int pitch = lowestPitch; pitch <= highestPitch; pitch++) {
      int flex = 0;

      // Skip sharps.
      if (sharps.contains(pitch % 12)) {
        continue;
      }

      // Highlight selected pitch, increment the flex otherwise.
      if (pitch == selectedPitch) {
        if (flex > 0) {
          rolls.add(blankSpace(flex: flex));
        }
        rolls.add(selectedRoll(isNatural: true));
        flex = 0;
      } else {
        flex++;
      }

      // Add final blank space.
      if (flex > 0) {
        rolls.add(blankSpace(flex: flex));
      }
    }
  }


  // Align the roll for sharps.
  void alignSharps({
    required List<Widget> rolls,
    required int selectedPitch,
  }) {

    // Calculate the necessary initial flex.
    int note = lowestPitch % 12;
    int flex = (note == 11 || note == 4) ? 3 : 1;

    // Iterate through all pitches.
    int prevPitch = lowestPitch;
    for (int pitch = lowestPitch; pitch <= highestPitch; pitch++) {

      // Skip natural notes, but add to the flex.
      if (naturals.contains(pitch % 12)) {
        flex += 2;
        continue;
      }

      // Add additional flex.
      if (pitch - prevPitch > 2) {
        flex += 2;
      }

      // Highlight selected pitch and add blank space beforehand.
      // Increase the flex otherwise.
      if (pitch == selectedPitch) {
        rolls.add(blankSpace(flex: flex));
        rolls.add(selectedRoll(isNatural: false));
        flex = 0;
      } else {
        flex += 2;
      }
      prevPitch = pitch;
    }

    // Add the necessary final blank space.
    note = highestPitch % 12;
    flex += (note == 0 || note == 5) ? 3 : 1;
    rolls.add(blankSpace(flex: flex));
  }


  // Similar to a highlighted piano tile, but for the roll.
  Widget selectedRoll({required bool isNatural}) {
    return Expanded(
      flex: isNatural ? 1 : 2,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 0.75,
            color: Colors.black54,
          ),
          borderRadius: BorderRadius.circular(2),
          color: isNatural ? Colors.green : Colors.green[700],
        ),
      ),
    );
  }


  // Add a blank space before and after the selected roll.
  Widget blankSpace({required int flex}) {
    return Expanded(
      flex: flex,
      child: SizedBox(),
    );
  }
}
