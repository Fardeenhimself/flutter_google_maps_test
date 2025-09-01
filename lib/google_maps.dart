import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class GoogleMaps extends StatefulWidget {
  const GoogleMaps({super.key});

  @override
  State<GoogleMaps> createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  GoogleMapController ? mapController;

  LatLng ? _currentPosition;

  final Set<Marker> markers = {};

  Future getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // check if location service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location service disabled');
    }

    // check for permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions denied foreever!');
    }

    Position position = await Geolocator.getCurrentPosition();
    LatLng newPos = LatLng(position.latitude, position.longitude);

    setState(() {
      _currentPosition = newPos;
      markers.clear();
      markers.add(
        Marker(
          markerId: const MarkerId('current'),
          position: newPos,
          infoWindow: const InfoWindow(title: 'Currently here'),
        ),
      );
    });

    if (mapController != null) {
      mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(newPos, 14)
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps Demo'),
      ),
      body: _currentPosition == null ? Center(child: CircularProgressIndicator(),) : GoogleMap(
          onMapCreated: (GoogleMapController controller){
            mapController = controller;
            // If position is already loaded, animate to it
            if (_currentPosition != null) {
              controller.animateCamera(
                CameraUpdate.newLatLngZoom(_currentPosition!, 14),
              );
            }
          },
          initialCameraPosition: CameraPosition(
            target: _currentPosition!,
            zoom: 14
          ),
          markers: markers,
      ),
    );
  }
}
