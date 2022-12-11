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


  // Determine the pitch of the given note.
  static int noteToPitch(String note) {
    note = "${note.substring(0,1).toUpperCase()}${note.substring(1)}";
    int octave = int.parse(note[note.length-1]) + 1;
    int n = NOTES.indexOf(note.substring(0, note.length-1));
    return 12*octave + n;
  }
}