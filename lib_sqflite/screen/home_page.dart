import 'package:flutter/material.dart';

import '../models/student_model.dart';
import '../services/db_helper.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required String title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<StudentModel> students = [];
  final dbHelper = DatabaseHelper.instance;
  @override
  void initState() {
    _updateStudentMapList();
    super.initState();
  }

  _updateStudentMapList() async {
    final List<Map<String, dynamic>> studentMapList = await dbHelper
        .getStudentMapList();
    setState(() {
      students = studentMapList.map((e) => StudentModel.fromMap(e)).toList();
    });
  }

  _showFormDialog(StudentModel? students) {
    final nameController = TextEditingController(text: students?.name ?? "");
    final ageController = TextEditingController(
      text: students?.age.toString() ?? "",
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(students == null ? "Add Student" : "Edit Student"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Note :\n Here your data store in file."),
              TextField(
                controller: nameController,
                decoration: InputDecoration(label: Text("Name")),
              ),
              TextField(
                controller: ageController,
                decoration: InputDecoration(label: Text("Age")),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text;
                final age = int.tryParse(ageController.text);
                if (name.isNotEmpty && age != null) {
                  if (students == null) {
                    await dbHelper.insertStudent({"name": name, "age": age});
                    _updateStudentMapList();
                  } else {
                    await dbHelper.updateStudent({
                      "id": students.id,
                      "name": students.name,
                      "age": students.age,
                    });
                    _updateStudentMapList();
                  }
                  Navigator.pop(context);
                }
              },
              child: Text(students == null ? "Add" : "Update"),
            ),
          ],
        );
      },
    );
  }

  _deleteStudent(int id) async {
    await dbHelper.deleteStudent(id);
    _updateStudentMapList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SQflite project')),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(students[index].name),
                subtitle: Text(students[index].age.toString()),
                trailing: SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          _showFormDialog(students[index]);
                        },
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          _deleteStudent(students[index].id);
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFormDialog(null);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
