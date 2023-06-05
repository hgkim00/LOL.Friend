import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:lol_friend/models/user_location.dart';

class LocationService {
  UserLocation? userLocation;
  Position? _currentLocation;
  StreamSubscription<Position>? positionStream;
  Geolocator geolocator = Geolocator();

  final StreamController<UserLocation> _locationController =
      StreamController<UserLocation>();
  Stream<UserLocation> get locationStream => _locationController.stream;

  LocationService() {
    positionStream = Geolocator.getPositionStream().listen((location) {
      _locationController
          .add(UserLocation(location.latitude, location.longitude));
    });
  }

  void closeLocation() {
    if (positionStream != null) {
      positionStream!.cancel();
      _locationController.close();

      positionStream = null;
    } else {}
  }

  Future<UserLocation> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location Services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location Permissions are denied.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    _currentLocation = await Geolocator.getCurrentPosition();
    userLocation =
        UserLocation(_currentLocation!.latitude, _currentLocation!.longitude);

    return userLocation!;
  }
}
