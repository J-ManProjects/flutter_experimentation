import "dart:io";
import "dart:typed_data";
import "package:flutter/material.dart";
import "package:flutter_experimentation/services/wav_file.dart";


class BinViewer extends StatelessWidget {
  final String path;
  const BinViewer({
    required this.path,
    Key? key
}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Uint8List data = File(path).readAsBytesSync();

    // Configure the headings.
    List<TableRow> headings = [
      TableRow(
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Index",
                style: TextStyle(
                  fontFamily: "monospace",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Hex",
                style: TextStyle(
                  fontFamily: "monospace",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "ASCII",
                style: TextStyle(
                  fontFamily: "monospace",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Uint16",
                style: TextStyle(
                  fontFamily: "monospace",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    ];

    // Define stuff.
    String ascii;
    String hex;
    Uint8List subData;

    // Configure the content.
    List<TableRow> content = List.generate(100, (index) {
      subData = data.sublist(index*2, index*2+2);

      // Attempt to get the ASCII value.
      ascii = WavFile.bytesToAscii(subData, allowInvalid: true);

      // Replace all escape sequences.
      ascii = ascii.replaceAll(RegExp("\t"), "\\t");
      ascii = ascii.replaceAll(RegExp("\b"), "\\b");
      ascii = ascii.replaceAll(RegExp("\n"), "\\n");
      ascii = ascii.replaceAll(RegExp("\r"), "\\r");
      ascii = ascii.replaceAll(RegExp("\f"), "\\f");

      // Represent with quotation marks.
      ascii = "\"$ascii\"";

      // Get the hexadecimal value.
      hex = WavFile.bytesToUint16(subData).toRadixString(16);
      hex = hex.toUpperCase().padLeft(4, "0");

      return TableRow(
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${index*2}",
                style: TextStyle(
                  fontFamily: "monospace",
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                hex,
                style: TextStyle(
                  fontFamily: "monospace",
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                ascii,
                style: TextStyle(
                  fontFamily: "monospace",
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${WavFile.bytesToUint16(subData)}",
                style: TextStyle(
                  fontFamily: "monospace",
                ),
              ),
            ),
          )
        ],
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("BIN Viewer"),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Table(
                border: TableBorder.all(
                  width: 3,
                  color: Theme.of(context).dividerColor,
                ),
                children: headings,
              ),
            ),
            Expanded(
              flex: 95,
              child: SingleChildScrollView(
                child: Table(
                  border: TableBorder.all(
                    width: 2,
                    color: Theme.of(context).dividerColor,
                  ),
                  children: content,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
