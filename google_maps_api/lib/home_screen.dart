import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _completer = Completer();

  final List<Marker> _markers = [];
  final List<Marker> _list = const [
    Marker(
      markerId: MarkerId('1'),
      position: LatLng(24.879777393461545, 67.06157881745668),
      infoWindow: InfoWindow(title: 'Dulara Business Center'),
    ),
    // Marker(
    //   markerId: MarkerId('2'),
    //   position: LatLng(24.879221657633803, 67.06582646931199),
    //   infoWindow: InfoWindow(title: 'Mandi House'),
    // ),
    // Marker(
    //   markerId: MarkerId('3'),
    //   position: LatLng(24.881402467080996, 67.06389054837871),
    //   infoWindow: InfoWindow(title: 'Medicare Cardiac and General Hospital'),
    // ),
  ];

  @override
  void initState() {
    super.initState();
    _markers.addAll(_list);
  }

  static const CameraPosition _kGgoogleMapCameraPosition = CameraPosition(
    target: LatLng(24.879777393461545, 67.06157881745668),
    zoom: 18.4746,
  );

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      log('$error');
    });
    return await Geolocator.getCurrentPosition();
  }
  
  loadData() async {
    await getUserCurrentLocation().then(
      (value) async {
        log('My current location: ${value.latitude} - ${value.longitude}');
        _markers.add(
          Marker(
            markerId: const MarkerId('5'),
            position: LatLng(value.latitude, value.longitude),
            infoWindow: const InfoWindow(title: 'My Current Location'),
          ),
        );
        CameraPosition cameraPosition = CameraPosition(
          zoom: 18.0,
          target: LatLng(value.latitude, value.longitude),
        );

        GoogleMapController controller = await _completer.future;
        controller.animateCamera(
          CameraUpdate.newCameraPosition(cameraPosition),
        );
        setState(() {});
      },
    ).onError((error, stackTrace) {
      log('$error - $stackTrace');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _kGgoogleMapCameraPosition,
        mapType: MapType.normal,
        compassEnabled: true,
        buildingsEnabled: true,
        indoorViewEnabled: true,
        mapToolbarEnabled: true,
        markers: Set<Marker>.of(_markers),
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _completer.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.location_disabled_outlined),
        onPressed: () {
          loadData();
        },
      ),
    );
  }
}
