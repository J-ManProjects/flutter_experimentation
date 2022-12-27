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
  List<Widget> rolls = [];

  late int lowestPitch;
  late int highestPitch;
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
    if (Notes.isNaturalNote(selectedPitch)) {
      alignNaturalNotes(
        rolls: rolls,
        selectedPitch: selectedPitch,
      );
    }

    // Align for sharps.
    else {
      alignSharps(
        rolls: rolls,
        selectedPitch: selectedPitch,
      );
    }
  }


  // Align the roll for natural notes.
  void alignNaturalNotes({
    required List<Widget> rolls,
    required int selectedPitch,
  }) {

    // The initial flex.
    int flex = 0;

    // Iterate through all pitches.
    for (int pitch = lowestPitch; pitch <= highestPitch; pitch++) {

      // Skip sharps.
      if (!Notes.isNaturalNote(pitch)) {
        continue;
      }

      // Highlight selected pitch and add blank space beforehand.
      // Increase the flex otherwise.
      if (pitch == selectedPitch) {
        if (flex > 0) {
          rolls.add(blankSpace(flex: flex));
        }
        rolls.add(selectedRoll(isNatural: true));
        flex = 0;
      } else {
        flex++;
      }
    }

    // Add final blank space.
    if (flex > 0) {
      rolls.add(blankSpace(flex: flex));
    }
  }


  // Align the roll for sharps.
  void alignSharps({
    required List<Widget> rolls,
    required int selectedPitch,
  }) {

    // Calculate the necessary initial flex.
    int chroma = lowestPitch % 12;
    int flex = (chroma == 11 || chroma == 4) ? 3 : 1;

    // Iterate through all pitches.
    int prevPitch = lowestPitch;
    for (int pitch = lowestPitch; pitch <= highestPitch; pitch++) {

      // Skip natural notes, but add to the flex.
      if (Notes.isNaturalNote(pitch)) {
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
    chroma = highestPitch % 12;
    flex += (chroma == 0 || chroma == 5) ? 3 : 1;
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
          color: isNatural ? Colors.purple : Colors.purple[700],
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
