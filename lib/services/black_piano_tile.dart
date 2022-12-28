import "package:flutter/material.dart";


class BlackPianoTile extends StatefulWidget {
  final bool highlight;
  const BlackPianoTile({
    required this.highlight,
    Key? key,
  }) : super(key: key);

  @override
  State<BlackPianoTile> createState() => _BlackPianoTileState();
}

class _BlackPianoTileState extends State<BlackPianoTile> {
  late bool highlight;

  @override
  Widget build(BuildContext context) {
    highlight = widget.highlight;

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
                color: highlight ? Colors.green[700] : Colors.black,
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
