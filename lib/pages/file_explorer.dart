import "dart:io";
import "package:flutter/material.dart";
import "package:flutter_experimentation/pages/wav_info.dart";
import "package:flutter_experimentation/services/wav_file.dart";
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
  late bool showAddFile;
  late bool inExplorerMode;


  @override
  void initState() {

    // Indicates if the floating action button should be shown.
    showAddFile = false;

    // Set the delay duration for getContents().
    contentDelay = const Duration(milliseconds: 50);

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
                storageButtonFunction(
                  selectedRoot: allRoots[0],
                  title: "Internal storage",
                );
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
                  storageButtonFunction(
                    selectedRoot: allRoots[1],
                    title: "SD card",
                  );
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
        body: SafeArea(
          child: body,
        ),
      ),
    );
  }


  // The function for the external storage buttons.
  void storageButtonFunction({
    required String selectedRoot,
    required String title,
  }) {
    setState(() {
      rootTitle = title;
      root = directory = selectedRoot;
      inExplorerMode = true;
      showAddFile = false;
      body = contentWithDirectory(child: loading);
    });
    Future.delayed(contentDelay, () {
      getContents(directory: directory);
    });
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
      showAddFile = true;
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
        onRefresh: refreshContent,

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
                subtitle: !isFolder
                    ? getSizeTextWidget(filename: items[index])
                    : itemsInFolder(folder: items[index]),
                onTap: isFolder ? () {
                  setState(() {
                    directory = "$directory/${items[index]}";
                    showAddFile = false;
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              onPressed: refreshContent,
              icon: Icon(
                Icons.refresh,
                size: 32,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Text(
                "Empty folder",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }


  // The function for refreshing the contents of the page.
  Future<void> refreshContent() async {
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
        String path = "$directory/$item";

        // The info list.
        List<String> info = [];

        // Chunk ID.
        var bytes = WavFile.wavToBytes(path);
        dynamic heading = WavFile.bytesToAscii(bytes.sublist(0, 4));
        info.add("\"$heading\"");

        // Chunk Size.
        heading = WavFile.bytesToUint32(bytes.sublist(4, 8));
        heading = calculateFormattedSize(size: heading);
        info.add(heading);

        // Format.
        heading = WavFile.bytesToAscii(bytes.sublist(8, 12));
        info.add("\"$heading\"");

        // Sub-Chunk 1 ID.
        heading = WavFile.bytesToAscii(bytes.sublist(12, 16));
        info.add("\"$heading\"");

        // Sub-Chunk 1 Size.
        heading = WavFile.bytesToUint32(bytes.sublist(16, 20));
        heading = calculateFormattedSize(size: heading);
        info.add(heading);

        // Audio Format.
        heading = WavFile.bytesToUint16(bytes.sublist(20, 22));
        info.add("$heading (PCM)");

        // Num Channels.
        heading = WavFile.bytesToUint16(bytes.sublist(22, 24));
        info.add("$heading (${heading == 1 ? "mono" : "stereo"} audio)");

        // Sample Rate.
        heading = WavFile.bytesToUint32(bytes.sublist(24, 28));
        info.add("$heading Hz");

        // Byte Rate.
        heading = WavFile.bytesToUint32(bytes.sublist(28, 32));
        info.add("$heading B/s");

        // Block Align.
        heading = WavFile.bytesToUint16(bytes.sublist(32, 34));
        info.add("$heading");

        // Bits Per Sample.
        heading = WavFile.bytesToUint16(bytes.sublist(34, 36));
        info.add("$heading");

        // Sub-Chunk 2 ID.
        int index = 36;
        do {
          heading = WavFile.bytesToAscii(bytes.sublist(index, index+4));
          index += 2;
        } while (heading != "data");
        info.add("\"$heading\"");

        // Sub-Chunk 2 Size.
        index += 2;
        heading = WavFile.bytesToUint32(bytes.sublist(index, index+4));
        info.add("$heading bytes");

        // Show the information page.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return WavInfo(
                title: item,
                info: info,
              );
            },
          ),
        );
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
          child: navigationBar(),
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

    // Add the root title to items.
    items.insert(0, rootTitle);

    // All navigation bar items go here.
    List<Widget> bar = [
      IconButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          setState(() {
            inExplorerMode = false;
            showAddFile = false;
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
              showAddFile = false;
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
    return Row(
      children: <Widget>[
        Expanded(
          flex: 9,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Row(children: bar),
              ),
            ),
          ),
        ),
        VerticalDivider(
          width: 1,
          thickness: 1,
        ),
        Expanded(
          flex: 1,
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(Icons.add),
            onPressed: showAddFile ? () {

              // Format date time.
              DateTime dt = DateTime.now();
              DateFormat df = DateFormat("yyyy_MM_dd__HH_mm_ss");
              String now = df.format(dt);
              now = "${now}_${dt.millisecond.toStringAsPrecision(3)}";

              // Write to file.
              File file = File("$directory/$now.txt");
              file.writeAsString("File created at:\n${dt.toString()}");

              // Refresh contents.
              Future.delayed(Duration(milliseconds: 100), () {
                getContents(directory: directory);
              });
            } : null,
          ),
        ),
      ],
    );
  }


  // Widget with the number of items in the folder.
  Widget? itemsInFolder({required String folder}) {

    // If folder inaccessible, return null;
    try {

      // Get the number of items.
      var dir = Directory("$directory/$folder");
      int count = dir.listSync().length;

      // Format the text output.
      return Text((count == 1) ? "1 item" : "$count items");
    } catch (e) {
      return null;
    }
  }


  // Calculates the file size text widget with the appropriate unit.
  Widget getSizeTextWidget({required String filename}) {
    int size = File("$directory/$filename").lengthSync();
    return Text(calculateFormattedSize(size: size));
  }


  // Give the file size an appropriate unit.
  String calculateFormattedSize({required int size}) {

    // Check if size = 1 byte.
    if (size == 1) {
      return "1 byte";
    }

    // Initialise stuff.
    List<String> suffix = ["bytes", "KB", "MB", "GB", "TB"];
    double doubleSize = size.toDouble();

    // Determine the size in terms of the suffixes.
    int index = 0;
    while (doubleSize >= 1000) {
      doubleSize /= 1024;
      index++;
    }

    // Three significant digits are shown at all time (except for bytes).
    String text;
    if (doubleSize >= 100 || index == 0) {
      text = doubleSize.toStringAsFixed(0);
    } else if (doubleSize >= 10) {
      text = doubleSize.toStringAsFixed(1);
    } else {
      text = doubleSize.toStringAsFixed(2);
    }
    return "$text ${suffix[index]}";
  }


  // Overrides the back button.
  Future<bool> backOverride() async {

    // Check if currently in file explorer mode.
    if (inExplorerMode) {

      // Back to storage selection if root.
      if (root == directory) {
        setState(() {
          inExplorerMode = false;
          showAddFile = false;
          body = storage;
        });
      }

      // Otherwise, return one level up.
      else {
        setState(() {
          showAddFile = false;
          directory = Directory(directory).parent.path;
          body = contentWithDirectory(child: loading);
        });
        Future.delayed(contentDelay, () {
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
