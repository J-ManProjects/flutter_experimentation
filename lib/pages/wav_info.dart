import "package:flutter/material.dart";


class WavInfo extends StatefulWidget {
  final String title;
  final List<String> info;
  const WavInfo({
    required this.title,
    required this.info,
    Key? key,
  }) : super(key: key);

  @override
  State<WavInfo> createState() => _WavInfoState();
}

class _WavInfoState extends State<WavInfo> {
  late List<String> fields;
  late List<TableRow> headings;
  late List<TableRow> content;

  @override
  void initState() {

    // The content headings.
    headings = [
      TableRow(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Field",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Content",
              style: TextStyle(
                fontSize: 16,
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
        ],
      ),
    ];

    // Configure the field names.
    fields = [
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

    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    // Generate the content list.
    content = List.generate(fields.length, (index) {
      return TableRow(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              fields[index],
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.info[index]),
          ),
        ],
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
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
              border: TableBorder.all(
                color: Theme.of(context).backgroundColor,
              ),
              children: headings + content,
            ),
          ),
        ),
      ),
    );
  }
}
