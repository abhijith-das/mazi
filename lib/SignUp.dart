
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart' ;

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FirebaseFirestore dbu = FirebaseFirestore.instance;
    FirebaseFirestore dba = FirebaseFirestore.instance;
  late String _name, _email, _password;
  late int ucount;
  var id='';
  checkAuthentication() async {
    _auth.authStateChanges().listen((user) async {
      if (user != null) {
        Navigator.pushReplacementNamed(context, "welcome");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkAuthentication();
  }

  signUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        UserCredential user = await _auth.createUserWithEmailAndPassword(
            email: _email, password: _password);
            //final User user = auth.currentUser;
          
        if (user != null) {
          // UserUpdateInfo updateuser = UserUpdateInfo();
          // updateuser.displayName = _name;
          //  user.updateProfile(updateuser);
          // ignore: deprecated_member_use
          await _auth.currentUser!.updateProfile(displayName: _name);
          
          //print(user.email);
          // await Navigator.pushReplacementNamed(context,"/") ;
          //retrieve ucount from db
          
          // final docRef = dba.collection("Analytics").doc("count");
          // docRef.get().then(
          //   (DocumentSnapshot doc) {
          //     final data = doc.data() as Map<String, dynamic>;
          //     print("--------------------------------------------------------------");
          //       print(data['ucount']);
          //       ucount = data['ucount'];
          //       ucount++;
                
                
          //       //updating ucount to db
          //        dba
          //         .collection("Analytics")
          //         .doc("count")
          //         .update({"ucount":ucount});
                
               
          //         },
          //         onError: (e) => print("Error getting document: $e"),
            
          // );
          
          
          
        }
      }on FirebaseAuthException catch (e) {
        showError(e.message.toString());
        print(e.message);
      }
      
    }
  }
    navigateToLogin() async {
    Navigator.pushReplacementNamed(context, "Login");
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
            border: Border.all(color: Colors.white,width: 3),
            borderRadius: BorderRadius.circular(20.0)
          ),
         child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          
          children: <Widget>[
            Expanded(child: 
            Container(
              
              //height: 200,
              child: Image(
                image: AssetImage("images/logo2.png"),
                fit: BoxFit.contain,
              ),
            ),
            ),
            Expanded(child: 
            Container(
              child: Form(
                key: _formKey,
                child: Column(
                  
                  children: <Widget>[
                    Expanded(child: 
                    
                    Container(
                      padding: new EdgeInsets.all(5.0),
                      child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          validator: (input) {
                            if (input!.isEmpty) return 'Enter Name';
                          },
                          decoration: InputDecoration(
                            labelText: 'Name',
                             labelStyle: TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: Color.fromARGB(0,40, 49, 73),
                               enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                ),
                            prefixIcon: Icon(Icons.person,color: Colors.white,),

                          ),
                          onSaved: (input) => _name = input!),
                    ),
                    ),
                    Expanded(child: 
                    Container(
                      padding: new EdgeInsets.all(5.0),
                      child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          validator: (input) {
                            if (input!.isEmpty) return 'Enter Email';
                          },
                          decoration: InputDecoration(
                              labelText: 'Email',
                               labelStyle: TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: Color.fromARGB(0,40, 49, 73),
                               enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                ),
                              prefixIcon: Icon(Icons.email,color: Colors.white,),),
                          onSaved: (input) => _email = input!),
                    ),
                    ),
                    Expanded(child: 
                    Container(
                      padding: new EdgeInsets.all(5.0),
                      child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          validator: (input) {
                            if (input!.length < 6)
                              return 'Provide Minimum 6 Character';
                          },
                          decoration: InputDecoration(
                            labelText: 'Password',
                             labelStyle: TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: Color.fromARGB(0,40, 49, 73),
                               enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                ),
                            prefixIcon: Icon(Icons.lock,color: Colors.white,),
                          ),
                          obscureText: true,
                          onSaved: (input) => _password = input!),
                    ),
                    ),
                    //SizedBox(height: 20),
                    RaisedButton(
                      padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                      onPressed: signUp,
                      child: Text('SignUp',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold)),
                      color: Color.fromARGB(255,0, 129, 138),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                    child:  GestureDetector(
              child: Text('Login Instead?',
              style: TextStyle(color: Colors.white),),
              onTap: navigateToLogin,
              
            )
                    ),
                    
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