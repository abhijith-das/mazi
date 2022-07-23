import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'SignUp.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String _email, _password;

  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        print(user);

        Navigator.pushReplacementNamed(context, "/");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentification();
  }

  login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);
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

  navigateToSignUp() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
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
                              prefixIcon: Icon(Icons.email,
                              color: Colors.white,
                              )
                              ),
                          onSaved: (input) => _email = input!),
                    ),
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
                            fillColor: Color.fromARGB(0,0,0,0),
                            enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                ),
                            prefixIcon: Icon(Icons.lock,
                            color: Colors.white,
                            ),
                          ),
                          obscureText: true,
                          onSaved: (input) => _password = input!),
                    ),
                    SizedBox(height: 20),
                    RaisedButton(
                      padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                      onPressed: login,
                      child: Text('LOGIN',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold)),
                      color: Color.fromARGB(255,0, 129, 138),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    )
                  ],
                ),
              ),
            ),
            //SizedBox(height: 20,),
            Container(
              padding: EdgeInsets.all(5),
              child: GestureDetector(
              
              child: Text('Create an Account?',
              style: TextStyle(color: Colors.white),),
              onTap: navigateToSignUp,
              
            ),),
            
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