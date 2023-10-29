import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lol_friend/services/location_service.dart';
import 'package:lol_friend/widgets/bottom_navigation.dart';
import 'package:provider/provider.dart';

class MapsPage extends StatelessWidget {
  const MapsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: true);

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('LOL FIND PC ROOM'),
          centerTitle: true,
        ),
        body: locationProvider.currentPosition != null
            ? GoogleMap(
                myLocationEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    locationProvider.currentPosition!.latitude,
                    locationProvider.currentPosition!.longitude,
                  ),
                  zoom: 16,
                ),
                markers: locationProvider.markers,
              )
            : const Center(child: CircularProgressIndicator()),
        bottomNavigationBar: const BottomNavigation(),
      ),
    );
  }
}
