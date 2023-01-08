import "dart:async";
import "dart:io";
import "package:flutter/material.dart";
import "package:flutter_experimentation/services/my_theme.dart";


class RecordAudio extends StatefulWidget {
  const RecordAudio({Key? key}) : super(key: key);

  @override
  State<RecordAudio> createState() => _RecordAudioState();
}

class _RecordAudioState extends State<RecordAudio> {
  late Directory directory;
  late Stopwatch stopwatch;
  late Timer timer;
  late String elapsedTime;
  late String root;
  late String path;
  late bool recording;
  late bool colorsLoaded;
  late Widget button;


  @override
  void initState() {

    // Configure the root and recordings paths.
    root = "/storage/emulated/0";
    path = "$root/EPR402/Recordings";

    // Ensure the EPR402/Recordings path exists.
    directory = Directory(path);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    // Initialise the stopwatch.
    stopwatch = Stopwatch();

    // Initial elapsed time.
    elapsedTime = "00:00.0";

    // Not recording yet.
    recording = false;

    // Indicates that colors have to be loaded.
    colorsLoaded = false;

    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    // Button is initially start recording.
    if (!colorsLoaded) {
      colorsLoaded = true;
      button = startRecordingButton(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Record Audio"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            // The stopwatch reading.
            Padding(
              padding: const EdgeInsets.only(bottom: 48),
              child: Text(
                elapsedTime,
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),

            // The record / stop button.
            button,

          ],
        ),
      ),
    );
  }


  // The start recording button.
  Widget startRecordingButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: MyTheme.isDarkMode(context)
            ? Colors.red[700]
            : Colors.red,
        shape: CircleBorder(),
        padding: EdgeInsets.all(20),
      ),
      onPressed: () {

        // Restart the stopwatch.
        stopwatch.reset();
        stopwatch.start();

        // Change button to stop recording and reset the elapsed time.
        setState(() {
          button = stopRecordingButton(context);
          elapsedTime = "00:00.0";
        });

        // Update the elapsed time every 0.1 seconds.
        timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
          setState(() {
            elapsedTime = stopwatch.elapsed.toString().substring(2, 9);
          });
        });
      },
      child: Icon(
        Icons.mic,
        size: 30,
        color: Colors.white,
      ),
    );
  }


  // The stop recording button.
  Widget stopRecordingButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: MyTheme.isDarkMode(context)
            ? Colors.red[700]
            : Colors.red,
        shape: CircleBorder(),
        padding: EdgeInsets.all(20),
      ),
      onPressed: () {

        // Stop the stopwatch and timer.
        stopwatch.stop();
        timer.cancel();

        // Change button to start recording again.
        setState(() {
          button = startRecordingButton(context);
        });
      },
      child: Icon(
        Icons.stop,
        size: 30,
        color: Colors.white,
      ),
    );
  }


}
