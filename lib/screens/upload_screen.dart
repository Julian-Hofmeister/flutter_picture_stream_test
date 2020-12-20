import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_picture_stream_test/screens/display_screen.dart';
import 'package:flutter_picture_stream_test/services/cloud_storage_service.dart';
import 'package:image_picker/image_picker.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  String name;
  String description;
  String price;
  File _image;
  final picker = ImagePicker();
  // final ImageSelector _imageSelector = ImageSelector();
  final CloudStorageService _cloudStorageService = CloudStorageService();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Storage'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.tealAccent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  height: 200,
                  width: 400,
                  child: _image != null
                      ? Image.file(
                          _image,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          child: Center(
                            child: Text(
                              "No Image selected",
                              style: TextStyle(color: Colors.black87),
                            ),
                          ),
                        ),
                ),
                SizedBox(
                  height: 10,
                ),
                FlatButton(
                  minWidth: 400,
                  color: Colors.tealAccent,
                  onPressed: getImage,
                  child: Text(
                    "Select Image",
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  width: 400,
                  child: TextField(
                    decoration: InputDecoration(labelText: "Food Name:"),
                    cursorColor: Colors.deepOrangeAccent,
                    onChanged: (value) {
                      name = value;
                    },
                  ),
                ),
                SizedBox(
                  width: 400,
                  child: TextField(
                    maxLines: 3,
                    decoration: InputDecoration(labelText: "Food Description:"),
                    cursorColor: Colors.deepOrangeAccent,
                    onChanged: (value) {
                      description = value;
                    },
                  ),
                ),
                SizedBox(
                  width: 400,
                  child: TextField(
                    decoration: InputDecoration(labelText: "Food Price:"),
                    cursorColor: Colors.deepOrangeAccent,
                    onChanged: (value) {
                      price = value;
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                FlatButton(
                  minWidth: 400,
                  color: Colors.tealAccent,
                  onPressed: () {
                    if (name != null &&
                        _image != null &&
                        description != null &&
                        price != null) {
                      _cloudStorageService.uploadImage(
                        imageToUpload: _image,
                        title: "item",
                        name: name,
                        description: description,
                        price: price,
                      );
                    } else {
                      print("fuck off or input shit man!!!");
                    }
                  },
                  child: Text(
                    "Upload Image",
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                FlatButton(
                  minWidth: 400,
                  color: Colors.tealAccent,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DisplayScreen()));
                  },
                  child: Text(
                    "Display Menu",
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
