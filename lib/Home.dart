import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const CameraPosition _kGooglePlex=CameraPosition(
      target: LatLng(17.37244, 78.43782),
  zoom: 15
  );
  List<Marker> _markers=[
    Marker(markerId: MarkerId('1'),
    position: LatLng(17.37244, 78.43782),
   infoWindow:InfoWindow(
     title:'my current location'
   ))
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
          initialCameraPosition: _kGooglePlex,
         mapType: MapType.satellite,
        compassEnabled: true,
        myLocationEnabled: true,
        markers: Set<Marker>.of(_markers),
      ),
    );
  }
}
