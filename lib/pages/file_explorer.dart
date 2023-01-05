import "dart:io";
import "package:flutter/material.dart";
import "package:intl/intl.dart";


class FileExplorer extends StatefulWidget {
  final String title;
  const FileExplorer({required this.title, Key? key}) : super(key: key);

  @override
  State<FileExplorer> createState() => _FileExplorerState();
}

class _FileExplorerState extends State<FileExplorer> {
  late List<FileSystemEntity> entities;
  List<String> folders = [];
  List<String> files = [];
  late String directory;
  late String root;
  late Widget storage;
  late Widget explore;
  late Widget loading;
  late Widget body;
  late bool inExplorerMode;
  late bool internalStorage;
  late bool contentsReady;


  @override
  void initState() {

    // Indicates if in file explorer mode.
    inExplorerMode = false;

    // Indicates whether the directory contents have loaded.
    contentsReady = false;

    // Initialise the root directory.
    root = "/storage/emulated/0/";
    directory = root;

    // The loading page.
    loading = Center(
      child: Text("Loading"),
    );

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
                  body = loading;
                  getContents(directory: directory);
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

    // Initialize body to storage selection.
    body = storage;

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: backOverride,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SafeArea(
          child: body,
        ),
      ),
    );
  }


  // Get the contents of the internal storage directory.
  void getContents({required String directory}) async {
    String item;

    // Get all files and folders within the directory.
    entities = Directory(directory).listSync();
    folders.clear();
    for (var entity in entities) {
      item = entity.toString().split(directory).last;
      if (item[0] != ".") {
        item = item.substring(0, item.length-1);
        if (Directory(entity.path).existsSync()) {
          folders.add(item);
        }
      }
    }

    // Sort contents case-insensitive.
    folders.sort((a, b) {
      return a.toUpperCase().compareTo(b.toUpperCase());
    });

    // Format date time.
    DateTime dt = DateTime.now();
    DateFormat df = DateFormat("yyyy_MM_dd__HH_mm_ss");
    String now = df.format(dt);

    // Print everything.
    print("Timestamp: $now");
    print("Directory: $directory");
    print("Contents of directory:");
    print("======================");
    for (var item in folders) {
      print(item);
    }

    // Set the content list widget.
    Widget content = contentWithDirectory(
      child: contentsList(folders: folders),
    );

    // Set the state.
    setState(() {
      body = content;
    });
  }


  // The content list widget
  Widget contentWithDirectory({required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(directory),
              ),
            ),
          ),
        ),
        Divider(
          height: 3,
          thickness: 3,
        ),
        Expanded(
          flex: 95,
          child: child,
        ),
      ],
    );
  }


  // The directory contents list.
  Widget contentsList({required List<String> folders}) {

    // Show list of items.
    if (folders.isNotEmpty) {
      return ListView.separated(
        itemCount: folders.length,
        separatorBuilder: (context, index) {
          return Divider(
            thickness: 1,
            height: 1,
          );
        },
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(
              Icons.folder,
              color: Colors.amber,
              size: 32,
            ),
            title: Text(folders[index]),
            onTap: () {
              directory = "$directory${folders[index]}/";
              body = contentWithDirectory(child: loading);
              setState(() {
                getContents(directory: directory);
              });
            },
          );
        },
      );
    }

    // Empty folder.
    else {
      return Center(
        child: Text(
          "Empty folder",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      );
    }
  }


  // Overrides the back button.
  Future<bool> backOverride() async {

    // Check if currently in file explorer mode.
    if (inExplorerMode) {

      // Back to storage selection if root.
      if (root == directory) {
        setState(() {
          inExplorerMode = false;
          body = storage;
        });
      }

      // Otherwise, return one level up.
      else {
        var temp = directory.split("/");
        temp.removeLast();
        temp.removeLast();
        setState(() {
          body = loading;
          directory = "${temp.join("/")}/";
          getContents(directory: directory);
        });
      }
      return false;
    }

    // Go back otherwise.
    else {
      return true;
    }
  }

}
