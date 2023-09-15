import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMarkerScreen extends StatefulWidget {
  const CustomMarkerScreen({super.key});

  @override
  State<CustomMarkerScreen> createState() => _CustomMarkerScreenState();
}

class _CustomMarkerScreenState extends State<CustomMarkerScreen> {
  final Completer<GoogleMapController> controller = Completer();
  final CustomInfoWindowController windowController =
      CustomInfoWindowController();

  Uint8List? markerImage;

  List<String> images = [
    'assets/images/car.png',
    'assets/images/pak-icon.png',
    'assets/images/motorbike.png',
  ];

  final List<Marker> markers = <Marker>[];
  final List<LatLng> latlang = const <LatLng>[
    LatLng(24.87985023956981, 67.06155948026611),
    LatLng(24.88106308662598, 67.06242805955905),
    LatLng(24.877471927139403, 67.05912975612041),
  ];

  static const CameraPosition cameraPosition = CameraPosition(
    zoom: 14.0,
    target: LatLng(24.880625476648113, 67.06170467671633),
  );

  Future<Uint8List> getBytesFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetHeight: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    for (int i = 0; i < images.length; i++) {
      final Uint8List markerIcon = await getBytesFromAssets(images[i], 30);
      markers.add(
        Marker(
            markerId: MarkerId(i.toString()),
            position: latlang[i],
            icon: BitmapDescriptor.fromBytes(markerIcon),
            infoWindow: InfoWindow(
              title: '$i',
            ),
            onTap: () {
             try {
                windowController.addInfoWindow!(
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  'https://media.istockphoto.com/id/503730889/photo/chicken-biryani-1-11.jpg?s=612x612&w=0&k=20&c=CBn9vQQp0-QRiQZuEMUNbhN6BVlnrbOAicSEaXOQn_o='),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const Text(
                          'Your customized text here.',
                          style: TextStyle(fontSize: 22.0),
                        ),
                      ],
                    ),
                  ),
                  latlang[i],
                );
              } catch (e) {
                log('$e from window controller');
              }
            }),
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: cameraPosition,
              mapType: MapType.normal,
              markers: Set<Marker>.of(markers),
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              onMapCreated: (GoogleMapController mapController) {
                controller.complete(mapController);
                windowController.googleMapController = mapController;
              },
              onTap: (position) {
                windowController.hideInfoWindow!();
              },
              onCameraMove: (position) {
                windowController.onCameraMove!();
              },
            ),
            CustomInfoWindow(
              controller: windowController,
              height: 200,
              width: 300,
              offset: 35,
            ),
          ],
        ),
      ),
    );
  }
}
