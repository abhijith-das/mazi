// ignore_for_file: avoid_print, non_constant_identifier_names, prefer_interpolation_to_compose_strings


//import 'dart:js';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Userget {
  late String Name,Phoneno,Gid,Uid;
  late int age;
  late double lat,long;

  Userget({required this.Uid,required this.Gid,required this.age,required this.Name,required this.Phoneno,required this.lat,required this.long });
  factory Userget.fromJson(Map<String, dynamic> json) {
    return Userget(
       Name: json['name'],
       Uid: json['uid'],
       Gid: json['gid'],
       age: json['age'],
       Phoneno: json['phno'],
       lat: json['lat'],
       long: json['long']
    );
}

  void sendly(Userget element) {
    print(element.Gid+" "+element.Uid+" "+element.Name+" "+ element.age.toString() +"");
  }
  
  double getlat(Userget element) {return element.lat;}
  
  String getgid(Userget element) {return element.Gid;}
  
  double getlong(Userget element) {return element.long;}
  
  String getname(Userget element) {return element.Name;}}

class Locget {
  late String Place;
  late double lat,long;

  Locget({required this.Place,required this.lat,required this.long });
  factory Locget.fromJson(Map<String, dynamic> json) {
    return Locget(
       Place: json['place'],
       lat: json['lan'],
       long: json['lon']
    );
} 
  double getlat(Locget element) {return element.lat;}
  double getlong(Locget element) {return element.long;}
  String getplace(Locget element) {return element.Place;}
}

// import 'package:authentification/Start.dart';
void main() async{
   await Firebase.initializeApp();
   runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Voice',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SpeechScreen(),
    );
  }
}

class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  
  late stt.SpeechToText _speech;
  bool _isListening = false;
 // String uid="uoo1";
  String _text = 'Press the button and start speaking';
  String Acc=" empty";
  CollectionReference _todo =
      FirebaseFirestore.instance.collection('/todo');
      CollectionReference _test =
      FirebaseFirestore.instance.collection('/Users');
  //final _userloc =
     // FirebaseFirestore.instance.collection('Users').get;
      //document will ne created with id u001
  //CollectionReference _savedloc =
     // FirebaseFirestore.instance.collection('/Groups/gp1/SavedLocation');*/
  FirebaseFirestore dbu = FirebaseFirestore.instance;
  FirebaseFirestore dba = FirebaseFirestore.instance;
   late int ucount;
  var id='';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voice checking'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        
        child:Container(
          alignment: Alignment.center,
          child: FloatingActionButton(
          
          onPressed: disperser,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
        ),
      ),
    );
  }
  
  void sos(){

  }

  Future<void> calc(String gid, double lat, double long,String name) async {
    String addr="Groups/"+gid+"/SavedLocation";

    final list2= await FirebaseFirestore.instance.collection(addr).where('lan',isEqualTo: lat).get();
    List<Locget> list3 = list2.docs.map((d) => Locget.fromJson(d.data())).toList();
    list3.forEach((element) { 
      double lat1=element.getlat(element);
      double long1=element.getlong(element);
      String place=element.getplace(element);
      if(lat1==lat&&long1==long)
      {
        print(name +"@"+ place);
      }

    });
  }
Future<void> where()
async {
    final list= await FirebaseFirestore.instance.collection('Users').where('name', isEqualTo: 'duru').get();
    print(list);
  List<Userget> list1 = list.docs.map((d) => Userget.fromJson(d.data())).toList();
   list1.forEach((element) { 
    element.sendly(element);
    double lat=element.getlat(element);
    double long=element.getlong(element);
    String gid=element.getgid(element);
    String name=element.getname(element);
    calc(gid,lat,long,name);

   });
}

Future<void> Add()
async {
  String item=_text.substring(_text.indexOf("add")+3);
  await _todo.add({"Text": item, "Assign": "all","done":false});
}

Future<void> done()
async {
  String item=_text.substring(_text.indexOf("done")+3);
  QuerySnapshot todo = await _todo.get();
    final todoData = todo.docs.map((doc) => doc.data()).toList();
  await  _todo.doc('hlkU8hSickaJ8BmDaBXs').delete();

  
}
void disperser()
{
   _listen();
   print(_text);
   if(_text.contains(RegExp("Where", caseSensitive: false)))
   {
      Acc="Where condition";
      where();
  }
  else if(_text.contains(RegExp("Help", caseSensitive: false)))
   {
      Acc="Help condition";
     // Sos();

  } 
  else if(_text.contains(RegExp("Add", caseSensitive: false)))
   {
      Acc="Add to do condition";
      Add();

  } 
  else if(_text.contains(RegExp("Done", caseSensitive: false)))
   {
      Acc="done condition";
      done();
  } 
  print(Acc);
}

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        //onStatus: (val) => print('onStatus: $val'),
        //onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
    _text="where is duru";
  }
  

}