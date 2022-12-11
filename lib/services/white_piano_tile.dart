import "package:flutter/material.dart";


class WhitePianoTile extends StatefulWidget {
  final String note;
  const WhitePianoTile({required this.note, Key? key}) : super(key: key);

  @override
  State<WhitePianoTile> createState() => _WhitePianoTileState();
}

class _WhitePianoTileState extends State<WhitePianoTile> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Colors.black54,
          ),
          borderRadius: BorderRadius.circular(2),
          color: Colors.white,
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              widget.note,
              style: TextStyle(
                color: Colors.black,
                fontSize: 10,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
