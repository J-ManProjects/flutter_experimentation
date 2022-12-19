import "package:flutter/material.dart";
import "package:flutter_experimentation/services/my_theme.dart";


class BlackPianoTouchTile extends StatefulWidget {
  final String color;
  const BlackPianoTouchTile({
    required this.color, Key? key,
  }) : super(key: key);

  @override
  State<BlackPianoTouchTile> createState() => _BlackPianoTouchTileState();
}

class _BlackPianoTouchTileState extends State<BlackPianoTouchTile> {
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
    colors = MyTheme.getHighlightColors(isBlackTile: true);

    return Expanded(
      flex: 2,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Colors.black54,
                ),
                borderRadius: BorderRadius.circular(2),
                color: highlight ? colors[highlightColor] : Colors.black,
              ),
              child: InkWell(
                onTap: () {
                  setState(() {
                    highlight = !highlight;
                  });
                  print("highlight black tile = $highlight");
                },
              ),
            ),
          ),
          Expanded(
            child: SizedBox(),
          ),
        ],
      ),
    );
  }
}
