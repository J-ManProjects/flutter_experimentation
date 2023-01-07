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
  static String bytesToAscii(Uint8List bytes) {
    return _ascii.decode(bytes);
  }


  // Converts the byte data into a 16-bit unsigned integer.
  static int bytesToUint16(Uint8List bytes) {
    _byteData = ByteData.sublistView(bytes);
    return _byteData.getUint16(0, Endian.little);
  }


  // Converts the byte data into a 32-bit unsigned integer.
  static int bytesToUint32(Uint8List bytes) {
    _byteData = ByteData.sublistView(bytes);
    return _byteData.getUint32(0, Endian.little);
  }

}