import 'package:flutter/material.dart';
// import 'package:google_maps_api/custom_marker.dart';
// import 'package:google_maps_api/network_image_marker_screen.dart';
// import 'package:google_maps_api/stylegooglemapscreen.dart';
import 'package:google_maps_api/polygon_screen.dart';
// import 'package:google_maps_api/another_screen.dart';
// import 'home_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const PolygonScreen(),
    );
  }
}
