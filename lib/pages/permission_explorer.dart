import "package:flutter/material.dart";
import "package:permission_handler/permission_handler.dart";



class PermissionExplorer extends StatefulWidget {
  final String title;
  const PermissionExplorer({required this.title, Key? key}) : super(key: key);

  @override
  State<PermissionExplorer> createState() => _PermissionExplorerState();
}

class _PermissionExplorerState extends State<PermissionExplorer> {
  late List<String> titles;
  Map<String, bool> permissions = {};
  late int index;

  late bool permissionsPending;


  @override
  void initState() {

    // Initialise permission titles.
    titles = [
      "Record audio",
      "Access storage",
      "Manage external storage",
    ];

    // Initialise the permissions.
    permissionsPending = true;
    requestPermissions();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: permissionsPending
        ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text("Requesting permissions"),
              ),
            ],
          ),
        )
        : ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: titles.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(
                  titles[index],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Text(
                  "${permissions[titles[index]]}".toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
      ),
    );
  }


  // Requests all permissions from the predefined list.
  void requestPermissions() async {
    index = 0;

    // Record audio permission.
    await Permission.microphone.request();
    permissions[titles[index]] = await Permission.microphone.status.isGranted;
    print("${titles[index]}: ${permissions[titles[index++]]}");

    // Storage permission.
    await Permission.storage.request();
    permissions[titles[index]] = await Permission.storage.status.isGranted;
    print("${titles[index]}: ${permissions[titles[index++]]}");

    // External storage permission.
    await Permission.manageExternalStorage.request();
    permissions[titles[index]] = await Permission.manageExternalStorage.status.isGranted;
    print("${titles[index]}: ${permissions[titles[index++]]}");

    // All permissions requested.
    setState(() {
      permissionsPending = false;
    });
  }
}
