import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StyleGoogleMapScreen extends StatefulWidget {
  const StyleGoogleMapScreen({super.key});

  @override
  State<StyleGoogleMapScreen> createState() => _StyleGoogleMapScreenState();
}

class _StyleGoogleMapScreenState extends State<StyleGoogleMapScreen> {
  final Completer<GoogleMapController> completer = Completer();

  String mapTheme = '';

  static const CameraPosition cameraPosition = CameraPosition(
    zoom: 14.0,
    target: LatLng(24.880625476648113, 67.06170467671633),
  );

  @override
  void initState() {
    super.initState();
    DefaultAssetBundle.of(context)
        .loadString('assets/map_themes/silver_theme.json')
        .then(
      (value) {
        mapTheme = value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () {
                  completer.future.then((value) => DefaultAssetBundle.of(context)
                      .loadString('assets/map_themes/dark_theme.json')
                      .then(
                    (value) {
                      mapTheme = value;
                    },
                  ));
                  setState(() {
                    
                  });
                },
                child: const Text('Silver'),
              ),
              PopupMenuItem(
                onTap: () {
                  completer.future.then((value) => DefaultAssetBundle.of(context)
                      .loadString('assets/map_themes/retro_theme.json')
                      .then(
                    (value) {
                      mapTheme = value;
                    },
                  ));
                  setState(() {
                    
                  });
                },
                child: const Text('Retro'),
              ),
              PopupMenuItem(
                onTap: () {
                  completer.future.then((value) => DefaultAssetBundle.of(context)
                      .loadString('assets/map_themes/dark_theme.json')
                      .then(
                    (value) {
                      mapTheme = value;
                    },
                  ));
                  setState(() {
                    
                  });
                },
                child: const Text('Dark'),
              ),
            ],
          )
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: cameraPosition,
        mapType: MapType.normal,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          controller.setMapStyle(mapTheme);
          completer.complete(controller);
        },
      ),
    );
  }
}
