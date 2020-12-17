import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picture_stream_test/firebase_storage_service.dart';

class ImageGalleryScreen extends StatefulWidget {
  @override
  _ImageGalleryScreenState createState() => _ImageGalleryScreenState();
}

class _ImageGalleryScreenState extends State<ImageGalleryScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Widget> _getImage(BuildContext context, String imageName) async {
    Image image;
    await FireStorageService.loadImage(context, imageName).then((value) {
      image = Image.network(
        value.toString(),
        fit: BoxFit.scaleDown,
      );
    });
    return image;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        //STREAM
        stream: _firestore.collection("images").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.orangeAccent,
              ),
            );
          }

          List<Widget> imageList = [];
          final images = snapshot.data.docs;

          //LISTEN TO TABLE
          for (var document in images) {
            // final documentID = document.id;
            final name = document.data()['name'];
            final image = document.data()['image'];

            final imageBox = Container(
              height: 300,
              width: 300,
              child: Column(
                children: [
                  Container(
                    child: FutureBuilder(
                        future: _getImage(context, image),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Container(
                              height: 250,
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
                  Text(name),
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
