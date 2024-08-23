import 'dart:convert';

import 'package:account_directory/pages/subDirectory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DirectoryList extends StatefulWidget {
  const DirectoryList({super.key});

  @override
  State<DirectoryList> createState() => _DirectoryListState();
}

class _DirectoryListState extends State<DirectoryList> {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  List<String> directories = [];

  @override
  void initState() {
    super.initState();
    _loadDirectories();
  }

  // Load directories from secure storage
  Future<void> _loadDirectories() async {
    final directoriesString = await _secureStorage.read(key: 'directories');
    setState(() {
      directories = directoriesString != null
          ? List<String>.from(json.decode(directoriesString))
          : [];
    });
  }

  // Add a directory and save it to secure storage
  Future<void> _addDirectory() async {
    setState(() {
      directories.add("Directory ${directories.length + 1}");
    });
    await _secureStorage.write(
        key: 'directories', value: json.encode(directories));
  }

  // Edit the name of a directory and update secure storage
  Future<void> _editDirectory(int index, String newName) async {
    setState(() {
      directories[index] = newName;
    });
    await _secureStorage.write(
        key: 'directories', value: json.encode(directories));
  }

  // Delete a directory and update secure storage
  Future<void> _deleteDirectory(int index) async {
    setState(() {
      directories.removeAt(index);
    });
    await _secureStorage.write(
        key: 'directories', value: json.encode(directories));
  }

  // Function to handle the list item tap
  void _navigateToSubList(String directory) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubDirectoryList(directory: directory),
      ),
    );
  }

  // Show edit dialog
  void _showEditDialog(int index) {
    TextEditingController controller =
        TextEditingController(text: directories[index]);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Directory"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "Enter new name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _editDirectory(index, controller.text);
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  // Show delete confirmation dialog
  void _showDeleteConfirmation(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete Directory"),
          content: Text("Are you sure you want to delete this directory?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _deleteDirectory(index);
                Navigator.pop(context);
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  //Intructions about the App
  void _appDirectoryInstructions() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF371375),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 43, 153, 0),
        title: Text("Directory List", style: TextStyle(color: Colors.black)),
      ),
      body: ListView.builder(
        itemCount: directories.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              directories[index],
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => _navigateToSubList(directories[index]),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.white),
                  onPressed: () => _showEditDialog(index),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.white),
                  onPressed: () => _showDeleteConfirmation(index),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color(0xFF371375),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.add, color: Colors.white),
              onPressed: _addDirectory,
            ),
            SizedBox(width: 8),
            GestureDetector(
              onTap: _addDirectory,
              child: Text(
                "Add Directory",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
