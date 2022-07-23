
import 'dart:async';
//import 'dart:js';
//import 'dart:js';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import "package:flutter_map/flutter_map.dart";
import "package:latlong2/latlong.dart";
import "package:http/http.dart" as http;
import "dart:convert" as convert;
import 'package:mazi/Login.dart';
import 'Login.dart';
//void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Demo",
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
final String apiKey = "sO4qSzV4uconQAJya3rRc0VzSk6yE9Ab";
final FirebaseAuth _auth = FirebaseAuth.instance;
bool isloggedin = false;

  late BuildContext context;
  
late User user;

  

checkAuthentification()async{
  _auth.authStateChanges().listen((user) { 
    if(user==null){
     //Navigator.push(this.context , MaterialPageRoute(builder: (context)=>MyApp()));
     print("create an Account");
     Navigator.push(context, MaterialPageRoute(builder: ((context) => Login())));
    }
  });
}

getUser()async{
  User firebaseUser = await _auth.currentUser!;
  await firebaseUser.reload();
  firebaseUser = await _auth.currentUser!;
  if(firebaseUser!=null){
    setState((){
      this.user = firebaseUser;
      this.isloggedin=true;
    });
    
  }
}
@override
  Widget build(BuildContext context) {
    final tomtomHQ = LatLng(9.981636, 76.299881);
    return MaterialApp(
      title: "TomTom Map",
      home: Scaffold(
        body: Center(
            child: Stack(
          children: <Widget>[
            FlutterMap(
              options: MapOptions(center: tomtomHQ, zoom: 13.0),
              layers: [
                new TileLayerOptions(
                  urlTemplate: "https://api.tomtom.com/map/1/tile/basic/main/"
                      "{z}/{x}/{y}.png?key={apiKey}",
                  additionalOptions: {"apiKey": apiKey},
                ),
                new MarkerLayerOptions(
                  markers: [
                    new Marker(
                      width: 80.0,
                      height: 80.0,
                      point: tomtomHQ,
                      builder: (BuildContext context) => const Icon(
                          Icons.location_on,
                          size: 60.0,
                          color: Color.fromARGB(255, 78, 2, 2)),
                    ),
                  ],
                ),
              ],
            )
          ],
        )),
      ),
    );
  }
  
  void setState(Null Function() param0) {}
}

