import "package:flutter/material.dart";
import "package:flutter_experimentation/services/my_theme.dart";


class SlidingAnimations extends StatefulWidget {
  const SlidingAnimations({Key? key}) : super(key: key);

  @override
  State<SlidingAnimations> createState() => _SlidingAnimationsState();
}

class _SlidingAnimationsState extends State<SlidingAnimations>
    with TickerProviderStateMixin
{
  late List<SlidingTile> tiles = [];
  late List<Widget> rolls = [];
  late double width;
  late int numTiles;
  late int minNumTiles;
  late int maxNumTiles;
  late int index;
  late String numTilesText;

  bool mustPopulate = true;


  @override
  void initState() {
    super.initState();

    // The container width.
    width = 200;

    // The initial number of sliding tiles.
    numTiles = 16;

    // The minimum and maximum allowed number of tiles.
    minNumTiles = 2;
    maxNumTiles = 30;

    // The index of the current tile.
    index = 0;
  }

  @override
  void dispose() {
    print("Disposing of controllers...");
    for (int i = 0; i < numTiles; i++) {
      tiles[i].controller.stop();
      tiles[i].controller.dispose();
    }
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

    // Populate the lists.
    if (mustPopulate) {
      mustPopulate = false;
      for (int i = 0; i < numTiles; i++) {
        tiles.add(defaultSlidingTile(end: end));
        rolls.add(expandedRoll(index: i));
      }
    }

    // Configure the number of tiles text.
    numTilesText = "Number of tiles:  $numTiles";
    if (numTiles == minNumTiles) {
      numTilesText = "$numTilesText (MIN)";
    } else if (numTiles == maxNumTiles) {
      numTilesText = "$numTilesText (MAX)";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Sliding Animations"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          // The tween animations.
          Expanded(
            flex: 1,
            child: Column(
              children: rolls,
            ),
          ),

          // The number of tiles text.
          Divider(
            thickness: 2,
            height: 2,
            color: MyTheme.isLightMode(context)
                ? Colors.black54
                : Colors.grey,
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                numTilesText,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Divider(
            thickness: 2,
            height: 2,
            color: MyTheme.isLightMode(context)
                ? Colors.black54
                : Colors.grey,
          ),

          // The buttons.
          Expanded(
            flex: 1,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.keyboard_double_arrow_left_sharp),
                            Text("Slide to the left"),
                          ],
                        ),
                        onPressed: () {
                          index %= numTiles;
                          tiles[index].controller.reset();
                          tiles[index].controller.reverse(from: width);
                          index++;
                        },
                      ),
                      ElevatedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Slide to the right"),
                            Icon(Icons.keyboard_double_arrow_right_sharp),
                          ],
                        ),
                        onPressed: () {
                          index %= numTiles;
                          tiles[index].controller.reset();
                          tiles[index].controller.forward();
                          index++;
                        },
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(Icons.remove),
                            ),
                            Text("Decrement tiles"),
                          ],
                        ),
                        onPressed: () {
                          if (numTiles > minNumTiles) {
                            setState(() {
                              numTiles--;
                              tiles.removeLast();
                              rolls.removeLast();
                              if (index >= numTiles) {
                                index = 0;
                              }
                            });
                          }
                        },
                      ),
                      ElevatedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Increment tiles"),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Icon(Icons.add),
                            ),
                          ],
                        ),
                        onPressed: () {
                          if (numTiles < maxNumTiles) {
                            setState(() {
                              tiles.add(defaultSlidingTile(end: end));
                              rolls.add(expandedRoll(index: numTiles));
                              numTiles++;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  // The actual roll layout.
  Widget expandedRoll({required int index}) {
    return Expanded(
      child: SlideTransition(
        position: tiles[index].offset,
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
    );
  }


  // The sliding tile class default configurations.
  SlidingTile defaultSlidingTile({required double end}) {
    return SlidingTile(
      controller: AnimationController(
        duration: Duration(seconds: 2, milliseconds: 500),
        vsync: this,
      ),
      end: end,
    );
  }


}


// The sliding tile tween animation class.
class SlidingTile {
  late AnimationController controller;
  late Animation<Offset> offset;

  SlidingTile({required this.controller, double end = 1.0}) {
    setEnd(end);

    controller.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        print("Sliding to the right");
      } else if (status == AnimationStatus.reverse) {
        print("Sliding to the left");
      }
    });
  }

  void setEnd(double end) {
    offset = Tween<Offset>(
      begin: Offset(-1.0, 0.0),
      end: Offset(end, 0.0),
    ).animate(controller);
  }
}