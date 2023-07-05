import 'package:flutter/material.dart';
import 'screens/image_to_text_screen.dart';

void main() => runApp(const ImageToTextApp());

class ImageToTextApp extends StatelessWidget {
  const ImageToTextApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image to Text',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const ImageToTextScreen(),
    );
  }
}
