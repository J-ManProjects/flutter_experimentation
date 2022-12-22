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
    );

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        print("Animation completed");
      }
    });
  }


  @override
  void dispose() {
    super.dispose();
    try {
      controller.dispose();
    } catch (e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    print("Screen width = $screenWidth");
    print("Screen height = $screenHeight");

    // The container width.
    double width = 200;

    // The horizontal end point for the animation.
    double end = (screenWidth) / width;
    print("Offset end = $end");

    // The offset tween animation.
    offset = Tween<Offset>(
      begin: Offset(-1.0, 0.0),
      end: Offset(end, 0.0),
    ).animate(controller);

    return Scaffold(
      appBar: AppBar(
        title: Text("Animations"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: SlideTransition(
              position: offset,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: Colors.black54,
                  ),
                  color: Colors.purple,
                ),
                width: width,
                height: 20,
              ),
            ),
          ),
          Divider(
            height: 2,
            thickness: 2,
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    child: Text("Slide From Left"),
                    onPressed: () {
                      controller.reset();
                      controller.forward();
                    },
                  ),
                  ElevatedButton(
                    child: Text("Slide From Right"),
                    onPressed: () {
                      controller.reset();
                      controller.reverse(from: width);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  void slideTransition() {}
}
