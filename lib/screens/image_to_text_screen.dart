import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class ImageToTextScreen extends StatefulWidget {
  const ImageToTextScreen({super.key});

  @override
  _ImageToTextScreenState createState() => _ImageToTextScreenState();
}

class _ImageToTextScreenState extends State<ImageToTextScreen> {
  File? _pickedImage;
  String _recognizedText = '';

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    setState(() {
      _pickedImage = File(pickedImage!.path);
      _recognizedText = '';
    });
    _processImage();
  }

  Future<void> _processImage() async {
    final inputImage = InputImage.fromFile(_pickedImage!);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    final recognizedText = await textDetector.processImage(inputImage);
    String text = '';
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          text += '${element.text} ';
        }
        text += '\n';
      }
    }
    setState(() {
      _recognizedText = text;
    });
    textDetector.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image to Text'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              color: Colors.black,
              child: Center(
                child: _pickedImage != null
                    ? Image.file(
                        _pickedImage!,
                        fit: BoxFit.contain,
                      )
                    : const Text(
                        'No image selected.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: const Text('Pick Image'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => _pickImage(ImageSource.camera),
              child: const Text('Take Picture'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _recognizedText,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
