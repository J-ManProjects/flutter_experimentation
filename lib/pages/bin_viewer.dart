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
  late Map<int, TableColumnWidth> columnWidths;
  late List<TableRow> headings;
  late Uint8List subData;
  late int offset;


  @override
  void initState() {

    // Get the byte data.
    data = File(widget.path).readAsBytesSync();

    // Configure the headings.
    headings = [
      TableRow(
        children: <Widget>[
          headingCell("Offset"),
          headingCell("Hex"),
          headingCell("ASCII"),
          headingCell("Uint8"),
          headingCell("Uint16"),
          headingCell("Int16"),
        ],
      ),
    ];

    // Configure the column widths.
    columnWidths = {
      0: FlexColumnWidth(3),
      1: FlexColumnWidth(3),
      2: FlexColumnWidth(3),
      3: FlexColumnWidth(4),
      4: FlexColumnWidth(3),
      5: FlexColumnWidth(3),
    };

    // The data offset to start from.
    offset = 0;

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: navigationBar(),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Table(
              columnWidths: columnWidths,
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
                    columnWidths: columnWidths,
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
        padding: const EdgeInsets.symmetric(vertical: 6),
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
    String bytes;
    int start;

    // Configure the size.
    int size = min(32, data.length~/2 - offset);

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

      // Get the two bytes.
      bytes = "${subData[0]}".padLeft(3);
      bytes += " | ";
      bytes += "${subData[1]}".padLeft(3);

      return TableRow(
        children: <Widget>[
          contentCell("$start"),
          contentCell(hex),
          contentCell(ascii),
          contentCell(bytes),
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
              offset -= 64;
            });
          } : null,
          child: Text("Previous 64 bytes"),
        ),
        TextButton(
          onPressed: (offset + 64 < data.length) ? () {
            setState(() {
              offset += 64;
            });
          } : null,
          child: Text("Next 64 bytes"),
        ),
      ],

    );
  }

}