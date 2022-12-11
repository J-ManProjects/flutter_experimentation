class Notes {

  // Static member variables.
  static const List NOTES = [
    "C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B"
  ];
  static const int minPitch = 33;
  static const int maxPitch = 97;
  static const int Fs = 44100;


  // Determine the note of the given pitch.
  static String pitchToNote(int pitch) {
    String note = NOTES[pitch % 12];
    int octave = pitch ~/ 12;
    return "$note$octave";
  }
}