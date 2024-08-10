import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
class Convert extends StatefulWidget {
  const Convert({super.key});

  @override
  State<Convert> createState() => _ConvertState();
}

class _ConvertState extends State<Convert> {
 String textadd='';
 String coordinateAdd=' 12';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Convert adress to coordinates"),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(textadd,style: TextStyle(fontSize: 30),),
         Text(coordinateAdd,style: TextStyle(fontSize: 30),),
          GestureDetector(
          onTap: () async {
            print('method');
            List<Location> locations = await locationFromAddress("Gronausestraat 710, Enschede");
             coordinateAdd=locations.last.longitude.toString()+"  "+locations.last.latitude.toString();
             List<Placemark> placemark=await placemarkFromCoordinates(34.0837, 74.7973);
             textadd=placemark.last.subLocality.toString();
             setState(() {});
             },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              color: Colors.black,
              child: Center(child: Text("Convert",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30),)),
            ),
          )
        ],
      ),
    ) ;
  }

}
