import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_picture_stream_test/cloud_storage_service.dart';
import 'package:flutter_picture_stream_test/display_image_screen.dart';
import 'package:image_picker/image_picker.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String name;
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
        title: Text('Image Picker Example'),
      ),
      body: Center(
        child: _image == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('No image selected.'),
                  FlatButton(
                    color: Colors.orangeAccent,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ImageGalleryScreen()));
                    },
                    child: Text("Display Image"),
                  )
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 300,
                    width: 300,
                    child: Image.file(_image),
                  ),
                  TextField(
                    onChanged: (value) {
                      name = value;
                    },
                  ),
                  FlatButton(
                    color: Colors.orangeAccent,
                    onPressed: () {
                      _cloudStorageService.uploadImage(
                          imageToUpload: _image, title: "picture", name: name);
                    },
                    child: Text("Upload Image"),
                  ),
                  FlatButton(
                    color: Colors.orangeAccent,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ImageGalleryScreen()));
                    },
                    child: Text("Display Image"),
                  )
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
