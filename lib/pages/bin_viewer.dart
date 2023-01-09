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
    String ascii;
    String hex;
    Uint8List subData;
    String bytes;

    // Configure the headings.
    List<TableRow> headings = [
      TableRow(
        children: <Widget>[
          headingCell("Index"),
          headingCell("Hex"),
          headingCell("ASCII"),
          headingCell("Uint8"),
          headingCell("Uint16"),
          headingCell("Int16"),
        ],
      ),
    ];

    // Configure the column widths.
    Map<int, TableColumnWidth> columnWidths = {
      0: FlexColumnWidth(3),
      1: FlexColumnWidth(3),
      2: FlexColumnWidth(3),
      3: FlexColumnWidth(4),
      4: FlexColumnWidth(3),
      5: FlexColumnWidth(3),
    };

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

      // Get the two bytes.
      bytes = "${subData[0]}".padLeft(3);
      bytes += " | ";
      bytes += "${subData[1]}".padLeft(3);

      return TableRow(
        children: <Widget>[
          contentCell("${index*2}"),
          contentCell(hex),
          contentCell(ascii),
          contentCell(bytes),
          contentCell("${WavFile.bytesToUint16(subData)}"),
          contentCell("${WavFile.bytesToInt16(subData)}"),
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
                    children: content,
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

}
