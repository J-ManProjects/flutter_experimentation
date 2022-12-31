import "package:flutter/material.dart";


class ColorAnimations extends StatefulWidget {
  const ColorAnimations({Key? key}) : super(key: key);

  @override
  State<ColorAnimations> createState() => _ColorAnimationsState();
}

class _ColorAnimationsState extends State<ColorAnimations>
    with TickerProviderStateMixin
{
  late AnimationController controller;
  late Animation<Color>? boxColors;
  late Animation<Color>? textColors;
  late int duration;


  @override
  void initState() {
    duration = 0;

    // Initialise the controller.
    controller = AnimationController(
      duration: Duration.zero,
      vsync: this,
    );

    // Initialise the color(s).
    boxColors = Tween<Color>(
      begin: Colors.green[700],
      end: Colors.white,
    ).animate(controller);
    textColors = Tween<Color>(
      begin: Colors.white,
      end: Colors.black,
    ).animate(controller);
    
    // Initialise the animation.
    controller.forward();
    controller.duration = Duration(seconds: duration);

    // Add a status listener to the controller.
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        print("Completed");
        setState(() {});
      }
    });

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Color Changing Animations"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 8,
                ),
                color: boxColors?.value,
              ),
              height: 160,
              width: 160,
              child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Random text goes here",
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textColors?.value,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  if (controller.isCompleted) {
                    setState(() {
                      if (duration == 5) {
                        duration = 1;
                      } else {
                        duration++;
                      }
                      controller.duration = Duration(seconds: duration);
                      controller.reset();
                      controller.forward();
                    });
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                "Delay: $duration second${(duration == 1) ? "" : "s"}",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
