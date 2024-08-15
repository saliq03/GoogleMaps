import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps/Utils/Constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

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
    Marker(markerId: MarkerId('2'),
        position: LatLng(15.37244, 77.43782),
        infoWindow:InfoWindow(
            title:'my current location'
        )),
    Marker(
        markerId: MarkerId('srinagar'),
         position: LatLng(34.0837, 74.7973),
      infoWindow: InfoWindow(title: "Srinagar")
    )
  ];

  Map<PolylineId,Polyline> polylines={};

  @override
  void initState() {
    super.initState();
    getPolylinePoints(LatLng(17.37244, 78.43782),LatLng(18.37244, 77.43782)).then((coordinates){
      print(coordinates);
      generatePolylineFromPoints(PolylineId("Polyline1"), coordinates);
    });
  }
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
          polylines: Set<Polyline>.of(polylines.values),
        )),

      floatingActionButton: IconButton(
          onPressed: ()async{
            getCurrentLocation().then((position) async {

              Marker marker=Marker(markerId: MarkerId("current location"),
              position: LatLng(position.latitude,position.longitude),
              infoWindow: InfoWindow(
                title: "Current Location"
              ));
              _markers.add(marker);
              setState(() {});
              GoogleMapController controller=await mapcontroller.future;
              controller.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                      target: LatLng(position.latitude,position.longitude),
                      zoom: 13)
              ));
            });


          }, icon: Icon(Icons.location_searching,size: 80,),color: Colors.blue,),
    );
  }

  Future<Position> getCurrentLocation()async{
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled=await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){
      print("service not enabled");
      return Future.error("service not enabled");
    }

   permission=await Geolocator.checkPermission();
    if(permission==LocationPermission.denied){
      permission=await Geolocator.requestPermission();
      if(permission==LocationPermission.denied){
        print("permission denied");
        return Future.error("permission denied");
      }}

    if(permission==LocationPermission.deniedForever){
      print("permission denied forever");
      return Future.error("permission denied forever");
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<List<LatLng>> getPolylinePoints(LatLng source,LatLng destination) async {
    List<LatLng> polylineCoordinates=[];
    print(" i am here\n");
    PolylinePoints polylinePoints=PolylinePoints();
    print(" i am here\n");
    PolylineResult result=await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: Constants.googleMap_ApiKey,
        request: PolylineRequest(
            origin: PointLatLng(source.latitude, source.longitude),
            destination: PointLatLng(destination.latitude, destination.longitude), mode: TravelMode.driving));
    if(result.points.isNotEmpty){
      print(" result is not empty\n");
      result.points.forEach((PointLatLng point){
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    else{
      print(result.errorMessage);
    }

    return polylineCoordinates;
  }
  
  void generatePolylineFromPoints(PolylineId id,List<LatLng> polylineCoordinates){
    Polyline polyline =Polyline(
        polylineId: id,
     points:  polylineCoordinates,
    color: Colors.blueAccent,
    width: 8);
    setState(() {
      polylines[id]=polyline;
    });

  }
}
