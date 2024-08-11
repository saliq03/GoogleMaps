import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps/Utils/Constants.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
class SearchPlaces extends StatefulWidget {
  const SearchPlaces({super.key});

  @override
  State<SearchPlaces> createState() => _SearchPlacesState();
}

class _SearchPlacesState extends State<SearchPlaces> {
  TextEditingController searchController=TextEditingController();
 List<dynamic> _placesList=[];
  var uuid=Uuid();
  String _sessionToken='';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchController.addListener((){
      OnChange();
    });
  }

  void OnChange() {
  if(_sessionToken==''){
    _sessionToken=uuid.v4();
  }
  OnSuggestions(searchController.text);
  }

  void OnSuggestions(String input)async {
    String apiKey=Constants.googleMap_ApiKey;
    String baseUrl='https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request='$baseUrl?input=$input&key=$apiKey&sessiontoken=$_sessionToken';
    var response=await http.get(Uri.parse(request));
    if(response.statusCode==200){
   var jsonData=jsonDecode(response.body);
   _placesList=jsonData['predictions'];
   setState(() {});
    }
    else{
      throw Exception('Failed to fetch ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Google Search Places Api',style: TextStyle(fontWeight: FontWeight.bold),),
          backgroundColor: Colors.blue,
          centerTitle: true,
        ),
       body: Column(
         children: [
           TextField(
             controller: searchController,
             decoration: InputDecoration(
               hintText:'  Search places'
             ),),
           Expanded(
             child: ListView.builder(itemCount: _placesList.length,
                 itemBuilder: (context,index){
                   return GestureDetector(
                     onTap: (){
                       setLocation(_placesList[index]['description']);
                     },
                     child: ListTile(
                       title:Text(_placesList[index]['description']) ,
                     ),
                   );
                 }),
           )
         ],
       ),
      ),
    );
  }

  void setLocation(String address) {
    searchController.text=address;
    

  }




}
