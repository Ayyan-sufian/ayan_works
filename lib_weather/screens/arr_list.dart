import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class arrList extends StatefulWidget {
  const arrList({super.key});

  @override
  State<arrList> createState() => _arrListState();
}

class _arrListState extends State<arrList> {
  late Box box;

  List<String> taskList = [
    'Task: 1',
    'Task: 2',
    'Task: 3',
    'Task: 4',
    'Task: 5',
    'Task: 6',
    'Task: 7',
    'Task: 8',
    'Task: 9',
    'Task: 10',
    'Task: 11',
    'Task: 12',
    'Task: 13',
  ];
  Future<void> initHiveBox() async {
    await Hive.initFlutter(); // Make sure it's initialized
    box = await Hive.openBox('taskBox');

    final stored = box.get('tasks' as Uri);
    if (stored != null && stored is List && stored.isNotEmpty) {
      taskList = List<String>.from(stored);
    } else {
      taskList = List.generate(13, (i) => 'Task: ${i + 1}');
      saveTask();
    }
  }

  void saveTask() {
    box.put('task', taskList);
  }

  void onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final item = taskList.removeAt(oldIndex);
      taskList.insert(newIndex, item);
      saveTask();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initHiveBox(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          appBar: AppBar(title: Text("List Page")),
          body: ReorderableListView.builder(
            itemCount: taskList.length,
            onReorder: onReorder,
            buildDefaultDragHandles: false,
            itemBuilder: (context, index) {
              final task = taskList[index];
              return ListTile(
                key: ValueKey(task),
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(task),
                ),
                trailing: ReorderableDragStartListener(
                  index: index,
                  child: const Icon(Icons.drag_handle),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
