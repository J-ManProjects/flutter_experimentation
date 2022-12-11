import "package:flutter/material.dart";


class BlackPianoTile extends StatefulWidget {
  final String note;
  const BlackPianoTile({required this.note, Key? key}) : super(key: key);

  @override
  State<BlackPianoTile> createState() => _BlackPianoTileState();
}

class _BlackPianoTileState extends State<BlackPianoTile> {
  late double opacity;

  @override
  Widget build(BuildContext context) {
    opacity = (widget.note == "") ? 0 : 0.6;

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Colors.red,
          ),
          borderRadius: BorderRadius.circular(2),
          color:  Colors.black.withOpacity(opacity),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              widget.note,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
