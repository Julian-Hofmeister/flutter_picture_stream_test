// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// class ImagePickScreen extends StatefulWidget {
//   @override
//   _ImagePickScreenState createState() => _ImagePickScreenState();
// }
//
// class _ImagePickScreenState extends State<ImagePickScreen> {
//   final ImagePicker _picker = ImagePicker();
//   PickedFile _imageFile;
//
//   Future<void> _pickImage(ImageSource source) async {
//     final selected = await _picker.getImage(source: source);
//
//     setState(() {
//       _imageFile = selected;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           if (_imageFile != null)
//             Center(
//                 child: Container(
//                     width: 200, height: 200, child: Image.file(_imageFile))),
//           Center(
//             child: FlatButton(
//               onPressed: () {
//                 _pickImage(ImageSource.gallery);
//               },
//               child: Text("pick image"),
//               color: Colors.orangeAccent,
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
