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
  late Duration contentDelay;
  List<String> allRoots = [];
  List<String> folders = [];
  List<String> files = [];
  late String appFolder;
  late String directory;
  late String root;
  late String rootTitle;
  late Widget storage;
  late Widget loading;
  late Widget body;
  late bool showFloating;
  late bool inExplorerMode;


  @override
  void initState() {

    // Indicates if the floating action button should be shown.
    showFloating = false;

    // Set the delay duration for getContents().
    contentDelay = const Duration(milliseconds: 1);

    // Indicates if in file explorer mode.
    inExplorerMode = false;

    // The relative app folder location.
    appFolder = "/Android/data/com.experimental.flutter_experimentation/files";

    // Initialise the root directories.
    loadRootDirectories();

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
                  root = directory = allRoots[0];
                  rootTitle = "Internal storage";
                  inExplorerMode = true;
                  showFloating = false;
                  body = contentWithDirectory(child: loading);
                });
                Future.delayed(contentDelay, () {
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
                    root = directory = allRoots[1];
                    rootTitle = "SD card";
                    inExplorerMode = true;
                    showFloating = false;
                    body = contentWithDirectory(child: loading);
                  });
                  Future.delayed(contentDelay, () {
                    getContents(directory: directory);
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
    print("Building");
    return WillPopScope(
      onWillPop: backOverride,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        floatingActionButton: showFloating ? ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(20),
          ),
          onPressed: () {

            // Format date time.
            DateTime dt = DateTime.now();
            DateFormat df = DateFormat("yyyy_MM_dd__HH_mm_ss");
            String now = df.format(dt);

            // Write to file.
            File file = File("$directory/$now.txt");
            file.writeAsString("Hello world!");

            // Refresh contents.
            getContents(directory: directory);
          },
          child: Icon(Icons.add),
        ) : null,
        body: SafeArea(
          child: body,
        ),
      ),
    );
  }


  // Load all root directories.
  void loadRootDirectories() async {

    // Clear all current roots.
    allRoots.clear();

    // Get the external storage directories.
    var directories = await getExternalStorageDirectories();

    // Add only the root paths
    for (var dir in directories!) {
      allRoots.add(dir.path.replaceAll(RegExp(appFolder), ""));
      print(allRoots.last);
    }
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

    // Print everything.
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

    // Set the state.
    setState(() {
      showFloating = true;
      body = contentWithDirectory(
        child: contentsList(
          folders: folders,
          files: files,
        ),
      );
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

      // Pull down to refresh with RefreshIndicator.
      return RefreshIndicator(
        onRefresh: pullDownRefresh,

        // Give the list view a scroll bar.
        child: Scrollbar(
          interactive: true,

          // Build ListView with Divider separator.
          child: ListView.separated(
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
                  setState(() {
                    directory = "$directory/${items[index]}";
                    showFloating = false;
                    body = contentWithDirectory(child: loading);
                  });
                  Future.delayed(contentDelay, () {
                    getContents(directory: directory);
                  });
                } : () {},
                trailing: getTrailing(
                  isFolder: isFolder,
                  item: items[index],
                ),
              );
            },
          ),
        ),
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


  // The function for pull down refresh.
  Future<void> pullDownRefresh() async {
    print("Refreshing");
    getContents(directory: directory);
  }


  // Get the list tile trailing widget.
  Widget? getTrailing({
    required bool isFolder,
    required String item,
  }) {

    // Folders return null.
    if (!isFolder) {

      // Delete button if text file.
      if (item.endsWith(".txt")) {
        return deleteButton(item: item);
      }

      // Info button if WAV file.
      else if (item.endsWith(".wav")) {
        return infoButton(item: item);
      }
    }

    return null;
  }


  // The text file delete button.
  Widget deleteButton({required String item}) {
    return IconButton(
      icon: Icon(Icons.delete),
      onPressed: () async {
        print("Deleting '$item'");
        await File("$directory/$item").delete();
        getContents(directory: directory);
      },
    );
  }


  // The WAV file info button.
  Widget infoButton({required String item}) {
    return IconButton(
      icon: Icon(Icons.info),
      onPressed: () {
        print("Info for '$item'");
      },
    );
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
    items.insert(0, rootTitle);

    // All navigation bar items go here.
    List<Widget> bar = [
      IconButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          setState(() {
            inExplorerMode = false;
            showFloating = false;
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
        bar.add(Text(items[i]));
      } else {
        bar.add(TextButton(
          onPressed: () {
            items.removeRange(i+1, items.length);
            items.removeAt(0);
            setState(() {
              showFloating = false;
              directory = items.isNotEmpty
                  ? "$root/${items.join("/")}"
                  : root;
              body = contentWithDirectory(child: loading);
            });
            Future.delayed(contentDelay, () {
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
          showFloating = false;
          body = storage;
        });
      }

      // Otherwise, return one level up.
      else {
        var temp = directory.split("/");
        print(temp);
        temp.removeLast();
        setState(() {
          showFloating = false;
          directory = temp.join("/");
          body = contentWithDirectory(child: loading);
        });
        getContents(directory: directory);
      }
      return false;
    }

    // Go back otherwise.
    else {
      return true;
    }
  }

}
