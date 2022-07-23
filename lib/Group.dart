import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mazi/Start.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:authentification/Start.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'HomePage.dart';
import 'Login.dart';
import 'CreateGrp.dart';

class GroupPage extends StatefulWidget {
  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore db1 = FirebaseFirestore.instance;
  FirebaseFirestore db2 = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late User user;
  late String gcode;
  bool isloggedin = false;

  checkAuthentification() async {
    _auth.authStateChanges().listen((user) async {
      print(
          "--------------------------------------------------------------------------");
      print(gcode);
      print(
          "--------------------------------------------------------------------------");
      // if (user == null) {

      //}
      user=_auth.currentUser;

      if (user != null) {
       
        

        String id = user.uid;
        print(id);
        //DocumentReference<Map<String, dynamic>> _todo =FirebaseFirestore.instance.collection('/Groups/'+gcode+'/Users').doc(id);
        //await _todo.update({"uid": id});
        final addDoc4 = <String, dynamic>{"uid": id};

        db1
            .collection("Groups")
            .doc(gcode) //setting userid as docname
            .collection("Users")
            .doc(id)
            .set(addDoc4);

        db1
            .collection("Users")
            .doc(id) //setting userid as docname
            .update({"gid":gcode});    
      }


      Navigator.of(context).pushReplacementNamed("/");
      //}
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
    });
    ;

    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut().catchError((onError) {
      print("Error $onError");
    });
    ;
  }

  close() async {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    this.getUser();
    this.checkAuthentification();
  }

  navigateToLogin() async {
    //checkAuthentification();
    Navigator.pushReplacementNamed(context, "Login");
  }

  navigateToCreateGrp() async {
    Navigator.pushReplacementNamed(context, "CreateGrp");
  }
    @override
  navigateToHome() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        checkAuthentification();
        //await _auth.signInWithEmailAndPassword(
        //email: user.email, password: user.password);

        //print();
        print(gcode);
      } on FirebaseAuthException catch (e) {
        showError(e.message.toString());
        print(e);
      }
    }
  }
    showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color.fromARGB(255, 39, 38, 38),
            title: Text(
              'ERROR',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              errormessage,
              style: TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 40, 49, 73),
        body: SingleChildScrollView(
            child: Container(
          height: 900,
          decoration: BoxDecoration(
              image: new DecorationImage(
                  image: AssetImage('images/paper3.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.4), BlendMode.darken))),
          child: Container(
            //height: 900,
            alignment: Alignment.center,
            margin: const EdgeInsets.fromLTRB(25, 180, 25, 180),
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 40, 49, 73).withOpacity(0.8),
                border:
                    Border.all(color: Colors.white.withOpacity(0.5), width: 3),
                borderRadius: BorderRadius.circular(20.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                    //height: 200,
                    child: Image(
                      image: AssetImage("images/logo2.png"),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    //padding: EdgeInsets.all(5),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          //Expanded(child:
                          //Container(
                          // child:
                          //SizedBox(height: 20,),
                          // Expanded(child:
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 00, 10, 20),
                            //alignment: Alignment.center,
                            child: Text(
                              "Stay Connected",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 23),
                            ),
                          ),
                          //),
                          RaisedButton(
                            padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                            onPressed: navigateToCreateGrp,
                            child: Text('Create a Group',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                            color: Color.fromARGB(255, 0, 129, 138),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          //)
                          //),

                          //Expanded(child:
                          Container(
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.center,
                            child: Text(
                              "Or Join a Group",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          //),
                          Expanded(
                            child: Container(
                              padding: new EdgeInsets.fromLTRB(5, 0, 5, 8),
                              child: TextFormField(
                                  style: TextStyle(color: Colors.white),
                                  validator: (input) {
                                    if (input!.isEmpty) return 'Enter Code';
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Group ID',
                                    labelStyle: TextStyle(color: Colors.white),
                                    filled: true,
                                    fillColor: Color.fromARGB(0, 40, 49, 73),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white.withOpacity(0.7),
                                          width: 2.0),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.groups_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onSaved: (input) => gcode = input!),
                            ),
                          ),

                          //SizedBox(height: 20),
                          RaisedButton(
                            padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                            onPressed: navigateToHome,
                            child: Text('Join',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                            color: Color.fromARGB(255, 0, 129, 138),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          )
                          //         Container(
                          //           padding: EdgeInsets.all(5),
                          //         child:  GestureDetector(
                          //   child: Text('Login Instead?',
                          //   style: TextStyle(color: Colors.white),),
                          //   onTap: navigateToLogin,

                          // )
                          //         ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )));
  }
}