import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mazi/Start.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:authentification/Start.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'HomePage.dart';
import 'Login.dart';
import 'CreateGrp.dart';
import 'dart:math';

class CreateGrpPage extends StatefulWidget {
  @override
  _CreateGrpPageState createState() => _CreateGrpPageState();
}

class _CreateGrpPageState extends State<CreateGrpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore dbg = FirebaseFirestore.instance;
    FirebaseFirestore db11 = FirebaseFirestore.instance;
  FirebaseFirestore db12= FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late User user;
  late String _gname;
 var tcount;
 var scount;
 late String tid;
 
  bool isloggedin = false;

  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
            print("--------------------------------------------------------------------------");
    print(_gname);
    print("--------------------------------------------------------------------------");
     // if (user == null) {
        
        
      //}
      
               
             if(user!=null) { 
              String gcode = getcode();
                print(gcode);
                String id=user.uid;
                final addDoc = <String, dynamic>{
                              "gname": _gname,
                              "gid": gcode,
                              "scount":0,
                              "tcount":0


                  };
                //created group with gid
                  dbg
                    .collection("Groups")
                    .doc(gcode)//setting userid as docname
                    .set(addDoc)
                    .onError((e, _) => print("Error writing document: $e"));

                    Navigator.of(context).pushReplacementNamed("/");


                  //adding task collection by default during group creation
                  final docRef = db11.collection("Groups").doc(gcode);
                  docRef.get().then(
                    (DocumentSnapshot doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  tcount = data['tcount'];
                   tcount=tcount+1;  
                   print('--------------------------------------------------------------');
                  
                   print(tcount);
                   print('--------------------------------------------------------------');
                   
                  //tc = data['tcount'];
                  db12
                      .collection("Groups")
                      .doc(gcode)
                      .update({"tcount":tcount});
                    });  
                   String st=tcount.toString();
                   String t="task";
                   tid=t+st;    
                   print('--------------------------------------------------------------');
                   print(tid);
                   print(tcount);
                   print('--------------------------------------------------------------');
                  
                  final addDoc2 = <String, String>{
                  "text": "default",
                  "done": "no",
                  };

              
                  db12
                    .collection("Groups")
                    .doc(gcode)//setting userid as docname
                    .collection("to_do")
                    .doc(tid)
                    .set(addDoc2);
                  //adding saved location collection by default during group creation
                  final docRef1= db11.collection("Groups").doc(gcode);
                  docRef1.get().then(
                    (DocumentSnapshot doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  scount = data['scount'];
                   scount++;
                  //tc = data['tcount'];
                  db12
                      .collection("Groups")
                      .doc(gcode)
                      .update({"scount":scount});
                    });  
                  final addDoc3 = <String, dynamic>{
                  "lan": 123,
                  "lon": 567,
                  };  

                  dbg
                    .collection("Groups")
                    .doc(gcode)//setting userid as docname
                    .collection("SavedLocation")
                    .doc('sl'+scount.toString())
                    .set(addDoc3);

                  //setting gid of current user
                                  
                  dbg
                    .collection("Users")
                    .doc(id)//setting userid as docname
                    .update({"gid":gcode});
                    
                  //add current user to group user list
                 
                  final addDoc4 = <String, dynamic>{
                  "uid":id
                  };  

                  dbg
                    .collection("Groups")
                    .doc(gcode)//setting userid as docname
                    .collection("Users")
                    .doc(id)
                    .set(addDoc4);

                   
            }
      //}
    });
  }
  void initState() {
    super.initState();
    this.getUser();
    this.checkAuthentification();
    
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

  getcode(){
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
        return getRandomString(6);

  }
  close() async{
  Navigator.pop(context);
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
              print(_gname);
              }on FirebaseAuthException catch (e) {
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
            title: Text('ERROR',style: TextStyle(color: Colors.white),),
            content: Text(errormessage,style: TextStyle(color: Colors.white),),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK',style: TextStyle(color: Colors.white),))
            ],
          );
        });
  }
  navigateToCreateGrp() async {
    Navigator.pushReplacementNamed(context, "CreateGrpPage");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255,40, 49, 73),
        body: SingleChildScrollView(
      child: Container(
        height: 900,
        
        decoration: BoxDecoration(
          image: new DecorationImage(
            image: AssetImage('images/paper3.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken)
          )
        ),  
        child:
        Container(
          //height: 900,
          alignment: Alignment.center,
         margin: const EdgeInsets.fromLTRB(25, 180, 25, 180),
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            
            color: Color.fromARGB(255,40, 49, 73).withOpacity(0.8),
            border: Border.all(color: Colors.white.withOpacity(0.5),width: 3),
            borderRadius: BorderRadius.circular(20.0)
          ),
         child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          
          children: <Widget>[
            Expanded(child: 
            Container(
              padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
              //height: 200,
              child: Image(
                image: AssetImage("images/logo2.png"),
                fit: BoxFit.contain,
              ),
            ),
            ),
            Expanded(child: 
            Container(
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
                      child:
                       Text("Stay Connected",style: TextStyle(color: Colors.white,fontSize: 23),),
                    ),
                    //),
                    //   RaisedButton(
                    //   padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                    //   onPressed: navigateToCreateGrp,
                    //   child: Text('Create a Group',
                    //       style: TextStyle(
                    //           color: Colors.white,
                    //           fontSize: 20.0,
                    //           fontWeight: FontWeight.bold)),
                    //   color: Color.fromARGB(255,0, 129, 138),
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(20.0),
                    //   ),
                    // ),
                    //)
                    //),
                   
                    Expanded(child: 
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      alignment: Alignment.center,
                      child: Text("Enter Group Name",style: TextStyle(color: Colors.white,fontSize: 23),),
                    ),
                    ),
                    Expanded(child: 
                    
                    Container(
                      padding: new EdgeInsets.fromLTRB(5, 0, 5, 8),
                      child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          validator: (input) {
                            
                          },
                          
                          decoration: InputDecoration(
                              labelText: 'Group Name',
                              labelStyle: TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: Color.fromARGB(0,40, 49, 73),
                              
                              enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white, width: 2.0),
                              ),
                              prefixIcon: Icon(Icons.group,
                              color: Colors.white,
                              )
                              ),
                          onSaved: (input) => _gname = input!),
                    ),
                    ),
                    
                    
                    //SizedBox(height: 20),
                    RaisedButton(
                      padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                      onPressed: navigateToHome,
                      child: Text('Create Group',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold)),
                      color: Color.fromARGB(255,0, 129, 138),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    SizedBox(height: 5,)
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
    )
    )
    );
  }
}