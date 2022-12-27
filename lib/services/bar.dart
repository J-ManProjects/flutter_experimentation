import "package:flutter/material.dart";
import "package:flutter_experimentation/services/notes.dart";


class Bar extends StatefulWidget {
  final int selectedPitch;
  const Bar({
    this.selectedPitch = 0,
    Key? key,
  }) : super(key: key);

  @override
  State<Bar> createState() => _BarState();
}

class _BarState extends State<Bar> {
  List<Widget> bars = [];

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

    // Align the bar animation.
    alignBar(selectedPitch: selectedPitch, bars: bars);

    return Expanded(
      flex: 3,
      child: Stack(
        children: <Widget>[
          Container(
            color: Colors.grey[900],
          ),
          Row(children: bars),
        ],
      ),
    );
  }


  // Align the bar to the selected pitch.
  void alignBar({
    required List<Widget> bars,
    int selectedPitch = 0,
  }) {
    bars.clear();
    if (selectedPitch < lowestPitch || selectedPitch > highestPitch) {
      return;
    }

    // Align for natural notes.
    if (Notes.isNaturalNote(selectedPitch)) {
      alignNaturalNotes(
        bars: bars,
        selectedPitch: selectedPitch,
      );
    }

    // Align for sharps.
    else {
      alignSharps(
        bars: bars,
        selectedPitch: selectedPitch,
      );
    }
  }


  // Align the bar for natural notes.
  void alignNaturalNotes({
    required List<Widget> bars,
    required int selectedPitch,
  }) {
    for (int pitch = lowestPitch; pitch <= highestPitch; pitch++) {
      int flex = 0;

      // Skip sharps.
      if (!Notes.isNaturalNote(pitch)) {
        continue;
      }

      // Highlight selected pitch and add blank space beforehand.
      // Increase the flex otherwise.
      if (pitch == selectedPitch) {
        if (flex > 0) {
          bars.add(blankSpace(flex: flex));
        }
        bars.add(selectedBar(isNatural: true));
        flex = 0;
      } else {
        flex++;
      }

      // Add final blank space.
      if (flex > 0) {
        bars.add(blankSpace(flex: flex));
      }
    }
  }


  // Align the bar for sharps.
  void alignSharps({
    required List<Widget> bars,
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
        bars.add(blankSpace(flex: flex));
        bars.add(selectedBar(isNatural: false));
        flex = 0;
      } else {
        flex += 2;
      }
      prevPitch = pitch;
    }

    // Add the necessary final blank space.
    chroma = highestPitch % 12;
    flex += (chroma == 0 || chroma == 5) ? 3 : 1;
    bars.add(blankSpace(flex: flex));
  }


  // Similar to a highlighted piano tile, but for the bar.
  Widget selectedBar({required bool isNatural}) {
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


  // Add a blank space before and after the selected bar.
  Widget blankSpace({required int flex}) {
    return Expanded(
      flex: flex,
      child: SizedBox(),
    );
  }
}
