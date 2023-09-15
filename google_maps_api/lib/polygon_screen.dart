import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolygonScreen extends StatefulWidget {
  const PolygonScreen({super.key});

  @override
  State<PolygonScreen> createState() => _PolygonScreenState();
}

class _PolygonScreenState extends State<PolygonScreen> {
  static const CameraPosition _kGgoogleMapCameraPosition = CameraPosition(
    target:  LatLng(37.33500926, -122.03272188),
    zoom: 18.4746,
  );

  final Completer<GoogleMapController> _completer = Completer();

  final Set<Marker> markers = {};
  Set<Polygon> polygons = HashSet<Polygon>();
  Set<Polyline> polylines = HashSet<Polyline>();

  // List<LatLng> coordinates = const [
  //   LatLng(24.886073067245245, 67.05494067188151),
  //   LatLng(24.877352449666073, 67.0612099566062),
  //   LatLng(24.8746690588685, 67.07323412320258),
  //   LatLng(24.88397317546045, 67.07554893601932),
  //   LatLng(24.888727046129706, 67.06580743206786),
  //   LatLng(24.886073067245245, 67.05494067188151),
  // ];

  // static const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
  // static const LatLng destination = LatLng(37.33429383, -122.06600055);

  List<LatLng> coordinates = const [
    LatLng(37.33500926, -122.03272188),
    LatLng(37.33429383, -122.06600055),
    // LatLng(24.886073067245245, 67.05494067188151),
    // LatLng(24.88512945245948, 67.05606831942431),
    // LatLng(24.884357788820825, 67.05668604640205),
    // LatLng(24.881186653637076, 67.058442165094),
    // LatLng(24.879882208687867, 67.05989711612638),
    // LatLng(24.87983452862975, 67.06144727235417),
  ];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < coordinates.length; i++) {
      markers.add(
        Marker(
          markerId: MarkerId(i.toString()),
          position: coordinates[i],
          icon: BitmapDescriptor.defaultMarker,
          // infoWindow: const InfoWindow(title: 'Dulara Business Center'),
        ),
      );
      setState(() {});
    }

    polylines.add(
      Polyline(
        polylineId: PolylineId('1'),
        points: coordinates,
        width: 2,
        color: Colors.deepOrange,
        geodesic: true,
      ),
    );

    polygons.add(
      Polygon(
        polygonId: const PolygonId('1'),
        points: coordinates,
        fillColor: Colors.green.withOpacity(0.4),
        strokeWidth: 1,
        // geodesic: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Polygon Lines in Google Maps'),
      ),
      body: GoogleMap(
        initialCameraPosition: _kGgoogleMapCameraPosition,
        mapType: MapType.normal,
        myLocationButtonEnabled: true,
        myLocationEnabled: false,
        markers: markers,
        // polygons: polygons,
        polylines: polylines,
        onMapCreated: (GoogleMapController mapController) {
          _completer.complete(mapController);
        },
      ),
    );
  }
}
