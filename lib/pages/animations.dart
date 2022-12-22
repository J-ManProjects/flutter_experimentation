import "package:flutter/material.dart";


class Animations extends StatefulWidget {
  const Animations({Key? key}) : super(key: key);

  @override
  State<Animations> createState() => _AnimationsState();
}

class _AnimationsState extends State<Animations>
    with SingleTickerProviderStateMixin
{
  late AnimationController controller;
  late Animation<Offset> offset;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    offset = Tween(
      begin: Offset(-1.0, 0.0),
      end: Offset(1.0, 0.0),
    ).animate(controller);
  }


  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Animations"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SlideTransition(
            position: offset,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: Colors.black54,
                ),
                color: Colors.purple,
              ),
              width: 200,
              height: 20,
            ),
          ),
        ],
      ),
    );
  }
}
