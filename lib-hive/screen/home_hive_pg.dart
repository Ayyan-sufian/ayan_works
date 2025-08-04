import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

class HomeHivePg extends StatefulWidget {
  const HomeHivePg({super.key});

  @override
  State<HomeHivePg> createState() => _HomeHivePgState();
}

class _HomeHivePgState extends State<HomeHivePg> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  List<Map<String, dynamic>> _item = [];

  //reference our box
  final _myBox = Hive.box('myBox');

  @override
  void initState() {
    super.initState();
    refreshItem(null, null, null, null);
    imageBytes = retrieveImg();
  }

  //refreshItem function

  void refreshItem(int? minAge, int? maxAge, bool? even, bool? odd) {
    final data = _myBox.keys
        .map((key) {
          final item = _myBox.get(key);
          if (item != null &&
              item["name"] != null &&
              item["name"].toString().trim().isNotEmpty &&
              item["age"] != null &&
              item["age"].toString().trim().isNotEmpty) {
            final int age = int.tryParse(item["age"].toString()) ?? -1;
            if (minAge != null && maxAge != null) {
              if (age < minAge || age > maxAge) return null;
            }
            if (even == true && age % 2 != 0) return null;
            if (odd == true && age % 2 != 1) return null;
            return {"key": key, "name": item["name"], "age": item["age"]};
          }
          return null;
        })
        .where((element) => element != null)
        .cast<Map<String, dynamic>>()
        .toList();

    setState(() {
      _item = data.reversed.toList();
      print(_item.length);
    });
  }

  List<Map<String, dynamic>> getEvenAge() {
    return _item.where((element) {
      final age = int.tryParse(element['age'].toString()) ?? -1;
      return age % 2 == 0;
    }).toList();
  }

  List<Map<String, dynamic>> getOddAge() {
    return _item.where((element) {
      final age = int.tryParse(element['age'].toString()) ?? -1;
      return age % 2 == 1;
    }).toList();
  }

  Future<void> _createItem(Map<String, dynamic> newItem) async {
    await _myBox.add(newItem);
    refreshItem(null, null, null, null);
  }

  //pop code
  void showPopup(BuildContext context, int? itemKey) async {
    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) {
        return SizedBox(
          height: 580,
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 15,
              top: 15,
              right: 15,
              left: 15,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(label: Text("Name")),
                ),
                TextField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(label: Text("Age")),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    _createItem({
                      "name": _nameController.text,
                      "age": _ageController.text,
                    });
                    _nameController.text = "";
                    _ageController.text = "";
                    Navigator.pop(context);
                  },
                  child: Text("Create New"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<Uint8List?> getAndSaveImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile == null) return null;
    final imageBytes = await pickedFile.readAsBytes();
    return Uint8List.fromList(imageBytes);
  }

  Future<Uint8List?> getCameraImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile == null) return null;
    final imageBytes = await pickedFile.readAsBytes();
    return Uint8List.fromList(imageBytes);
  }

  void ImagePopup(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              onTap: () async {
                Navigator.pop(context);
                final img = await getAndSaveImage();
                if (img != null) {
                  saveImg(img);
                  setState(() {
                    imageBytes = img;
                  });
                }
              },
              leading: Icon(Icons.photo),
              title: Text('Pick image from gallery'),
            ),
            ListTile(
              onTap: () async {
                Navigator.pop(context);
                final img = await getCameraImage();
                if (img != null) {
                  saveImg(img);
                  setState(() {
                    imageBytes = img;
                  });
                }
              },
              leading: Icon(Icons.camera_alt_outlined),
              title: Text('Pick image from camera'),
            ),
          ],
        ),
      ),
    );
  }

  void saveImg(Uint8List imageUint8List) {
    final Box imageBox = Hive.box('image');
    imageBox.put('imageKey', imageUint8List);
  }

  Uint8List? retrieveImg() {
    final imageBox = Hive.box('image');
    return imageBox.get('imageKey');
  }

  Uint8List? imageBytes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hive')),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Student: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: imageBytes != null
                          ? MemoryImage(imageBytes!)
                          : const NetworkImage(
                                  "https://cdn.imgbin.com/11/6/21/imgbin-computer-icons-login-person-user-avatar-log-KafDHUcGyAGRw1fv3nyHP6qhy.jpg",
                                )
                                as ImageProvider,
                    ),
                    Positioned(
                      bottom: -16,
                      right: -15,
                      child: IconButton(
                        onPressed: () async {
                          ImagePopup(context);
                        },
                        icon: Icon(Icons.add_a_photo, size: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  refreshItem(0, 9, null, null);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black12,
                ),
                child: Text("Age:0 > 9", style: TextStyle(color: Colors.black)),
              ),
              ElevatedButton(
                onPressed: () {
                  refreshItem(10, 19, null, null);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black12,
                ),
                child: Text(
                  "Age:10 > 19",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  refreshItem(20, 100, null, null);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black12,
                ),
                child: Text(
                  "Age:20 > 100",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _item = getEvenAge();
                    print(_item.length);
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black12,
                ),
                child: Text("Even age", style: TextStyle(color: Colors.black)),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _item = getOddAge();
                    print(_item.length);
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black12,
                ),
                child: Text("Odd age", style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              refreshItem(null, null, null, null);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black12),
            child: Text("NO filter", style: TextStyle(color: Colors.black)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _item.length,
              itemBuilder: (_, index) {
                final currentItem = _item[index];
                return Card(
                  color: Colors.white30,
                  margin: EdgeInsets.all(8),
                  elevation: 3,
                  child: ListTile(
                    title: Text(currentItem['name']),
                    subtitle: Text(currentItem['age'].toString()),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showPopup(context, null);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
