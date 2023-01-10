import "dart:io";
import "dart:math";
import "dart:typed_data";
import "package:flutter/material.dart";
import "package:flutter_experimentation/services/wav_file.dart";


class BinViewer extends StatefulWidget {
  final String path;
  const BinViewer({
    required this.path,
    Key? key
}) : super(key: key);

  @override
  State<BinViewer> createState() => _BinViewerState();
}

class _BinViewerState extends State<BinViewer> {
  late Uint8List data;
  late String filename;
  late Map<int, TableColumnWidth> columnWidths;
  late List<TableRow> headings;
  late Uint8List subData;
  late int offset;
  late int skip;


  @override
  void initState() {

    // Get the byte data.
    data = File(widget.path).readAsBytesSync();

    // Get the filename only.
    filename = widget.path.split("/").last;

    // Configure the headings.
    headings = [
      TableRow(
        children: <Widget>[
          headingCell("Offset"),
          headingCell("Hex"),
          headingCell("ASCII"),
          headingCell("Uint16"),
          headingCell("Int16"),
        ],
      ),
    ];

    // The data offset to start from.
    offset = 0;

    // The number of bytes to skip.
    skip = 100;

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: navigationBar(),
      appBar: AppBar(
        title: Text(
          filename,
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Table(
              border: TableBorder.all(
                width: 2,
                color: Theme.of(context).dividerColor,
              ),
              children: headings,
            ),
            Expanded(
              child: Scrollbar(
                interactive: true,
                child: SingleChildScrollView(
                  child: Table(
                    border: TableBorder.all(
                      width: 2,
                      color: Theme.of(context).dividerColor,
                    ),
                    children: getContent(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  // Returns the table heading cell widget.
  Widget headingCell(String text) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: "monospace",
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),
      ),
    );
  }

  // Returns the table content cell widget.
  Widget contentCell(String text) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: "monospace",
            fontSize: 11,
          ),
        ),
      ),
    );
  }


  // Load all specified contents.
  List<TableRow> getContent() {
    String ascii;
    String hex;
    int start;

    // Configure the size.
    int size = min(skip~/2, data.length~/2 - offset);

    // Configure the content.
    return List.generate(size, (index) {
      start = offset+index*2;
      subData = data.sublist(start, start+2);

      // Attempt to get the ASCII value.
      ascii = WavFile.bytesToAscii(subData, allowInvalid: true);

      // Replace all escape sequences.
      ascii = ascii.replaceAll(RegExp("\b"), "\\b");
      ascii = ascii.replaceAll(RegExp("\f"), "\\f");
      ascii = ascii.replaceAll(RegExp("\n"), "\\n");
      ascii = ascii.replaceAll(RegExp("\r"), "\\r");
      ascii = ascii.replaceAll(RegExp("\t"), "\\t");
      ascii = ascii.replaceAll(RegExp("\v"), "\\v");

      // Represent with quotation marks.
      ascii = "\"$ascii\"";

      // Get the hexadecimal value.
      hex = subData[0].toRadixString(16).padLeft(2, "0");
      hex += " ";
      hex += subData[1].toRadixString(16).padLeft(2, "0");
      hex = hex.toUpperCase();

      return TableRow(
        children: <Widget>[
          contentCell("$start"),
          contentCell(hex),
          contentCell(ascii),
          contentCell("${WavFile.bytesToUint16(subData)}"),
          contentCell("${WavFile.bytesToInt16(subData)}"),
        ],
      );
    });
  }


  // The bottom navigation bar.
  Widget navigationBar() {
    return NavigationBar(
      height: 42,
      destinations: <Widget>[
        TextButton(
          onPressed: (offset > 0) ? () {
            setState(() {
              offset -= skip;
            });
          } : null,
          child: Text("Previous $skip bytes"),
        ),
        TextButton(
          onPressed: (offset + skip < data.length) ? () {
            setState(() {
              offset += skip;
            });
          } : null,
          child: Text("Next $skip bytes"),
        ),
      ],

    );
  }

}