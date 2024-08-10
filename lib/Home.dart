import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Completer<GoogleMapController> mapcontroller=Completer();
  
  static const CameraPosition _kGooglePlex=CameraPosition(
      target: LatLng(17.37244, 78.43782),
      zoom: 17);
  
  List<Marker> _markers=[
    Marker(markerId: MarkerId('1'),
    position: LatLng(17.37244, 78.43782),
   infoWindow:InfoWindow(
     title:'my current location'
   )),
    
    Marker(
        markerId: MarkerId('srinagar'),
         position: LatLng(34.0837, 74.7973),
      infoWindow: InfoWindow(title: "Srinagar")
    )
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller){
              mapcontroller.complete(controller);
            },
           mapType: MapType.normal,
          compassEnabled: true,
          myLocationEnabled: true,
          markers: Set<Marker>.of(_markers),
        )),

      floatingActionButton: IconButton(
          onPressed: ()async{
          GoogleMapController controller=await mapcontroller.future;
          controller.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(34.0837, 74.7973),
            zoom: 13)
          ));
          }, icon: Icon(Icons.location_searching,size: 70,)),
    );
  }
}
