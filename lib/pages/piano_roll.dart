import "package:flutter/material.dart";


class PianoRoll extends StatefulWidget {
  const PianoRoll({Key? key}) : super(key: key);

  @override
  State<PianoRoll> createState() => _PianoRollState();
}

class _PianoRollState extends State<PianoRoll> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Piano Roll"),
      ),
      body: Center(
        child: Text("Add piano tiles here"),
      ),
    );
  }
}
