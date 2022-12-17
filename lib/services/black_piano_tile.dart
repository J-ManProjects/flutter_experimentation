import "package:flutter/material.dart";
import "my_theme.dart";


class BlackPianoTile extends StatefulWidget {
  final String color;
  const BlackPianoTile({
    required this.color, Key? key,
  }) : super(key: key);

  @override
  State<BlackPianoTile> createState() => _BlackPianoTileState();
}

class _BlackPianoTileState extends State<BlackPianoTile> {
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
    colors = MyTheme.getHighlightColors(context);

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
