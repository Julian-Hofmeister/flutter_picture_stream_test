import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'file:///C:/Users/julia/AndroidStudioProjects/Flutter/flutter_picture_stream_test/lib/services/firebase_storage_service.dart';
import 'package:flutter_picture_stream_test/classes/food_class.dart';
import 'package:flutter_picture_stream_test/services/cloud_storage_service.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:path_provider/path_provider.dart';

Directory _appDocsDir;

class DisplayScreen extends StatefulWidget {
  @override
  _DisplayScreenState createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final CloudStorageService _cloudStorageService = CloudStorageService();

  QuerySnapshot cache;

  void initState() {
    super.initState();
    _getDir();
  }

  Future _getDir() async {
    _appDocsDir = await getApplicationDocumentsDirectory();
  }

  File fileFromDocsDir(String filename) {
    String pathName = p.join(_appDocsDir.path, filename);
    print(pathName);
    return File(pathName);
  }

  Future<Widget> _getImage(BuildContext context, String imageName) async {
    Image image;

    await FireStorageService.loadImage(context, imageName).then((value) {
      image = Image(
        image: NetworkToFileImage(
          file: fileFromDocsDir(imageName),
          url: value.toString(),
          debug: true,
        ),
        fit: BoxFit.cover,
      );
      print(value.toString());
    });
    return image;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        //STREAM
        initialData: cache,
        stream: _firestore.collection("menu").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.orangeAccent,
              ),
            );
          }

          List<Widget> imageList = [];
          List<Food> items = [];
          final images = snapshot.data.docs;

          //LISTEN TO TABLE
          for (var document in images) {
            print(document.metadata.isFromCache
                ? "NOT FROM NETWORK"
                : "FROM NETWORK");

            final id = document.id;
            final name = document.data()['name'];
            final image = document.data()['image'];
            final description = document.data()['description'];
            final price = document.data()['price'];

            Food food = Food(
              id: id,
              name: name,
              image: image,
              description: description,
              price: price,
            );

            items.insert(0, food);

            final imageBox = Container(
              margin: EdgeInsets.all(20),
              height: 200,
              width: 300,
              color: Colors.white,
              child: Row(
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.tealAccent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: FutureBuilder(
                        future: _getImage(context, food.image),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Container(
                              child: snapshot.data,
                            );
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Container();
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 150,
                          child: Text(
                            "Name: ${food.name}",
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: Text(
                            "Decription: ${food.description}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: Text(
                            "Price: ${food.price}",
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.black87,
                              size: 30,
                            ),
                            onPressed: () {
                              _cloudStorageService.deleteFood(food);
                            })
                      ],
                    ),
                  ),
                ],
              ),
            );
            imageList.insert(0, imageBox);
          }

          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: ListView(
              children: imageList,
            ),
          );
        },
      ),
    );
  }
}
