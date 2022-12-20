import "package:flutter/material.dart";


class Roll extends StatefulWidget {
  final int selectedPitch;
  const Roll({
    this.selectedPitch = 0,
    Key? key,
  }) : super(key: key);

  @override
  State<Roll> createState() => _RollState();
}

class _RollState extends State<Roll> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Container(
        color: Colors.grey[900],
      ),
    );
  }
}
