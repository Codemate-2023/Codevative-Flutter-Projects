// ignore_for_file: unused_field, library_private_types_in_public_api

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Set<Marker> _markers = {};
  bool _offlineMode = false;
  GoogleMapController? googleMapController;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(24.879848655792223, 67.06147664116476),
    zoom: 17,
  );

  static const CameraPosition _klocation = CameraPosition(
    target: LatLng(24.879848655792223, 67.06147664116476),
    zoom: 20,
  );

  Future<void> goToCurrentLocation() async {
    GoogleMapController mapController = await _controller.future;
    await mapController
        .animateCamera(CameraUpdate.newCameraPosition(_klocation));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps Offline'),
        actions: [
          IconButton(
            icon: Icon(_offlineMode ? Icons.cloud : Icons.cloud_off),
            onPressed: () {
              setState(() {
                _offlineMode = !_offlineMode;
              });
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _fetchAndSaveImage(),
        child: const Icon(
          Icons.telegram_rounded,
          size: 40,
        ),
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        zoomControlsEnabled: false,
        indoorViewEnabled: true,
        myLocationEnabled: true,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
          _controller.complete(controller);
          setState(() {});
        },
      ),
    );
  }

  Future<void> _fetchAndSaveImage() async {
    String imageUrl = 'https://maps.googleapis.com/maps/api/staticmap?'
        'center=24.879866274093573, 67.06150082437091&zoom=15&size=300x300&maptype=roadmap&key=AIzaSyBfoP4QxdOJefsKfDhmx5YB2CDHNbIUOIU';

    // Make a network request to get the image data
    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      // Convert the response body to Uint8List
      Uint8List imageData = response.bodyBytes;

      // Save the image data to a file
      Directory appDocumentsDirectory =
          await getApplicationDocumentsDirectory();
      String filePath = '${appDocumentsDirectory.path}/google_map_image.png';
      File file = File(filePath);
      await file.writeAsBytes(imageData);

      print('Image saved to: $filePath');
    } else {
      print('Failed to fetch image: ${response.statusCode}');
    }
  }
}
