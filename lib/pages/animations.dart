import "package:flutter/material.dart";


class Animations extends StatefulWidget {
  const Animations({Key? key}) : super(key: key);

  @override
  State<Animations> createState() => _AnimationsState();
}

class _AnimationsState extends State<Animations>
    with TickerProviderStateMixin
{
  late SlidingTileOld tile;
  late double width;


  @override
  void initState() {
    super.initState();

    // The container width.
    width = 200;
  }


  @override
  void dispose() {
    print("Disposing of controller...");
    tile.controller.stop();
    tile.controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    print("Screen width = $screenWidth");
    print("Screen height = $screenHeight");

    // The horizontal end point for the animation.
    double end = (screenWidth) / width;
    print("Offset end = $end");

    // The sliding tile tween animation class.
    tile = SlidingTileOld(
      controller: AnimationController(
        duration: Duration(seconds: 2),
        vsync: this,
      ),
      end: end,
    );

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
              position: tile.offset,
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
                    child: Text("Slide to the right"),
                    onPressed: () {
                      tile.controller.reset();
                      tile.controller.forward();
                    },
                  ),
                  ElevatedButton(
                    child: Text("Slide to the left"),
                    onPressed: () {
                      tile.controller.reset();
                      tile.controller.reverse(from: width);
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
}


// The sliding tile tween animation class.
class SlidingTileOld {
  late AnimationController controller;
  late Animation<Offset> offset;

  SlidingTileOld({required this.controller, required double end}) {
    offset = Tween<Offset>(
      begin: Offset(-1.0, 0.0),
      end: Offset(end, 0.0),
    ).animate(controller);

    controller.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        print("Sliding to the right");
      } else if (status == AnimationStatus.reverse) {
        print("Sliding to the left");
      }
    });
  }
}