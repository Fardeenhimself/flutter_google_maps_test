import 'package:flutter/material.dart';
import 'package:google_maps_demo/google_maps.dart';

void main() {
  runApp(const GoogleMapsDemo());
}

class GoogleMapsDemo extends StatelessWidget {
  const GoogleMapsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GoogleMaps() ,
    );
  }
}

