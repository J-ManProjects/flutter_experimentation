import "package:flutter_experimentation/services/notes.dart";


class Sequence {


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
    int count = 41;
    sequence.add(0);
    for (int i = 0; i < count; i++) {
      sequence.add(66);
    }

    // F#4
    sequence.add(0);
    for (int i = 0; i < count; i++) {
      sequence.add(66);
    }

    // G4
    sequence.add(0);
    for (int i = 0; i < count; i++) {
      sequence.add(67);
    }

    // A4
    sequence.add(0);
    for (int i = 0; i < count; i++) {
      sequence.add(69);
    }

    // A4
    sequence.add(0);
    for (int i = 0; i < count; i++) {
      sequence.add(69);
    }

    // G4
    sequence.add(0);
    for (int i = 0; i < count; i++) {
      sequence.add(67);
    }

    // F#4
    sequence.add(0);
    for (int i = 0; i < count; i++) {
      sequence.add(66);
    }

    // E4
    sequence.add(0);
    for (int i = 0; i < count; i++) {
      sequence.add(64);
    }

    // D4
    sequence.add(0);
    for (int i = 0; i < count; i++) {
      sequence.add(62);
    }

    // D4
    sequence.add(0);
    for (int i = 0; i < count; i++) {
      sequence.add(62);
    }

    // E4
    sequence.add(0);
    for (int i = 0; i < count; i++) {
      sequence.add(64);
    }

    // F#4
    sequence.add(0);
    for (int i = 0; i < count; i++) {
      sequence.add(66);
    }

    // F#4
    count = 62;
    sequence.add(0);
    for (int i = 0; i < count; i++) {
      sequence.add(66);
    }

    // E4
    count = 20;
    sequence.add(0);
    for (int i = 0; i < count; i++) {
      sequence.add(64);
    }

    // E4
    count = 83;
    sequence.add(0);
    for (int i = 0; i < count; i++) {
      sequence.add(64);
    }


    // Part 2:

    // F#4
    count = 41;
    sequence.add(0);
    for (int i = 0; i < count; i++) {
      sequence.add(66);
    }

    // F#4
    sequence.add(0);
    for (int i = 0; i < count; i++) {
      sequence.add(66);
    }

    // G4
    sequence.add(0);
    for (int i = 0; i < count; i++) {
      sequence.add(67);
    }

    // A4
    sequence.add(0);
    for (int i = 0; i < count; i++) {
      sequence.add(69);
    }

    // A4
    sequence.add(0);
    for (int i = 0; i < count; i++) {
      sequence.add(69);
    }

    // G4
    sequence.add(0);
    for (int i = 0; i < count; i++) {
      sequence.add(67);
    }

    // F#4
    sequence.add(0);
    for (int i = 0; i < count; i++) {
      sequence.add(66);
    }

    // E4
    sequence.add(0);
    for (int i = 0; i < count; i++) {
      sequence.add(64);
    }

    // D4
    sequence.add(0);
    for (int i = 0; i < count; i++) {
      sequence.add(62);
    }

    // D4
    sequence.add(0);
    for (int i = 0; i < count; i++) {
      sequence.add(62);
    }

    // E4
    sequence.add(0);
    for (int i = 0; i < count; i++) {
      sequence.add(64);
    }

    // F#4
    sequence.add(0);
    for (int i = 0; i < count; i++) {
      sequence.add(66);
    }

    // E4
    count = 62;
    sequence.add(0);
    for (int i = 0; i < count; i++) {
      sequence.add(64);
    }

    // D4
    count = 20;
    sequence.add(0);
    for (int i = 0; i < count; i++) {
      sequence.add(62);
    }

    // D4
    count = 83;
    sequence.add(0);
    for (int i = 0; i < count; i++) {
      sequence.add(62);
    }

    return sequence;
  }
}