// import 'package:flutter/foundation.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
// import 'package:flutter_geocoder/geocoder.dart';

// import 'package:flutter_geocoder/model.dart';
// import 'package:geocode/geocode.dart';
// import 'package:geolocator/geolocator.dart';

class AnotherScreen extends StatefulWidget {
  const AnotherScreen({super.key});

  @override
  State<AnotherScreen> createState() => _AnotherScreenState();
}

class _AnotherScreenState extends State<AnotherScreen> {
  String stAddress = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(stAddress),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () async {
                // final coordinates =
                //     Coordinates(24.879221657633803, 67.06582646931199);
                // const query =
                //     'Plot A 658, Block L North Nazimabad Town, Karachi, Karachi City, Sindh, Pakistan';
                // final result =
                //     await Geocoder.local.findAddressesFromQuery(query);
                // var second = result.first;
                // final address = await Geocoder.local
                //     .findAddressesFromCoordinates(coordinates);
                // var first = address.first;
                // if (kDebugMode) {
                //   print("Coordinates: ${second.coordinates}");
                //   print("Address: ${first.featureName}: ${first.addressLine}");
                // }
                // setState(() {
                //   stAddress = '${first.featureName}: ${first.addressLine}';
                // });
                // GeoCode geoCode = GeoCode();
                // final coordinates = await geoCode.reverseGeocoding(latitude: 24.879221657633803, longitude: 67.06582646931199);

                // final coordinates = Geolocator.getPositionStream();
                // if(kDebugMode) {
                //   print("${coordinates.streetAddress!}/n${coordinates.streetNumber}");
                // }
                // final position = await Geolocator.getCurrentPosition(
                //     desiredAccuracy: LocationAccuracy.high);
                // if (kDebugMode) {
                //   print(position.accuracy);
                // }
                List<Placemark> placemarks = await placemarkFromCoordinates(
                    24.880799870212215, 67.06229948961204);
                log('${placemarks.last.name.toString()}\n ${placemarks.last.street.toString()} ');
                  stAddress =
                      '${placemarks.reversed.last.name.toString()}\n ${placemarks.reversed.last.locality.toString()} ';
                setState(() {});
              },
              child: Container(
                height: 50.0,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: const Center(
                  child: Text(
                    'Convert',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
