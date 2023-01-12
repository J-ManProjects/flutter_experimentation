import "package:flutter/material.dart";


class WavInfo extends StatelessWidget {
  final String title;
  final List<String> info;
  const WavInfo({
    required this.title,
    required this.info,
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {

    // Error specific layout.
    if (info[0] == "__ERROR__") {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            maxLines: 2,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        body: Center(
          child: Text("Error reading WAV info"),
        ),
      );
    }

    // The table column widths.
    Map<int, TableColumnWidth> columnWidths = {
      0: FlexColumnWidth(3),
      1: FlexColumnWidth(2),
      2: FlexColumnWidth(3),
    };

    // The content headings.
    List<TableRow> headings = [
      TableRow(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Field",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Endian",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Content",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
      TableRow(
        children: <Widget>[
          SizedBox(height: 1),
          SizedBox(height: 1),
          SizedBox(height: 1),
        ],
      ),
    ];

    // Configure the field names.
    List<String> fields = [
      "Chunk ID",
      "Chunk Size",
      "Format",
      "Sub-Chunk 1 ID",
      "Sub-Chunk 1 Size",
      "Audio Format",
      "Num Channels",
      "Sample Rate",
      "Byte Rate",
      "Block Align",
      "Bits Per Sample",
      "Sub-Chunk 2 ID",
      "Sub-Chunk 2 Size",
    ];

    // Configure the Endian styles.
    List<String> endian = [
      "Big",
      "Little",
      "Big",
      "Big",
      "Little",
      "Little",
      "Little",
      "Little",
      "Little",
      "Little",
      "Little",
      "Big",
      "Little",
    ];

    // Generate the content list.
    List<TableRow> content = List.generate(fields.length, (index) {
      return TableRow(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              fields[index],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              endian[index],
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 12,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              info[index],
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ],
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          maxLines: 2,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Table(
              columnWidths: columnWidths,
              border: TableBorder.all(
                color: Theme.of(context).dividerColor,
              ),
              children: headings + content,
            ),
          ),
        ),
      ),
    );
  }
}