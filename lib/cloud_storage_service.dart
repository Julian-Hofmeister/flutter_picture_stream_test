import 'dart:io';

// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_picture_stream_test/cloud_storage_result.dart';

class CloudStorageService {
  final _firestore = FirebaseFirestore.instance;

  String getImageFileName({
    String title,
  }) {
    var imageFileName =
        title + DateTime.now().microsecondsSinceEpoch.toString();
    return imageFileName;
  }

  Future<CloudStorageResult> uploadImage({
    File imageToUpload,
    String title,
    String imageFileName,
    String name,
  }) async {
    var imageFileName = getImageFileName(title: title);
    await Firebase.initializeApp();

    _firestore.collection("images").add({
      "name": name,
      "image": imageFileName,
    });

    Reference ref = FirebaseStorage.instance.ref().child(imageFileName);

    UploadTask uploadTask = ref.putFile(imageToUpload);

    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      print('Snapshot state: ${snapshot.state}'); // paused, running, complete
      print('Progress: ${snapshot.totalBytes / snapshot.bytesTransferred}');
    }, onError: (Object e) {
      print(e); // FirebaseException
    });

    uploadTask.then((TaskSnapshot snapshot) {
      print('Upload complete!');
    }).catchError((Object e) {
      print(e); // FirebaseException
    });
    return null;
  }
}
