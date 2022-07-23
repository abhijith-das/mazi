import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:mazi/Start.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mazi/Profile.dart';
import 'package:mazi/Task.dart';
import 'Group.dart';
import 'Profile.dart';
import 'Voice.dart';
import 'package:dart_ipify/dart_ipify.dart';
// import 'package:authentification/Start.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'Task.dart';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore dba = FirebaseFirestore.instance;
  final String apiKey = "sO4qSzV4uconQAJya3rRc0VzSk6yE9Ab";
  //final String apiKey = "sO4qSzV4uconQAJya3rRc0VzSk6yE9Ab";
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  String long = "", lat = "";
  var la=9.981636,lo= 76.299881;
  late String val1,val2;
  User? user;
  bool isloggedin = false;
  late StreamSubscription<Position> positionStream;
  
  
  
   getLocation() async {
   
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
     Timer(Duration(seconds: 5), () {
  //print("Yeah, this line is printed after 3 seconds");
   print('Current Position: $position');
    //print('Current Latitude: $position.latitude');

    long = position.longitude.toString();
    lat = position.latitude.toString();
    la=position.latitude;
    lo=position.longitude;
  });
   
     if (!mounted) return;
    setState(() {
      //addloc();
      //refresh UI
    });
    addloc();
    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 100, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      print(position.longitude); //Output: 80.24599079
      print(position.latitude); //Output: 29.6593457

      long = position.longitude.toString();
      lat = position.latitude.toString();
      la=position.latitude;
      lo=position.longitude;
       if (!mounted) return;
      setState(() {
        //refresh UI on update
      });
    }
    
    );

    //DatabaseReference ref = FirebaseDatabase.instance.ref();
    
  }

 
  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          print("'Location permissions are permanently denied");
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }

      if (haspermission) {
         if (!mounted) return;
        setState(() {
          //refresh the UI
        });

        getLocation();
      }
    } else {
      print("GPS Service is not enabled, turn on GPS location");
    }
     if (!mounted) return;
    setState(() {
      //refresh the UI
    });
  }
 addloc(){
    Timer(Duration(seconds: 1), () {
      la = position.latitude;
      lo = position.longitude;
      User? firebaseUser;
      firebaseUser = _auth.currentUser;
     //if (firebaseUser != null) {
      //checkAuthentification();
      String id = user!.uid;
      dba.collection("Users").doc(id).update({"lan": la, "lon": lo});
      setState(() {});
    //}
  });
 }
 
  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.of(context).pushReplacementNamed("start");
      }
      
    });
  }
  
  getUser() async {
    User? firebaseUser = _auth.currentUser;
    await firebaseUser?.reload();
    firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
       if (!mounted) return;
      setState(() {
        this.user = firebaseUser!;
        this.isloggedin = true;
      });
    }
  }

  signOut() async {
    try{
    _auth.signOut();
    user=null;
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    } catch (err) {
  // Handle err
  print(err);
  } 
  }
  navigateToProfile() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
  }
    navigateToVoice() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SpeechScreen()));
  }
  navigateToTask() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => TaskPage()));
  }
  navigateToGroup() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => GroupPage()));
  }

  // getProfileImage(){
  //   var _firebaseAuth = FirebaseAuth.instance;
  //   if(_firebaseAuth.currentUser?.photoURL!=null) {
  //     return Image.network(_firebaseAuth.currentUser.photoURL,height: 100,width: 100,);
  //   }
  // }

  @override
  void initState() {
    super.initState();
    this.checkAuthentification();
    this.getUser();
    this.checkGps();
    this.getLocation();
    this.addloc();
    
  }
  
  @override
  Widget build(BuildContext context) {
    //Timer(Duration(seconds: 10), () {
  //print("Yeah, this line is printed after 3 seconds");
  //getLocation();
  getLocation();
  //addloc();
  
//});
    //initState();
    final tomtomHQ = LatLng(la,lo);
    final tom = new LatLng(9.981636, 76.299881);
    final tom1 = new LatLng(9.981646, 76.399991);
    return MaterialApp(
      title: "Mazi",
      debugShowCheckedModeBanner: false,
      
      home: Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: const Text('Mαζί',style: TextStyle(fontSize: 25),),
          backgroundColor: Color.fromARGB(255, 63, 78, 79),
          actions: <Widget>[
            FlatButton(
              
              onPressed: navigateToProfile,
               child: Icon(Icons.person,color: Colors.white),)
          ],
          ),
        drawer: new Drawer(
          backgroundColor: Color.fromARGB(255, 31, 39, 40),
          child:   new ListView(
            children: <Widget>[
              Container(
                //color: Color.fromARGB(255,27, 36, 48),
                child: new UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 23, 48, 62),
                ),
                currentAccountPicture:// new CircleAvatar(
                  //backgroundColor: Color.fromARGB(0,27, 36, 48),
                  //backgroundImage:
                   ProfilePicture(
                    name: "${user?.displayName}",
                    radius: 25,
                    fontsize: 25,
                    tooltip: true,
                    
                  ),
                 // ),
                accountName: new Text("${user?.displayName}"), 
                accountEmail: new Text("${user?.email}")),
              ),
              
                TextButton(
                  onPressed: navigateToProfile, 
                  child: Text("button1"), 
                  ),
              Text("data1",style: TextStyle(color: Colors.white),),
              Text("data2",style: TextStyle(color: Colors.white),),
              TextButton(
                onPressed: navigateToGroup,
               child: Text('Leave Group',style: TextStyle(color: Colors.redAccent),)
               )
            ],
          ),
        ),
        body: Center(
            child: Stack(
          children: <Widget>[
            FlutterMap(
              options: MapOptions(center: tomtomHQ, zoom: 11.0),
              
              layers: [
                new TileLayerOptions(
                  urlTemplate: "https://api.tomtom.com/map/1/tile/basic/main/"
                      "{z}/{x}/{y}.png?key={apiKey}",
                  additionalOptions: {"apiKey": apiKey},
                  //backgroundColor: Color.fromARGB(255,4, 28, 50),
                ),
                new MarkerLayerOptions(
                  markers: [
                    new Marker(
                      width: 80.0,
                      height: 80.0,
                      
                      point: tomtomHQ,
                      builder: (BuildContext context) => Column(children:[
                        Column(
                          children:[
                            ProfilePicture(
                    name: "${user?.displayName}",
                    radius: 25,
                    fontsize: 25,
                    tooltip: true,
                    count:2,
                  ),
                          Container(
                            //padding: EdgeInsets.all(2),
                            color: Colors.black,
                            child: Text("${user?.displayName}",style: TextStyle(color: Colors.white) ,
                          ),
                         ),
                         
                      ]
                      ),
                          ]),
                    ), 
                    
                    new Marker(
                      width: 80.0,
                      height: 80.0,
                      
                      point: tom1,
                      builder: (BuildContext context) => Column(children:[
                        Column(
                          children:[
                          //   Icon(Icons.location_on_outlined,
                          
                          // size: 60.0,
                          // color: Colors.black),
                          
                          GestureDetector(
                          onLongPress: () {
                            
                            // showMenu(
                            //   items: <PopupMenuEntry>[
                            //     PopupMenuItem(
                            //       value: 'hii',
                            //       child: Row(
                            //         children: <Widget>[
                            //           Icon(Icons.delete),
                            //           Text("Delete"),
                            //         ],
                            //       ),
                            //     )
                            //   ],
                            //   context: context,position: RelativeRect.fill,
                            // );
                          new PopupMenuItem(child: Text('hi'));
                          
                          print("object");
                          },

                          child:Avatar(
                            
                            radius: 25, 
                            name: "${user?.displayName}", 
                            fontsize: 25,
                            
                          ),
                          
                          ),
                          Container(
                            //padding: EdgeInsets.all(2),
                            color: Colors.black,
                            child: Text("User2",style: TextStyle(color: Colors.white) ,
                          ),
                         ),
                         
                      ]
                      ),
                          ]),
                    ),
                  ],
                ),
                
              ],
            ),
             
            //  Container(
            //   alignment: Alignment.topRight,
            //   child: RaisedButton(
            //       padding: EdgeInsets.all(8),
                  
            //       onPressed: navigateToProfile,
            //       child: Icon(Icons.person,color: Colors.white,),
            //       shape:  RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(20.0),
            //       ),
            //       color: Colors.blueGrey,
                  
            //     )
            //  ),
             Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(10),
              child: FloatingActionButton(
              
              child: new Icon(Icons.mic),
              onPressed: navigateToVoice,
              backgroundColor: Color.fromARGB(255, 63, 78, 79),
              )
             ),
            
          ],
        )),
        bottomNavigationBar: 
        Container(
              height: 60,
              color: Color.fromARGB(0,0,0,0).withOpacity(0.0),
              //alignment: Alignment.bottomCenter,
              
              child: RaisedButton(
                onPressed:navigateToTask,
                color: Color.fromARGB(255, 63, 78, 79),
                //backgroundColor: Colors.blueGrey,
                shape: RoundedRectangleBorder(
                    
                    borderRadius: BorderRadius.vertical(top: Radius.circular(15),bottom: Radius.circular(2)),
                    
                  ),
                child:Container(
                  
                  child: Column(children: [
                    Icon(Icons.arrow_drop_up,color: Colors.white,size: 30,),
                    Text("TO-DO",style: TextStyle(color: Colors.white,fontSize: 20),)
                  ]),
                )
        )
             ),
      ),
    );
  }
}