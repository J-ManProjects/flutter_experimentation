import "dart:typed_data";
import "dart:convert";
import "dart:io";


// Static class to handle all WAV file data/information.
class WavFile {
  static final AsciiCodec _ascii = AsciiCodec();
  static late ByteData _byteData;


  // Read the given file as a list bytes.
  static Uint8List wavToBytes(String filePath) {
    return File(filePath).readAsBytesSync();
  }


  // Converts the list of bytes to an ASCII string.
  static String bytesToAscii(Uint8List bytes, {bool? allowInvalid}) {
    return _ascii.decode(bytes, allowInvalid: allowInvalid);
  }


  // Converts the byte data into a 16-bit unsigned integer.
  static int bytesToUint16(Uint8List bytes) {
    _byteData = ByteData.sublistView(bytes);
    return _byteData.getUint16(0, Endian.little);
  }


  // Converts the byte data into a 16-bit signed integer.
  static int bytesToInt16(Uint8List bytes) {
    _byteData = ByteData.sublistView(bytes);
    return _byteData.getInt16(0, Endian.little);
  }


  // Converts the byte data into a 32-bit unsigned integer.
  static int bytesToUint32(Uint8List bytes) {
    _byteData = ByteData.sublistView(bytes);
    return _byteData.getUint32(0, Endian.little);
  }


  // Fix the periodic 0 byte errors in WAV files.
  static void fixWavFile(String filePath) {
    Uint8List bytes = WavFile.wavToBytes(filePath);
    Uint8List fourBytes;
    double gradient;
    int offset = 7000;
    int index = offset;
    int value;
    int prev;
    int next;

    // Loop for all data.
    while (index < bytes.length) {

      // Break if next not available.
      if (index+6 >= bytes.length) {
        break;
      }

      // Get index specific data.
      fourBytes = bytes.sublist(index, index+4);
      value = WavFile.bytesToUint32(fourBytes);
      prev = WavFile.bytesToInt16(bytes.sublist(index-2, index));
      next = WavFile.bytesToInt16(bytes.sublist(index+4, index+6));

      // Check if error at current index.
      if (value == 0 && (next != 0 || prev != 0)) {

        // Get the straight-line gradient.
        gradient = (next - prev) / 3;

        // Correct the bytes.
        for (int x = 1, i = 0; x < 3; x++, i += 2) {
          value = (x*gradient + prev).round().toUnsigned(16);
          bytes[index+i] = value % 256;
          bytes[index+i+1] = value >> 8;
        }

        // Increment by the offset value.
        index += offset;
      }

      // Increment by 2 otherwise.
      else {
        index += 2;
      }
    }

    // Save file with _fixed appended
    filePath = filePath.replaceAll(RegExp(".wav"), "__fixed.wav");
    File file = File(filePath);
    file.createSync();
    file.writeAsBytesSync(bytes);
  }

}