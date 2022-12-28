import "package:flutter/material.dart";


class WhitePianoTile extends StatefulWidget {
  final String note;
  final bool highlight;
  const WhitePianoTile({
    required this.note,
    required this.highlight,
    Key? key,
  }) : super(key: key);

  @override
  State<WhitePianoTile> createState() => _WhitePianoTileState();
}

class _WhitePianoTileState extends State<WhitePianoTile> {
  late bool highlight;

    @override
  Widget build(BuildContext context) {
      highlight = widget.highlight;

    // Configure the note name color.
    Color? noteColor;
    if (widget.note[0] == "C") {
      noteColor = (highlight) ? Colors.white : Colors.black;
    } else {
      noteColor = (highlight) ? Colors.grey[300] : Colors.grey[600];
    }

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 0.75,
            color: Colors.black54,
          ),
          borderRadius: BorderRadius.circular(2),
          color: highlight ? Colors.green : Colors.white,
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: SizedBox(),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  widget.note,
                  style: TextStyle(
                    color: noteColor,
                    fontSize: 10,
                    fontWeight: (widget.note[0] == "C")
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
