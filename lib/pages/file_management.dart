import "package:flutter/material.dart";
import "package:flutter_experimentation/pages/file_explorer.dart";
import "package:flutter_experimentation/pages/path_provider.dart";


class FileManagement extends StatefulWidget {
  const FileManagement({Key? key}) : super(key: key);

  @override
  State<FileManagement> createState() => _FileManagementState();
}

class _FileManagementState extends State<FileManagement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("File Reading & Writing"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            // Path Provider Example.
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PathProviderExample()),
                );
              },
              child: Text("Path Provider Example"),
            ),

            // Path Provider Example.
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FileExplorer()),
                );
              },
              child: Text("File Explorer"),
            ),

          ],
        ),
      ),
    );
  }
}
