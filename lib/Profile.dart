import 'package:mazi/Start.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:authentification/Start.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'HomePage.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;
  bool isloggedin = false;

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
   await _auth.signOut().catchError((onError) {
          print("Error $onError");
        });;
        
    //user=null;
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut().catchError((onError) {
          print("Error $onError");
        });;
        
  }
  close() async{
  Navigator.pop(context);
}
  @override
  void initState() {
    super.initState();
    this.checkAuthentification();
    this.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255,4, 28, 50),
      appBar:  AppBar(
  title: Text("Profile"),
  
  backgroundColor: Color.fromARGB(255,6, 70, 99),
),
        body: Container(
          
      child: !isloggedin
          ? CircularProgressIndicator()
          : Column(
              children: <Widget>[
                SizedBox(height: 40.0),
                Container(
                  height: 200,
                  child: Image(
                    image: AssetImage("images/logo2.png"),
                    
                    fit: BoxFit.contain,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  alignment: Alignment.center,
                  child: Text(
                    "Name: ${user.displayName}",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,color: Colors.white),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  alignment: Alignment.center,
                  child: Text(
                    "Mail id: ${user.email}",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,color: Colors.white
                        ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child:RaisedButton(
                  
                  padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                  onPressed: close,
                  child: Icon(Icons.arrow_back,color: Colors.white,),
                  color: Colors.blueGrey,
                  shape: CircleBorder(),
                ),
                ),
                
                RaisedButton(
                  padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                  onPressed: signOut,
                  child: Text('Signout',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold)),
                  color: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                )
              ],
            ),
    ));
  }
}