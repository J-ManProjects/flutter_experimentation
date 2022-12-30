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


  @override
  void initState() {

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
    

    controller.forward();
    controller.duration = Duration(seconds: 2);

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
        child: Container(
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
                  controller.reset();
                  controller.forward();
                });
              }
            },
          ),
        ),
      ),
    );
  }
}
