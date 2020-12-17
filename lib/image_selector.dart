import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImageSelector {
  final picker = ImagePicker();

  Future<File> selectImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      print('No image selected.');
      return null;
    }
  }
}
