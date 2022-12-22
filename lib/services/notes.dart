class Notes {

  // Static member variables.
  static const List NOTES = [
    "C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B"
  ];
  static const int minPitch = 33;
  static const int maxPitch = 96;
  static final String minNote = pitchToNote(minPitch);
  static final String maxNote = pitchToNote(maxPitch);
  static const int Fs = 44100;


  // Determines whether the given pitch is a natural note.
  static bool isNaturalNote(int pitch) {
    int chroma = pitch % 12;
    if (chroma < 5) {
      return chroma % 2 == 0;
    } else {
      return chroma % 2 == 1;
    }
  }


  // Determine the note of the given pitch.
  static String pitchToNote(int pitch) {
    String note = NOTES[pitch % 12];
    int octave = pitch ~/ 12 - 1;
    return "$note$octave";
  }


  // Determine the pitch of the given note.
  static int noteToPitch(String note) {
    note = "${note.substring(0,1).toUpperCase()}${note.substring(1)}";
    int octave = int.parse(note[note.length-1]) + 1;
    int n = NOTES.indexOf(note.substring(0, note.length-1));
    return 12*octave + n;
  }
}