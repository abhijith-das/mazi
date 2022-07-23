import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'SignUp.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;
  FirebaseFirestore dbu = FirebaseFirestore.instance;
  FirebaseFirestore dba = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late var ucount;
  bool isloggedin=false;
  late String _pno, _ano;

  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        //print(user);
        String id= user.uid;
        String name = 'null';
        name=user.displayName!;
        final addDoc = <String, dynamic>{
        "name": name,
        "uid": id,
        "phno":_pno,
        "age":_ano,
        "gid":"null",
        "lan":0,
        "lon":0
        };

        dbu
                .collection("Users")
                .doc(id)//setting userid as docname
                .set(addDoc)
                .onError((e, _) => print("Error writing document: $e"));
                          
        final docRef = dba.collection("Analytics").doc("count");
        docRef.get().then(
          (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        ucount = data['ucount'];
        ucount++;

        dba
                          .collection("Analytics")
                          .doc("count")
                          .update({"ucount":ucount});});


        Navigator.pushReplacementNamed(context, "/");
      }
    });
  }

  @override
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
  login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      try {
        checkAuthentification();
        //await _auth.signInWithEmailAndPassword(
            //email: user.email, password: user.password);
            
              print(_pno);
              print(_ano);
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255,40, 49, 73),
        body: SingleChildScrollView(
        child:Container(
          height: 900,
        width: double.infinity,
        decoration: BoxDecoration(
          image: new DecorationImage(
            image: AssetImage('images/paper3.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken)
          )
        ),  
      child: Column(
        
        //alignment: Alignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
      children:<Widget>[
        //SizedBox(height: 100,),
         Container(
          
        alignment: Alignment.center,
         margin: const EdgeInsets.fromLTRB(30, 100, 30, 100),
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Color.fromARGB(255,40, 49, 73).withOpacity(0.7),
            border: Border.all(color: Colors.white.withOpacity(0.8),width: 3),
            borderRadius: BorderRadius.circular(20.0)
          ),
        child: Column(
          children: <Widget>[
            //SizedBox(height: 10,),
            Container(
              height: 200,
              child: Image(
                image: AssetImage("images/logo2.png"),
                fit: BoxFit.contain,
              ),
            ),
            //Expanded(child: Container(
               Text('Welcome',style: TextStyle(fontSize: 30.0,color: Colors.white),),
            //)),
            Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: new EdgeInsets.all(5.0),
                      child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          validator: (input) {
                            if(input!.isEmpty || !RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$').hasMatch(input)){
                              //  r'^[0-9]{10}$' pattern plain match number with length 10
                              return "Enter Valid Phone Number";
                            }
                          },
                          
                          decoration: InputDecoration(
                              labelText: 'Phone Number',
                              labelStyle: TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: Color.fromARGB(0,40, 49, 73),
                              
                              enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white, width: 2.0),
                              ),
                              prefixIcon: Icon(Icons.phone,
                              color: Colors.white,
                              )
                              ),
                          onSaved: (input) => _pno = input!),
                    ),
                    Container(
                      padding: new EdgeInsets.all(5.0),
                      child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          validator: (input) {
                            if(input!.isEmpty || !RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$').hasMatch(input)){
                              //  r'^[0-9]{10}$' pattern plain match number with length 10
                              return "Enter Correct Age";
                            }
                          },
                          
                          decoration: InputDecoration(
                              labelText: 'Age',
                              labelStyle: TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: Color.fromARGB(0,40, 49, 73),
                              
                              enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white, width: 2.0),
                              ),
                              prefixIcon: Icon(Icons.calendar_month_outlined,
                              color: Colors.white,
                              )
                              ),
                          onSaved: (input) => _ano = input!),
                    ),
                    SizedBox(height: 20),
                    RaisedButton(
                      padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                      onPressed: login,
                      child: Text('Proceed',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold)),
                      color: Color.fromARGB(255,0, 129, 138),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    
                  ],
                ),
              ),
            ),
            //SizedBox(height: 20,),
           
            
          ],
        ),
      ),
      ]
    )
        )
        )
    );
  }
}