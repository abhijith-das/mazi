import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mazi/Login.dart';
import 'SignUp.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String apiKey = "sO4qSzV4uconQAJya3rRc0VzSk6yE9Ab";
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  String long = "", lat = "";
  late StreamSubscription<Position> positionStream;


  Future<UserCredential> googleSignIn() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      if (googleAuth.idToken != null && googleAuth.accessToken != null) {
        final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

        final UserCredential user =
            await _auth.signInWithCredential(credential);

        await Navigator.pushReplacementNamed(context, "/");

        return user;
      } else {
        throw StateError('Missing Google Auth Token');
      }
    } else
      throw StateError('Sign in Aborted');
  }

  navigateToLogin() async {
    Navigator.pushReplacementNamed(context, "Login");
  }

  navigateToRegister() async {
    Navigator.pushReplacementNamed(context, "SignUp");
  }
  @override
  void initState() {
    checkGps();
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

  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print('Current Position: $position');
    //print('Current Latitude: $position.latitude');

    long = position.longitude.toString();
    lat = position.latitude.toString();
     if (!mounted) return;
    setState(() {
      //refresh UI
    });

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
       if (!mounted) return;
      setState(() {
        //refresh UI on update
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255,40, 49, 73),
      body:
      
       Container(
        
         decoration: BoxDecoration(
          image: new DecorationImage(
            image: AssetImage('images/paper3.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.darken)
          )
        ),  
        child:
        Column(children: [
           Expanded(
            child: Container(
          alignment: Alignment.center,
          
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.fromLTRB(30, 180, 30, 180),
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Color.fromARGB(255,40, 49, 73).withOpacity(0.8),
            border: Border.all(color: Colors.white.withOpacity(.5),width: 3),
            borderRadius: BorderRadius.circular(20.0)
          ),
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(child: 
            
            Container(
              //height: 250,
              child: Image(
                image: AssetImage("images/logo2.png"),
                fit: BoxFit.contain,
                
              ),
            )
            ),
            //SizedBox(height: 20),
            
            //SizedBox(height: 10.0),
            Text(
              'Stay Connected',
              style: TextStyle(color: Colors.white,
              fontSize: 30,
              backgroundColor: Colors.black.withOpacity(0.0),
              ),
            ),
            SizedBox(height: 30.0),
            
            Row(
              
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                    
                    //padding: EdgeInsets.only(left: 30, right: 30),
                    onPressed: navigateToLogin,
                    child: Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    color: Color.fromARGB(255,0, 129, 138)),
                SizedBox(width: 15.0),
                RaisedButton(
                    //padding: EdgeInsets.only(left: 30, right: 30),
                    onPressed: navigateToRegister,
                    child: Text(
                      'REGISTER',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    color: Color.fromARGB(255,0, 129, 138)),
              ],
            ),
            SizedBox(height: 10.0),
            SignInButton(Buttons.Google,
                text: "Sign up with Google", onPressed: googleSignIn)
          ],
        ),
        ),
        ),
        ],),
       
        
      ),
    );
  }
}