import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:mazi/CreateGrp.dart';
import 'package:mazi/Group.dart';
import 'package:mazi/Login.dart';
import 'package:mazi/SignUp.dart';
import 'package:mazi/Start.dart';
import 'package:flutter/material.dart';
import 'package:mazi/melcowe.dart';
import 'HomePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mazi/Start.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:authentification/Start.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'Login.dart';
import 'HomePage.dart';
import 'Profile.dart';
import 'Group.dart';
import 'Voice.dart';
import 'melcowe.dart';
import 'savedloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mazi',
      theme: ThemeData(primaryColor: Colors.black),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      routes: <String, WidgetBuilder>{
        "Login": (BuildContext context) => Login(),
        "SignUp": (BuildContext context) => SignUp(),
        "start": (BuildContext context) => Start(),
        "HomePage": (BuildContext context) => HomePage(),
        "Profile": (BuildContext context) => ProfilePage(),
        "Voice": (BuildContext context) => SpeechScreen(),
        "Group": (BuildContext context) => GroupPage(),
        "CreateGrp": (BuildContext context) => CreateGrpPage(),
        "welcome": (BuildContext context) => Welcome(),
        'loc': (BuildContext context) => LocPage(),
      },
    );
  }
}
