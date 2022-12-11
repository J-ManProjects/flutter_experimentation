import "package:flutter/material.dart";


class BlackPianoTile extends StatefulWidget {
  const BlackPianoTile({Key? key}) : super(key: key);

  @override
  State<BlackPianoTile> createState() => _BlackPianoTileState();
}

class _BlackPianoTileState extends State<BlackPianoTile> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Colors.black54,
          ),
          borderRadius: BorderRadius.circular(2),
          color:  Colors.black,
        ),
      ),
    );
  }
}
