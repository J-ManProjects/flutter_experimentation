import "dart:async";
import "dart:io";
import "package:flutter/material.dart";
import "package:flutter_experimentation/services/my_theme.dart";
import "package:permission_handler/permission_handler.dart";
import "package:record/record.dart";
import "package:intl/intl.dart";


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
  late bool isRecording;
  late bool colorsLoaded;
  late bool permissionGranted;
  late Widget button;
  late Record record;


  @override
  void initState() {

    // Configure the root and recordings paths.
    root = "/storage/emulated/0";
    path = "$root/EPR402/Recordings";

    // Initialise the stopwatch.
    stopwatch = Stopwatch();

    // Initial elapsed time.
    elapsedTime = "00:00.0";

    // Not recording yet.
    isRecording = false;

    // Indicates that colors have to be loaded.
    colorsLoaded = false;

    // Initialise the recorder.
    record = Record();

    // Permission granted is initially false.
    permissionGranted = false;

    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    // Button is initially start recording.
    if (!colorsLoaded) {
      checkPermission();
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


  // Checks if microphone permission has been granted.
  void checkPermission() async {
    permissionGranted = await Permission.microphone.isGranted;
    await Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        button = startRecordingButton(context);
      });
    });
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
      onPressed: permissionGranted ? () async {

        // Ensure the EPR402/Recordings path exists.
        directory = Directory(path);
        if (!directory.existsSync()) {
          directory.createSync(recursive: true);
        }

        // Format date time.
        DateTime dt = DateTime.now();
        DateFormat df = DateFormat("yyyy_MM_dd__HH_mm_ss");
        String now = df.format(dt);

        // Change button to stop recording and reset the elapsed time.
        setState(() {
          button = stopRecordingButton(context);
        });

        // Start recording.
        await record.start(
          path: "$path/audio__$now.wav",
          encoder: AudioEncoder.wav,
          bitRate: 44100 * 16,
          samplingRate: 44100,
          numChannels: 1,
        );

        // Restart the stopwatch.
        stopwatch.reset();
        stopwatch.start();

        // Update the elapsed time every 0.1 seconds.
        timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
          setState(() {
            elapsedTime = stopwatch.elapsed.toString().substring(2, 9);
          });
        });
      } : null,
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
      onPressed: () async {

        // Stop the recording.
        await record.stop();

        // Stop the stopwatch and timer.
        stopwatch.stop();
        timer.cancel();

        // Change button to start recording again.
        setState(() {
          button = startRecordingButton(context);
        });

        // Reset the elapsed time after 1 second.
        Timer(Duration(seconds: 1), () {
          setState(() {
            elapsedTime = "00:00.0";
          });
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
