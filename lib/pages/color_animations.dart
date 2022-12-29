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
  late Animation<Color>? animation;
  late bool reverse;


  @override
  void initState() {
    reverse = false;

    // Initialise the controller.
    controller = AnimationController(
      duration: Duration.zero,
      vsync: this,
    );

    // Initialise the color(s).
    animation = Tween<Color>(
      begin: Colors.indigo,
      end: Colors.amber,
    ).animate(controller);

    // Add a status listener to the controller.
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        print("Completed");
        reverse = !reverse;
      } else if (status == AnimationStatus.dismissed) {
        print("Dismissed");
        reverse = !reverse;
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
          height: 100,
          width: 100,
          color: animation?.value,
          child: InkWell(
            onTap: () {
              setState(() {
                if (reverse) {
                  controller.reverse();
                } else {
                  controller.forward();
                }
              });
            },
          ),
        ),
      ),
    );
  }
}
