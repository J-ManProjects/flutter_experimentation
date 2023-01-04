import "package:flutter/material.dart";
import "package:flutter_experimentation/pages/permission_explorer.dart";
import "package:flutter_experimentation/pages/path_provider.dart";


class FileManagement extends StatefulWidget {
  const FileManagement({Key? key}) : super(key: key);

  @override
  State<FileManagement> createState() => _FileManagementState();
}

class _FileManagementState extends State<FileManagement> {
  late List<String> titles;


  @override
  void initState() {
    titles = [
      "Path Provider Example",
      "Permission Explorer",
    ];
    super.initState();
  }


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
                  MaterialPageRoute(builder: (context) {
                    return PathProviderExample(title: titles[0]);
                  }),
                );
              },
              child: Text(titles[0]),
            ),

            // Path Provider Example.
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return PermissionExplorer(title: titles[1]);
                  }),
                );
              },
              child: Text(titles[1]),
            ),

          ],
        ),
      ),
    );
  }
}
