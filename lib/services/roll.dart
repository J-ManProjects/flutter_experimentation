import "package:flutter/material.dart";
import "package:flutter_experimentation/services/notes.dart";


class Roll extends StatefulWidget {
  final int selectedPitch;
  final int pianoFlex;
  final int milliseconds;

  const Roll({
    this.selectedPitch = 0,
    this.milliseconds = 0,
    this.pianoFlex = 20,
    Key? key,
  }) : super(key: key);

  @override
  State<Roll> createState() => _RollState();
}

class _RollState extends State<Roll> with TickerProviderStateMixin {
  List<Widget> tileStack = [];
  late SlidingTile tile;
  late int lowestPitch;
  late int highestPitch;
  late int selectedPitch;
  late int milliseconds;
  late double height;
  late int rollFlex;


  @override
  void initState() {
    lowestPitch = Notes.minPitch;
    highestPitch = Notes.maxPitch;

    // Setup the flex.
    rollFlex = 100 - widget.pianoFlex;

    // Add the grey background.
    tileStack.add(Container(
      color: Colors.grey[900],
    ));

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    // Setup the selected pitch.
    selectedPitch = widget.selectedPitch;

    // Setup the duration in milliseconds.
    milliseconds = widget.milliseconds;

    // Setup the sliding tile height.
    height = milliseconds / 5;

    // Align the roll animation.
    List<Widget> rolls = alignRoll(selectedPitch: selectedPitch);

    // The vertical end point for the animation.
    double end = screenHeight / height;

    // Add to the stack.
    if (rolls.isNotEmpty) {

      // Create the controller.
      var controller = AnimationController(
        duration: Duration(milliseconds: 2000+milliseconds),
        vsync: this,
      );

      // Dispose of controller on completion.
      controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.dispose();
          tileStack.removeAt(1);
        }
      });

      // Define the sliding tile.
      tile = SlidingTile(
        controller: controller,
        rolls: rolls,
        end: end,
      );

      // Start the animation.
      tile.controller.forward(from: -1);

      // Add to the tile stack.
      tileStack.add(tile.layout);
    }

    return Expanded(
      flex: rollFlex,
      child: Stack(
        children: tileStack,
      ),
    );
  }


  // Align the roll to the selected pitch.
  List<Widget> alignRoll({int selectedPitch = 0}) {
    List<Widget> rolls = [];

    // Return an empty list if selected pitch is out of range.
    if (selectedPitch < lowestPitch || selectedPitch > highestPitch) {
      return rolls;
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

    // Return the resulting rolls.
    return rolls;
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
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          border: Border.all(
            color: Colors.black54,

          ),
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



// The sliding tile tween animation class.
class SlidingTile {
  AnimationController controller;
  late Animation<Offset> offset;
  late Widget layout;

  SlidingTile({
    required this.controller,
    required List<Widget> rolls,
    required double end,
  }) {

    // Create the offset.
    offset = Tween<Offset>(
      begin: Offset(0.0, -1.0),
      end: Offset(0.0, end),
    ).animate(controller);

    // Create the tile widget.
    layout = SlideTransition(
      position: offset,
      child: Row(children: rolls),
    );
  }
}