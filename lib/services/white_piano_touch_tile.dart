import "package:flutter/material.dart";
import "package:flutter_experimentation/services/my_theme.dart";


class WhitePianoTouchTile extends StatefulWidget {
  final String note;
  final String color;
  const WhitePianoTouchTile({
    required this.note, required this.color, Key? key,
  }) : super(key: key);

  @override
  State<WhitePianoTouchTile> createState() => _WhitePianoTouchTileState();
}

class _WhitePianoTouchTileState extends State<WhitePianoTouchTile> {
  late bool highlight;
  late String highlightColor;
  late Map colors;

  @override
  void initState() {
    super.initState();
    highlight = false;
  }

  @override
  Widget build(BuildContext context) {
    highlightColor = widget.color;
    colors = MyTheme.getHighlightColors();

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
          color: highlight ? colors[highlightColor] : Colors.white,
        ),
        child: InkWell(
          onTap: () {
            setState(() {
              highlight = !highlight;
            });
            print("highlight white tile = $highlight");
          },
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
      ),
    );
  }
}
