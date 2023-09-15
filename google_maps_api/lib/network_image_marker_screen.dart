import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NetworkImageMarkerScreen extends StatefulWidget {
  const NetworkImageMarkerScreen({super.key});

  @override
  State<NetworkImageMarkerScreen> createState() =>
      _NetworkImageMarkerScreenState();
}

class _NetworkImageMarkerScreenState extends State<NetworkImageMarkerScreen> {
  final Set<Marker> markers = {};
  final List<LatLng> latlang = const <LatLng>[
    LatLng(24.87985023956981, 67.06155948026611),
    LatLng(24.88106308662598, 67.06242805955905),
    LatLng(24.877471927139403, 67.05912975612041),
  ];

  final Completer<GoogleMapController> _completer = Completer();

  static const CameraPosition cameraPosition = CameraPosition(
    target: LatLng(24.879777393461545, 67.06157881745668),
    zoom: 15,
  );

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    for (int i = 0; i < latlang.length; i++) {
      Uint8List? image = await loadNetworkImage(
          'https://media.istockphoto.com/id/503730889/photo/chicken-biryani-1-11.jpg?s=612x612&w=0&k=20&c=CBn9vQQp0-QRiQZuEMUNbhN6BVlnrbOAicSEaXOQn_o=');
      final ui.Codec markerImageCodec = await ui.instantiateImageCodec(
        image!.buffer.asUint8List(),
        targetWidth: 100,
        targetHeight: 100,
      );

      final ui.FrameInfo frameInfo = await markerImageCodec.getNextFrame();
      final ByteData? byteData = await frameInfo.image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      final Uint8List resizedImageMarker = byteData!.buffer.asUint8List();

      markers.add(
        Marker(
          icon: BitmapDescriptor.fromBytes(resizedImageMarker),
          markerId: const MarkerId('1'),
          position: latlang[i],
        ),
      );
      setState(() {});
    }
  }

  Future<Uint8List?> loadNetworkImage(String path) async {
    final completer = Completer<ImageInfo>();
    final image = NetworkImage(path);
    image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (info, _) {
          completer.complete(info);
        },
      ),
    );

    final imageInfo = await completer.future;

    final byteData =
        await imageInfo.image.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: cameraPosition,
        mapType: MapType.normal,
        myLocationButtonEnabled: true,
        myLocationEnabled: false,
        markers: markers,
        onMapCreated: (GoogleMapController mapController) {
          _completer.complete(mapController);
        },
      ),
    );
  }
}
