import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picture_stream_test/screens/upload_screen.dart';
import 'package:path_provider/path_provider.dart';

Directory _appDocsDir;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _appDocsDir = await getApplicationDocumentsDirectory();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(accentColor: Colors.tealAccent),
      home: UploadScreen(),
    );
  }
}
