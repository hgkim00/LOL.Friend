import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class LocationProvider with ChangeNotifier {
  String? mapsAPI = dotenv.env['GOOGLE_MAPS_API'];
  Geolocator geolocator = Geolocator();
  Position? currentPosition;

  Set<Marker> markers = {};

  LocationProvider() {
    _getCurrentLocation();
    _subscribeToLocationUpdates();
  }

  void _getCurrentLocation() async {
    currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    notifyListeners();
  }

  void _subscribeToLocationUpdates() async {
    Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;
    });
    await Future.delayed(const Duration(seconds: 1));
    notifyListeners();

    _searchNearbyPlaces(mapsAPI!, 'PC방');
  }

  void _searchNearbyPlaces(String mapsApi, String keyword) async {
    String baseUrl =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?";
    String url =
        '${baseUrl}location=${currentPosition!.latitude},${currentPosition!.longitude}&radius=2000&keyword=$keyword&key=$mapsApi';

    final response = await http.get(Uri.parse(url));
    final responseData = json.decode(response.body);
    for (int i = 0; i < responseData["results"].length; i++) {
      // print(responseData['results'][i]['geometry']['location']);
      double lat = responseData['results'][i]['geometry']['location']['lat'];
      double lng = responseData['results'][i]['geometry']['location']['lng'];
      markers.add(
        Marker(
          markerId: MarkerId('PC방$i'),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(title: responseData['results'][i]['name']),
        ),
      );
    }
    notifyListeners();
  }
}
