import 'package:flutter/material.dart';
import 'package:insta_assets_picker/insta_assets_picker.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Future<List<AssetEntity>?> callPicker() =>
              InstaAssetPicker.pickAssets(
                cropDelegate:
                    const InstaAssetCropDelegate(isSquareDefaultCrop: true),
                context,
                title: 'Select images',
                maxAssets: 10,
                closeOnComplete: true,
                onCompleted: (Stream<InstaAssetsExportDetails> cropStream) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          PickerCropResultScreen(cropStream: cropStream),
                    ),
                  );
                },
              );
          callPicker();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class PickerCropResultScreen extends StatelessWidget {
  const PickerCropResultScreen({super.key, required this.cropStream});

  final Stream<InstaAssetsExportDetails> cropStream;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height - kToolbarHeight;

    return Scaffold(
      body: StreamBuilder<InstaAssetsExportDetails>(
        stream: cropStream,
        builder: (context, snapshot) => CropResultView(
          selectedAssets: snapshot.data?.selectedAssets ?? [],
          croppedFiles: snapshot.data?.croppedFiles ?? [],
          progress: snapshot.data?.progress,
          heightFiles: height / 2,
          heightAssets: height / 4,
        ),
      ),
    );
  }
}

class CropResultView extends StatelessWidget {
  const CropResultView({
    super.key,
    required this.selectedAssets,
    required this.croppedFiles,
    this.progress,
    this.heightFiles = 300.0,
    this.heightAssets = 120.0,
  });

  final List<AssetEntity> selectedAssets;
  final List<File> croppedFiles;
  final double? progress;
  final double heightFiles;
  final double heightAssets;

  Widget _buildTitle(String title, int length) {
    return SizedBox(
      height: 20.0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(title),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            padding: const EdgeInsets.all(4.0),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.deepPurpleAccent,
            ),
            child: Text(
              length.toString(),
              style: const TextStyle(
                color: Colors.white,
                height: 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCroppedImagesListView(BuildContext context) {
    if (progress == null) {
      return const SizedBox.shrink();
    }

    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        children: [
          ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            scrollDirection: Axis.horizontal,
            itemCount: croppedFiles.length,
            itemBuilder: (BuildContext _, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 16.0,
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Image.file(croppedFiles[index]),
                ),
              );
            },
          ),
          if (progress! < 1.0)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).scaffoldBackgroundColor.withOpacity(.5),
                ),
              ),
            ),
          if (progress! < 1.0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                child: SizedBox(
                  height: 6,
                  child: LinearProgressIndicator(
                    value: progress,
                    semanticsLabel: '${progress! * 100}%',
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        AnimatedContainer(
          duration: kThemeChangeDuration,
          curve: Curves.easeInOut,
          height: croppedFiles.isNotEmpty ? heightFiles : 40.0,
          child: Column(
            children: <Widget>[
              _buildTitle('Cropped Images', croppedFiles.length),
              _buildCroppedImagesListView(context),
            ],
          ),
        ),
      ],
    );
  }
}
