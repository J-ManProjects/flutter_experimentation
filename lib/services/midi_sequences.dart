import "package:flutter_experimentation/services/notes.dart";


class Sequence {


  // Add a repeated sequence.
  static void addRepeatedSequence({
    required List<int> sequence,
    required int count,
    int pitch = 0,
    bool startZero = true,
  }) {
    if (startZero) {
      sequence.add(0);
    } else {
      sequence.add(pitch);
    }
    for (int i = 1; i < count; i++) {
      sequence.add(pitch);
    }
  }


  // The sequence of the complete chromatic scale.
  static List<int> chromaticScale({int count = 20}) {
    List<int> sequence = [];
    int i, pitch;

    for (pitch = Notes.minPitch; pitch <= Notes.maxPitch; pitch++) {
      for (i = 0; i < count; i++) {
        sequence.add(pitch);
      }
    }
    return sequence;
  }


  // The sequence for part of Beethoven's Ode to Joy.
  static List<int> odeToJoy() {
    List<int> sequence = [];


    // Part 1:

    // F#4
    int count = 40;
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 66,
    );

    // F#4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 66,
    );

    // G4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 67,
    );

    // A4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 69,
    );

    // A4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 69,
    );

    // G4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 67,
    );

    // F#4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 66,
    );

    // E4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 64,
    );

    // D4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 62,
    );

    // D4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 62,
    );

    // E4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 64,
    );

    // F#4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 66,
    );

    // F#4
    count = 60;
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 66,
    );

    // E4
    count = 20;
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 64,
    );

    // E4
    count = 40;
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 64,
    );

    // Rest.
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
    );


    // Part 2:

    // F#4
    count = 40;
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 66,
    );

    // F#4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 66,
    );

    // G4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 67,
    );

    // A4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 69,
    );

    // A4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 69,
    );

    // G4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 67,
    );

    // F#4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 66,
    );

    // E4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 64,
    );

    // D4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 62,
    );

    // D4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 62,
    );

    // E4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 64,
    );

    // F#4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 66,
    );

    // E4
    count = 60;
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 64,
    );

    // D4
    count = 20;
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 62,
    );

    // D4
    count = 40;
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 62,
    );

    // Rest.
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
    );


    // Part 3:

    // E4
    count = 40;
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 64,
    );

    // E4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 64,
    );

    // F#4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 66,
    );

    // D4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 62,
    );

    // E4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 64,
    );

    // F#4
    count = 20;
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 66,
    );

    // G4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 67,
    );

    // F#4
    count = 40;
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 66,
    );

    // D4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 62,
    );

    // E4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 64,
    );

    // F#4
    count = 20;
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 66,
    );

    // G4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 67,
    );

    // F#4
    count = 40;
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 66,
    );

    // E4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 64,
    );

    // D4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 62,
    );

    // E4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 64,
    );

    // A3
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 57,
    );

    // Rest.
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
    );


    // Part 2:

    // F#4
    count = 40;
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 66,
    );

    // F#4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 66,
    );

    // G4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 67,
    );

    // A4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 69,
    );

    // A4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 69,
    );

    // G4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 67,
    );

    // F#4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 66,
    );

    // E4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 64,
    );

    // D4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 62,
    );

    // D4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 62,
    );

    // E4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 64,
    );

    // F#4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 66,
    );

    // E4
    count = 60;
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 64,
    );

    // D4
    count = 20;
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 62,
    );

    // D4
    count = 40;
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 62,
    );

    // Rest.
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
    );


    return sequence;
  }


  // The sequence for part of Brahms' Hungarian Dance No 5.
  static List<int> hungarianDanceNo5() {
    List<int> sequence = [];
    int quarter = 24;
    int eighth = 12;

    
    // Part 1.
    
    // D4
    int count = 3*quarter;
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 62,
    );

    // G4
    count = quarter;
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 67,
    );

    // A#4
    count = 3*quarter;
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 70,
    );

    // G4
    count = quarter;
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 67,
    );

    // F#4
    count = 3*quarter;
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 66,
    );

    // G4
    count = eighth;
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 67,
    );

    // A4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 69,
    );

    // G4
    count = 4*quarter;
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 67,
    );


    // D#4
    count = 3*quarter;
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 63,
    );

    // F4
    count = eighth;
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 65,
    );

    // G4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 67,
    );

    // D4
    count = 4*quarter;
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 62,
    );

    // C4
    count = eighth;
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 60,
    );

    // A#3
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 58,
    );

    // A#3
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 58,
    );

    // A3
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 57,
    );

    // A3
    count = 3*eighth;
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 57,
    );

    // D4
    count = eighth;
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 62,
    );

    // G3
    count = 3*quarter;
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 55,
    );

    // Rest.
    count = quarter;
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
    );


    // Part 2.

    // D4
    count = 3*quarter;
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 62,
    );

    // G4
    count = eighth;
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 67,
    );

    // A#4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 70,
    );

    // D5
    count = 3*quarter;
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 74,
    );

    // A#4
    count = quarter;
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 70,
    );

    // A4
    count = 3*quarter;
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 69,
    );

    // A#4
    count = eighth;
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 70,
    );

    // C5
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 72,
    );

    // A#4
    count = 4*quarter;
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 70,
    );

    // D#4
    count = eighth;
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 63,
    );

    // F4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 65,
    );

    // G4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 67,
    );

    // D#4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 63,
    );

    // D4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 62,
    );

    // D#4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 63,
    );

    // F4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 65,
    );

    // D4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 62,
    );

    // C4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 60,
    );

    // D4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 62,
    );

    // D#4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 63,
    );

    // C4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 60,
    );

    // A#3
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 58,
    );

    // C4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 60,
    );

    // D4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 62,
    );

    // A#3
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 58,
    );

    // C4
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 60,
    );

    // A#3
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 58,
    );

    // A#3
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 58,
    );

    // A3
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 57,
    );

    // A3
    count = 3*eighth;
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 57,
    );

    // D4
    count = eighth;
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 62,
    );

    // G3
    count = 2*quarter;
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 55,
    );

    // G4
    count = eighth;
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
      pitch: 67,
    );

    // Rest.
    count = 3*eighth;
    Sequence.addRepeatedSequence(
      sequence: sequence,
      count: count,
    );


    return sequence;
  }

}