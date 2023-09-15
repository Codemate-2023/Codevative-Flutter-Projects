// ignore_for_file: library_private_types_in_public_api

import 'dart:developer';

// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sleep Detection',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _imageFile;
  bool _isSleeping = false;

  Future<void> _pickImage() async {
    debugPrint('pick image start');
    final imageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (imageFile != null) {
        _imageFile = File(imageFile.path);
        _isSleeping = false;
      } else {
        debugPrint('no image detected.');
      }
    });
    debugPrint('pick image');
    await _detectSleep();
  }

  Future<void> _detectSleep() async {
    debugPrint('detect sleep');
    final inputImage = InputImage.fromFile(_imageFile!);
    final options = FaceDetectorOptions();
    final faceDetector = GoogleMlKit.vision.faceDetector(options);
    final faces = await faceDetector.processImage(inputImage);

    for (Face face in faces) {
      // double? leftEyeOpenProbability = face.leftEyeOpenProbability ?? 0;
      // double? rightEyeOpenProbability = face.rightEyeOpenProbability ?? 0;
      // debugPrint("left eye: ${face.leftEyeOpenProbability}");
      // debugPrint("right eye: ${face.rightEyeOpenProbability}");

      if(face.headEulerAngleY! >= -18 && face.headEulerAngleY! <= 18.0 ){
        debugPrint('${face.headEulerAngleY}');
        if (face.leftEyeOpenProbability != null &&
            face.rightEyeOpenProbability != null) {
          if (face.leftEyeOpenProbability! < 0.4 &&
              face.rightEyeOpenProbability! < 0.4) {
            setState(() {
              _isSleeping = true;
            });
          }
        }
      }
    }

    faceDetector.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sleep Detection'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _imageFile != null
                ? Image.file(
                    _imageFile!,
                    height: 200,
                  )
                : const Text('No image selected'),
            const SizedBox(height: 20),
            _isSleeping
                ? const Text(
                    'The user is sleeping',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : const Text(
                    'The user is awake',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _pickImage();
          log('pick image log');
          // if (kDebugMode) {
          debugPrint('pick image print');
          // }
        },
        tooltip: 'Pick Image',
        child: const Icon(Icons.image),
      ),
    );
  }
}
