import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class PlacesAPIScreen extends StatefulWidget {
  const PlacesAPIScreen({super.key});

  @override
  State<PlacesAPIScreen> createState() => _PlacesAPIScreenState();
}

class _PlacesAPIScreenState extends State<PlacesAPIScreen> {
  TextEditingController controller = TextEditingController();
  var uuid = const Uuid();
  String? _sessionToken = '11223344';
  List<dynamic> places = [];

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      onChange();
    });
  }

  onChange() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }

    getSuggestion(controller.text);
  }

  getSuggestion(String input) async {
    //Thanks to Musab bhai for providing me API key. 
    String placesApi = 'AIzaSyBfoP4QxdOJefsKfDhmx5YB2CDHNbIUOIU';
    String baseUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseUrl?input=$input&key=$placesApi&sessiontoken=$_sessionToken';

    var response = await http.get(Uri.parse(request));
    log(response.body.toString());

    if (response.statusCode == 200) {
      setState(() {
        places = jsonDecode(response.body.toString())['predictions'];
      });
    } else {
      log('error');
      throw Exception(
          "Error: ${response.statusCode} unable to get suggestions.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Google Places API'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'search places by name...',
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: places.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () async {
                      List<Location> locations = await locationFromAddress(places[index]['description']);
                      print(locations.last.longitude.toString()); 
                      print(locations.last.latitude.toString()); 
                    },
                    title: Text(places[index]['description']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
