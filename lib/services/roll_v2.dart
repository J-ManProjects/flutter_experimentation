import "package:flutter/material.dart";
import "package:flutter_experimentation/data_classes/note.dart";
import "package:flutter_experimentation/services/notes.dart";


class RollV2 extends StatefulWidget {
  final List<Note> notes;
  final int rollFlex;
  const RollV2({
    required this.notes,
    this.rollFlex = 80,
    Key? key,
  }) : super(key: key);

  @override
  State<RollV2> createState() => _RollV2State();
}

class _RollV2State extends State<RollV2> with TickerProviderStateMixin {
  late AnimationController controller;
  late List<Note> notes;
  late List<Widget> tileStack;
  late List<Widget> rolls;
  late Widget rollSequence;
  late int rollFlex;
  late int lowestPitch;
  late int highestPitch;
  late int selectedPitch;
  late int milliseconds;
  late int totalTime;
  late bool heightCalculated;
  late double screenHeight;
  late double totalHeight;
  late double height;
  late double ratio;
  late double end;


  @override
  void initState() {
    lowestPitch = Notes.minPitch;
    highestPitch = Notes.maxPitch;

    // The screen height has not yet been calculated.
    heightCalculated = false;

    // Setup the flex.
    rollFlex = widget.rollFlex;

    // Setup the notes.
    notes = widget.notes;

    super.initState();
  }


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    // Calculate screen height and ratio only once.
    if (!heightCalculated) {
      heightCalculated = true;
      screenHeight = MediaQuery.of(context).size.height;
      ratio = screenHeight / 2057.14285714286;

      // Add the grey background.
      tileStack = [Container(
        height: screenHeight,
        color: Colors.grey[900],
      )];
    }

    // Initialise some variables.
    int index;
    totalTime = 0;
    totalHeight = 0;

    // Generate the roll sequence.
    rollSequence = Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(notes.length, (int i) {
        index = notes.length - 1 - i;

        // Setup the selected pitch.
        selectedPitch = notes[index].pitch;

        // Setup the duration in milliseconds.
        milliseconds = notes[index].duration;
        totalTime += milliseconds;

        // Setup the sliding tile height.
        height = milliseconds * ratio;
        totalHeight += height;

        // Align the roll animation.
        rolls = alignRoll(
          height: height,
          selectedPitch: selectedPitch,
        );

        return Row(
          children: rolls,
        );

      }, growable: false),
    );

    // The vertical end point for the animation.
    end = screenHeight / totalHeight;

    // Create the controller.
    controller = AnimationController(
      duration: Duration(milliseconds: 2100+totalTime),
      vsync: this,
    );

    // Remove from stack on completion.
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        tileStack.removeLast();
      }
    });

    // Add the slide transition to the tile stack.
    tileStack.add(SlideTransition(
      position: Tween<Offset>(
        begin: Offset(0, -1),
        end: Offset(0, end),
      ).animate(controller),
      child: rollSequence,
    ));

    // Start the animation.
    controller.forward(from: -1);

    // The actual layout of the roll.
    return Expanded(
      flex: rollFlex,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Stack(
          children: tileStack,
        ),
      ),
    );
  }


  // Align the roll to the selected pitch.
  List<Widget> alignRoll({
    required double height,
    int selectedPitch = 0,
  }) {
    List<Widget> rolls = [];

    // Return an empty list if selected pitch is out of range.
    if (selectedPitch < lowestPitch || selectedPitch > highestPitch) {
      return [blankSpace(flex: 1, height: height)];
    }

    // Align for natural notes.
    if (Notes.isNaturalNote(selectedPitch)) {
      alignNaturalNotes(
        rolls: rolls,
        selectedPitch: selectedPitch,
        height: height,
      );
    }

    // Align for sharps.
    else {
      alignSharps(
        rolls: rolls,
        selectedPitch: selectedPitch,
        height: height,
      );
    }

    // Return the resulting rolls.
    return rolls;
  }


  // Align the roll for natural notes.
  void alignNaturalNotes({
    required List<Widget> rolls,
    required int selectedPitch,
    required double height,
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
          rolls.add(blankSpace(flex: flex, height: height));
        }
        rolls.add(selectedRoll(height: height, isNatural: true,));
        flex = 0;
      } else {
        flex++;
      }
    }

    // Add final blank space.
    if (flex > 0) {
      rolls.add(blankSpace(flex: flex, height: height));
    }
  }


  // Align the roll for sharps.
  void alignSharps({
    required List<Widget> rolls,
    required int selectedPitch,
    required double height,
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
        rolls.add(blankSpace(flex: flex, height: height));
        rolls.add(selectedRoll(height: height, isNatural: false));
        flex = 0;
      } else {
        flex += 2;
      }
      prevPitch = pitch;
    }

    // Add the necessary final blank space.
    chroma = highestPitch % 12;
    flex += (chroma == 0 || chroma == 5) ? 3 : 1;
    rolls.add(blankSpace(flex: flex, height: height));
  }


  // Similar to a highlighted piano tile, but for the roll.
  Widget selectedRoll({
    required double height,
    required bool isNatural,
  }) {
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
  Widget blankSpace({
    required int flex,
    required double height,
  }) {
    return Expanded(
      flex: flex,
      child: SizedBox(height: height),
    );
  }


}
