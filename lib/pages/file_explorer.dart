import "dart:io";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:path_provider/path_provider.dart";


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
    root = "/storage/emulated/0";
    directory = root;

    // The loading page.
    loading = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text("Loading"),
          ),
        ],
      ),
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
    files.clear();

    // Iterate through all entities.
    for (var entity in entities) {
      item = entity.toString().split(directory).last;

      // Check that item is not hidden.
      if (item[1] != ".") {
        item = item.substring(1, item.length-1);

        // Check if directory.
        if (Directory(entity.path).existsSync()) {
          folders.add(item);
        }

        // File otherwise.
        else {
          files.add(item);
        }
      }
    }

    // Sort contents case-insensitive.
    folders.sort((a, b) {
      return a.toUpperCase().compareTo(b.toUpperCase());
    });
    files.sort((a, b) {
      return a.toUpperCase().compareTo(b.toUpperCase());
    });

    // Format date time.
    DateTime dt = DateTime.now();
    DateFormat df = DateFormat("yyyy_MM_dd__HH_mm_ss");
    String now = df.format(dt);

    // Print everything.
    print("Timestamp: $now");
    print("Directory: $directory");
    print("Folders and files:");
    print("======================");
    for (var item in folders) {
      print(item);
    }
    print("======================");
    for (var item in files) {
      print(item);
    }

    // Set the content list widget.
    Widget content = contentWithDirectory(
      child: contentsList(
        folders: folders,
        files: files,
      ),
    );

    // Set the state.
    setState(() {
      body = content;
    });
  }


  // The directory contents list.
  Widget contentsList({
    required List<String> folders,
    required List<String> files,
  }) {

    // Show list of items.
    if (folders.isNotEmpty || files.isNotEmpty) {
      bool isFolder;

      // Combine lists
      List<String> items = folders + files;

      return ListView.separated(
        itemCount: items.length,
        separatorBuilder: (context, index) {
          return Divider(
            thickness: 1,
            height: 1,
          );
        },
        itemBuilder: (context, index) {
          isFolder = (index < folders.length);
          return ListTile(
            leading: Icon(
              isFolder ? Icons.folder : Icons.insert_drive_file,
              color: isFolder ? Colors.amber : null,
              size: 32,
            ),
            title: Text(items[index]),
            onTap: isFolder ? () {
              directory = "$directory/${items[index]}";
              body = contentWithDirectory(child: loading);
              setState(() {
                getContents(directory: directory);
              });
            } : () {},
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
              child: navigationBar(),
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


  // The top directory navigation bar.
  Widget navigationBar() {
    List<String> items = directory.split(root).last.split("/");

    // Remove blank item.
    if (items[0] == "") {
      items.removeAt(0);
    }

    // Add internal storage to items.
    items.insert(0, "Internal storage");

    // All navigation bar items go here.
    List<Widget> bar = [
      IconButton(
        onPressed: () {
          setState(() {
            inExplorerMode = false;
            directory = root;
            body = storage;
          });
        },
        icon: Icon(Icons.home),
      ),
    ];

    // Add all additional items.
    for (int i = 0; i < items.length; i++) {

      // Add separator.
      bar.add(Icon(Icons.chevron_right));

      // Only text button if not last item.
      if (items[i] == items.last) {
        bar.add(Text(
          items[i],
        ));
      } else {
        bar.add(TextButton(
          onPressed: () {
            items.removeRange(i+1, items.length);
            items.removeAt(0);
            setState(() {
              body = loading;
              directory = items.isNotEmpty
                  ? "$root/${items.join("/")}"
                  : root;
              getContents(directory: directory);
            });
          },
          style: TextButton.styleFrom(
            minimumSize: Size.zero,
            padding: EdgeInsets.zero,
          ),
          child: Text(items[i]),
        ));
      }
    }

    // The final navigation bar.
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Row(
        children: bar,
      ),
    );


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
        print(temp);
        temp.removeLast();
        setState(() {
          body = loading;
          directory = temp.join("/");
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
