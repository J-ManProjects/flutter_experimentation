import "dart:io";
import "package:flutter/material.dart";
import "package:path_provider/path_provider.dart";
import "package:intl/intl.dart";
import "package:flutter_experimentation/services/my_theme.dart";


class FileExplorer extends StatefulWidget {
  final String title;
  const FileExplorer({required this.title, Key? key}) : super(key: key);

  @override
  State<FileExplorer> createState() => _FileExplorerState();
}

class _FileExplorerState extends State<FileExplorer> {
  late String directory;
  late String root;
  late Widget storage;
  late Widget explore;
  late Widget loading;
  late Widget content;
  late Widget body;
  late bool inExplorerMode;
  late bool internalStorage;
  late bool contentsReady;
  late List<String> folders;
  late List<FileSystemEntity> entities;


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
      getContents(directory: directory);
      explore = Center(
        child: Text(
          internalStorage
              ? "Exploring internal storage"
              : "Exploring SD card",
        ),
      );
    }

    // Configure the body.
    if (inExplorerMode) {
      if (internalStorage && contentsReady) {
        body = content;
      } else {
        body = loading;
      }
    } else {
      body = storage;
    }

    return WillPopScope(
      onWillPop: backOverride,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: body,
      ),
    );
  }


  // Get the contents of the internal storage directory.
  void getContents({required String directory}) async {
    String item;

    // Get all files and folders within the directory.
    entities = Directory(directory).listSync();
    folders = [];
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
    content = contentsList(folders: folders);

    // Set the state.
    setState(() {
      contentsReady = true;
    });
  }


  // The directory contents list.
  Widget contentsList({required List<String> folders}) {

    // Show list of items.
    if (folders.isNotEmpty) {
      return ListView.separated(
        padding: const EdgeInsets.all(8.0),
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
              setState(() {
                directory = "$directory${folders[index]}/";
                contentsReady = false;
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

    // Return to storage widget.
    if (inExplorerMode) {
      if (root == directory) {
        setState(() {
          inExplorerMode = false;
        });
      } else {
        var temp = directory.split("/");
        print("Temp = $temp");
        temp.removeLast();
        temp.removeLast();
        setState(() {
          directory = "${temp.join("/")}/";
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
