import "package:flutter/material.dart";


class WhitePianoTile extends StatefulWidget {
  final String note;
  const WhitePianoTile({required this.note, Key? key}) : super(key: key);

  @override
  State<WhitePianoTile> createState() => _WhitePianoTileState();
}

class _WhitePianoTileState extends State<WhitePianoTile> {
  late bool highlight;

  @override
  void initState() {
    super.initState();
    highlight = false;
  }

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
          color: highlight ? Colors.red[700] : Colors.white,
        ),
        child: InkWell(
          onTap: () {
            setState(() {
              highlight = !highlight;
            });
            print("highlight white tile = $highlight");
          },
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                widget.note,
                style: TextStyle(
                  color: highlight ? Colors.white : Colors.black,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
