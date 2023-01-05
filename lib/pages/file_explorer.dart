import "dart:io";
import "package:flutter/material.dart";
import "package:path_provider/path_provider.dart";
import "package:intl/intl.dart";


class FileExplorer extends StatefulWidget {
  final String title;
  const FileExplorer({required this.title, Key? key}) : super(key: key);

  @override
  State<FileExplorer> createState() => _FileExplorerState();
}

class _FileExplorerState extends State<FileExplorer> {
  late String? directory;
  late Widget storage;
  late Widget explore;
  late bool inExplorerMode;
  late bool internalStorage;
  late List contents;
  late List entities;


  @override
  void initState() {

    // Indicates if in file explorer mode.
    inExplorerMode = false;

    // The default storage page.
    storage = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          // Internal storage button.
          SizedBox(
            width: 180,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  inExplorerMode = true;
                  internalStorage = true;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.storage,
                      size: 48,
                    ),
                    Text(
                      "Internal storage",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // External storage button.
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: SizedBox(
              width: 180,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    inExplorerMode = true;
                    internalStorage = false;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.sd_storage,
                        size: 48,
                      ),
                      Text(
                        "SD card",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );

    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    // Explorer mode dummy.
    if (inExplorerMode) {
      getDirectory();
      explore = Center(
        child: Text(
          internalStorage
              ? "Exploring internal storage"
              : "Exploring SD card",
        ),
      );
    }

    return WillPopScope(
      onWillPop: backOverride,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: inExplorerMode ? explore : storage,
      ),
    );
  }


  // Get the contents of the internal storage directory.
  void getDirectory() async {
    directory = (await getExternalStorageDirectory())?.path;
    directory = directory?.replaceAll(
      RegExp("Android/data/com.experimental.flutter_experimentation/files"),
      "",
    );
    directory = "/storage/emulated/0/";

    // Get the contents of the directory.
    entities = Directory(directory!).listSync();
    contents = List.generate(entities.length, (index) {
      return entities[index].toString().split(directory!).last;
    });
    contents.sort();

    // Format date time.
    DateTime dt = DateTime.now();
    DateFormat df = DateFormat("yyyy_MM_dd__HH_mm_ss");
    String now = df.format(dt);

    // Print everything.
    print("Timestamp: $now");
    print("Directory: $directory");
    print("Contents of directory:");
    print("======================");
    for (var item in contents) {
      print(item);
    }
  }


  // Overrides the back button.
  Future<bool> backOverride() async {

    // Return to storage widget.
    if (inExplorerMode) {
      setState(() {
        inExplorerMode = false;
      });
      return false;
    }

    // Go back otherwise.
    else {
      return true;
    }
  }

}
