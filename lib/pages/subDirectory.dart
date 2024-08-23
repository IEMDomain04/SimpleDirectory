import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SubDirectoryList extends StatefulWidget {
  final String directory;

  const SubDirectoryList({required this.directory});

  @override
  _SubDirectoryListState createState() => _SubDirectoryListState();
}

class _SubDirectoryListState extends State<SubDirectoryList> {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  List<Map<String, String>> dataList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Load data from secure storage
  Future<void> _loadData() async {
    final dataString = await _secureStorage.read(key: widget.directory);
    if (dataString != null) {
      setState(() {
        dataList = List<Map<String, String>>.from(
          json.decode(dataString).map((item) => Map<String, String>.from(item)),
        );
      });
    }
  }

  // Save data to secure storage
  Future<void> _saveData() async {
    final dataString = json.encode(dataList);
    await _secureStorage.write(key: widget.directory, value: dataString);
    setState(() {}); // Ensure UI update after saving
  }

  // Add a new item
  void _addItem() {
    _showDataDialog();
  }

  // Edit an existing item
  void _editItem(int index) {
    _showDataDialog(editIndex: index);
  }

  // Delete an item
  void _deleteItem(int index) {
    setState(() {
      dataList.removeAt(index);
    });
    _saveData();
  }

  // Show delete confirmation dialog
  void _showDeleteConfirmation(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete Directory"),
          content: Text("Are you sure you want to delete this Account?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _deleteItem(index);
                Navigator.pop(context);
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  // Show a dialog to add or edit data
  void _showDataDialog({int? editIndex}) {
    TextEditingController titleController = TextEditingController(
      text: editIndex != null ? dataList[editIndex]['title'] : '',
    );
    TextEditingController usernameController = TextEditingController(
      text: editIndex != null ? dataList[editIndex]['username'] : '',
    );
    TextEditingController passwordController = TextEditingController(
      text: editIndex != null ? dataList[editIndex]['password'] : '',
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
              editIndex == null ? 'Add Account' : 'Edit Account Information'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: false,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    usernameController.text.isNotEmpty &&
                    passwordController.text.isNotEmpty) {
                  setState(() {
                    if (editIndex == null) {
                      dataList.add({
                        'title': titleController.text,
                        'username': usernameController.text,
                        'password': passwordController.text,
                      });
                    } else {
                      dataList[editIndex] = {
                        'title': titleController.text,
                        'username': usernameController.text,
                        'password': passwordController.text,
                      };
                    }
                  });
                  _saveData();
                  Navigator.pop(context); // Close the dialog after saving
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF371375),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 43, 153, 0),
        title: Text(widget.directory),
      ),
      body: ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              dataList[index]['title'] ?? '',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dataList[index]['username'] ?? '',
                  style: TextStyle(color: Colors.white54),
                ),
                Text(
                  dataList[index]['password'] ?? '',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
            onTap: () => _editItem(index),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.white),
              onPressed: () => _showDeleteConfirmation(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: _addItem,
        child: Icon(Icons.add),
      ),
    );
  }
}
