// ignore_for_file: unused_field, unused_local_variable, depend_on_referenced_packages, deprecated_member_use

// import 'dart:developer';

import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
// import 'package:tiktoklikescroller/tiktoklikescroller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: ((_) => const MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Video Player'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // late List<VideoPlayerController> _videoControllers;
  // late List<ChewieController> _chewieControllers;
  bool isInitialized = false;

  // List<String> urls = [
  //   'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
  //   'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
  //   'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4',
  //   "https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
  //   "https://storage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
  //   "https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
  //   "https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
  //   "https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
  //   "https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
  //   "https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4",
  //   "https://storage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4",
  //   "https://storage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4"
  // ];

  final List<String> urls = [
    "https://pinchom.s3.amazonaws.com/hvMCF-VID-20230109-WA0009.mp4",
    // "assets/videos/big_bunny.mp4",
    // 'https://assets.mixkit.co/videos/preview/mixkit-woman-turning-off-her-alarm-clock-42897-large.mp4',
    // 'https://assets.mixkit.co/videos/preview/mixkit-pair-of-plantain-stalks-in-a-close-up-shot-42956-large.mp4',
    // 'https://assets.mixkit.co/videos/preview/mixkit-aerial-view-of-city-traffic-at-night-11-large.mp4',
    // 'https://assets.mixkit.co/videos/preview/mixkit-countryside-meadow-4075-large.mp4',
    // 'https://assets.mixkit.co/videos/preview/mixkit-texture-of-different-fruits-42959-large.mp4',
    // 'https://assets.mixkit.co/videos/preview/mixkit-landscape-of-mountains-and-sunset-3128-large.mp4',
    // 'https://assets.mixkit.co/vi/deos/preview/mixkit-woman-washing-her-hair-while-taking-a-bath-42915-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-clouds-and-blue-sky-2408-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-different-types-of-fresh-fruit-in-presentation-video-42941-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-forest-stream-in-the-sunlight-529-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-stunning-sunset-seen-from-the-sea-4119-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-meadow-surrounded-by-trees-on-a-sunny-afternoon-40647-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-fruit-texture-in-a-humid-environment-42958-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-close-up-shot-of-a-turntable-playing-a-record-42920-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-woman-serving-eggs-in-a-pan-for-breakfast-42909-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-close-view-of-a-record-rotating-on-a-turntable-42921-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-young-woman-finishing-preparing-her-breakfast-42911-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-waterfall-in-forest-2213-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-close-up-view-of-a-rotating-vinyl-record-42922-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-going-down-a-curved-highway-down-a-mountain-41576-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-lake-surrounded-by-dry-grass-in-the-savanna-5030-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-aerial-panorama-of-a-landscape-with-mountains-and-a-lake-4249-large.mp4/',
    'https://assets.mixkit.co/videos/preview/mixkit-curvy-road-on-a-tree-covered-hill-41537-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-frying-diced-bacon-in-a-skillet-43063-large.mp4',
    // 'https://assets.mixkit.co/videos/preview/mixkit-young-woman-taking-a-shower-42916-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-rain-falling-on-the-water-of-a-lake-seen-up-18312-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-people-pouring-a-warm-drink-around-a-campfire-513-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-stars-in-space-1610-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-fireworks-illuminating-the-beach-sky-4157-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-huge-trees-in-a-large-green-forest-5040-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-close-up-shot-of-a-computers-internal-system-42924-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-lots-of-chips-and-dice-arranged-on-a-game-table-42931-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-fresh-apples-in-a-row-on-a-natural-background-42946-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-very-close-shot-of-the-leaves-of-a-tree-wet-18310-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-woman-preparing-her-lunch-in-the-morning-42908-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-woman-flipping-her-egg-omelet-42910-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-top-aerial-shot-of-seashore-with-rocks-1090-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-close-tour-through-the-middle-of-an-open-book-42926-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-white-sand-beach-and-palm-trees-1564-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-young-woman-waking-up-in-the-morning-42896-large.mp4'
  ];

  @override
  void initState() {
    super.initState();
    // _videoControllers = List<VideoPlayerController>.generate(
    //   urls.length,
    //   (index) => VideoPlayerController.network(urls[index]),
    // );
    // _chewieControllers = List<ChewieController>.generate(
    //   urls.length,
    //   (index) => ChewieController(
    //     videoPlayerController: _videoControllers[index],
    //     looping: true,
    //     showOptions: true,
    //     allowFullScreen: true,
    //     fullScreenByDefault: false,
    //     zoomAndPan: true,
    //     showControls: true,
    //     autoInitialize: true,
    //     // aspectRatio: _videoControllers[index].value.aspectRatio,
    //   ),
    // );

    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    // ]);

    // for (var controller in _videoControllers) {
    //   // setState(() {

    //   // });
    //   controller.initialize();
    //     isInitialized = true;
    // }
  }

  @override
  void dispose() {
    super.dispose();
    // for (var controller in _videoControllers) {
    //   controller.dispose();
    // }
    // for (var chewieController in _chewieControllers) {
    //   chewieController.dispose();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: VideoPlayer(
        urls: urls,
        dataSourceType: DataSourceType.network,
      ),
      // body: PageView.builder(
      //   physics: const BouncingScrollPhysics(),
      //   scrollDirection: Axis.vertical,
      //   itemCount: urls.length,
      //   itemBuilder: (context, index) {
      //     return isInitialized
      //         ? InkWell(
      //             onTap: () {
      //               _chewieControllers[index].isPlaying
      //                   ? _chewieControllers[index].pause()
      //                   : _chewieControllers[index].play();
      //             },
      //             child: AspectRatio(
      //               aspectRatio: _videoControllers[index].value.aspectRatio,
      //               child: Chewie(
      //                 controller: _chewieControllers[index],
      //               ),
      //             ),
      //           )
      //         : const Padding(
      //             padding: EdgeInsets.symmetric(
      //               vertical: 150.0,
      //               horizontal: 100.0,
      //             ),
      //             child: CircularProgressIndicator(
      //               color: Colors.blue,
      //               strokeWidth: 5.0,
      //             ),
      //           );
      //   },
      // ),
    );
  }

  final List<String> imagesGallery = [
    "https://pinchom.s3.amazonaws.com/hvMCF-VID-20230109-WA0009.mp4",
    "https://pinchom.s3.amazonaws.com/hvMCF-VID-20230109-WA0009.mp4",
    "https://pinchom.s3.amazonaws.com/hvMCF-VID-20230109-WA0009.mp4",
    'https://assets.mixkit.co/videos/preview/mixkit-woman-turning-off-her-alarm-clock-42897-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-pair-of-plantain-stalks-in-a-close-up-shot-42956-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-aerial-view-of-city-traffic-at-night-11-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-countryside-meadow-4075-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-texture-of-different-fruits-42959-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-landscape-of-mountains-and-sunset-3128-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-woman-washing-her-hair-while-taking-a-bath-42915-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-clouds-and-blue-sky-2408-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-different-types-of-fresh-fruit-in-presentation-video-42941-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-forest-stream-in-the-sunlight-529-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-stunning-sunset-seen-from-the-sea-4119-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-meadow-surrounded-by-trees-on-a-sunny-afternoon-40647-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-fruit-texture-in-a-humid-environment-42958-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-close-up-shot-of-a-turntable-playing-a-record-42920-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-woman-serving-eggs-in-a-pan-for-breakfast-42909-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-close-view-of-a-record-rotating-on-a-turntable-42921-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-young-woman-finishing-preparing-her-breakfast-42911-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-waterfall-in-forest-2213-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-close-up-view-of-a-rotating-vinyl-record-42922-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-going-down-a-curved-highway-down-a-mountain-41576-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-lake-surrounded-by-dry-grass-in-the-savanna-5030-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-aerial-panorama-of-a-landscape-with-mountains-and-a-lake-4249-large.mp4/',
    'https://assets.mixkit.co/videos/preview/mixkit-curvy-road-on-a-tree-covered-hill-41537-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-frying-diced-bacon-in-a-skillet-43063-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-young-woman-taking-a-shower-42916-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-rain-falling-on-the-water-of-a-lake-seen-up-18312-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-people-pouring-a-warm-drink-around-a-campfire-513-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-stars-in-space-1610-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-fireworks-illuminating-the-beach-sky-4157-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-huge-trees-in-a-large-green-forest-5040-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-close-up-shot-of-a-computers-internal-system-42924-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-lots-of-chips-and-dice-arranged-on-a-game-table-42931-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-fresh-apples-in-a-row-on-a-natural-background-42946-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-very-close-shot-of-the-leaves-of-a-tree-wet-18310-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-woman-preparing-her-lunch-in-the-morning-42908-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-woman-flipping-her-egg-omelet-42910-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-top-aerial-shot-of-seashore-with-rocks-1090-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-close-tour-through-the-middle-of-an-open-book-42926-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-white-sand-beach-and-palm-trees-1564-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-young-woman-waking-up-in-the-morning-42896-large.mp4'
  ];
}

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({
    super.key,
    required this.urls,
    required this.dataSourceType,
  });

  final List<String> urls;
  final DataSourceType dataSourceType;

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late List<VideoPlayerController> _videoPlayerControllers;
  late List<ChewieController> _chewieControllers;

  @override
  void initState() {
    super.initState();
    // _videoControllers = List<VideoPlayerController>.generate(
    //   urls.length,
    //   (index) => VideoPlayerController.network(urls[index]),
    // );
    // _chewieControllers = List<ChewieController>.generate(
    //   urls.length,
    //   (index) => ChewieController(
    //     videoPlayerController: _videoControllers[index],
    //     looping: true,
    //     showOptions: true,
    //     allowFullScreen: true,
    //     fullScreenByDefault: false,
    //     zoomAndPan: true,
    //     showControls: true,
    //     autoInitialize: true,
    //     // aspectRatio: _videoControllers[index].value.aspectRatio,
    //   ),
    // );
    switch (widget.dataSourceType) {
      case DataSourceType.asset:
        _videoPlayerControllers = List<VideoPlayerController>.generate(
          widget.urls.length,
          (index) => VideoPlayerController.asset(widget.urls[index]),
        );
        break;
      case DataSourceType.contentUri:
        _videoPlayerControllers = List<VideoPlayerController>.generate(
          widget.urls.length,
          (index) =>
              VideoPlayerController.contentUri(Uri.parse(widget.urls[index])),
        );
        break;
      case DataSourceType.network:
        _videoPlayerControllers = List<VideoPlayerController>.generate(
          widget.urls.length,
          (index) => VideoPlayerController.network(widget.urls[index]),
        );
        break;
      case DataSourceType.file:
        _videoPlayerControllers = List<VideoPlayerController>.generate(
          widget.urls.length,
          (index) => VideoPlayerController.file(File(widget.urls[index])),
        );
        break;
    }

    _chewieControllers = List<ChewieController>.generate(
      widget.urls.length,
      (index) => ChewieController(
        videoPlayerController: _videoPlayerControllers[index],
        looping: true,
        showOptions: true,
        allowFullScreen: true,
        fullScreenByDefault: false,
        zoomAndPan: true,
        showControls: true,
        autoInitialize: true,
        aspectRatio: _videoPlayerControllers[index].value.aspectRatio,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    for (var controller in _videoPlayerControllers) {
      controller.dispose();
    }
    for (var chewieController in _chewieControllers) {
      chewieController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: widget.urls.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return Chewie(
          controller: _chewieControllers[index],
        );
      },
    );
  }
}
