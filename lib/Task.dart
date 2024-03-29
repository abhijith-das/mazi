import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

FirebaseFirestore dbu = FirebaseFirestore.instance;
FirebaseFirestore dba = FirebaseFirestore.instance;

class Userget {
  late String Name, Phoneno, Gid, Uid, age;
  late double lat, long;

  Userget(
      {required this.Uid,
      required this.Gid,
      required this.age,
      required this.Name,
      required this.Phoneno,
      required this.lat,
      required this.long});
  factory Userget.fromJson(Map<String, dynamic> json) {
    return Userget(
        Name: json['name'],
        Uid: json['uid'],
        Gid: json['gid'],
        age: json['age'],
        Phoneno: json['phno'],
        lat: json['lan'],
        long: json['long']);
  }

  void sendly(Userget element) {
    print(element.Gid +
        " " +
        element.Uid +
        " " +
        element.Name +
        " " +
        element.age.toString() +
        "");
  }

  double getlat(Userget element) {
    return element.lat;
  }

  String getgid(Userget element) {
    return element.Gid;
  }

  double getlong(Userget element) {
    return element.long;
  }

  String getname(Userget element) {
    return element.Name;
  }
}

class todoget {
  late String textt;
  todoget({required this.textt});
  factory todoget.fromJson(Map<String, dynamic> json) {
    return todoget(textt: json['task']);
  }

  String gettext(todoget element) {
    return element.textt;
  }
}

class TaskPage extends StatefulWidget {
  @override
  _Task createState() => _Task();
}

class _Task extends State<TaskPage> {
  final List<String> tasks = <String>['t1'];
  String str = '';
  String blank = '';
  TextEditingController? controller;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore dbu = FirebaseFirestore.instance;
  FirebaseFirestore dba = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<String?> openDialogue() => showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('ADD TASK'),
            content: TextField(
              autofocus: true,
              decoration: InputDecoration(hintText: 'Enter your task'),
              controller: controller,
            ),
            actions: [
              TextButton(child: Text('Cancel'), onPressed: cancel),
              TextButton(child: Text('Add Task'), onPressed: submit)
            ],
          ));

  Future<void> submit() async {
    Navigator.of(context).pop(controller?.text);
    //tasks.add(str);
    str = controller!.text;
    controller?.text = blank;
    //String gid = getgrpofuser();
    // String addr = "Group/" + gid + "/to_do";

    //print(str);
  }

  void cancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      //refresh ui
    });
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 5, 22, 31),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.indigo[900],
          onPressed: () async {
            final str = await openDialogue();
            if (str == null || str.isEmpty) return;
            tasks.add(str);
            addto(str);
            setState(() {
              //refresh ui
            });
            print("-----------------------------------------------------");
            print(tasks);
            print("-----------------------------------------------------");
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (_) => addnote(),
            //   ),
            print("hi");
          },
          child: Icon(
            Icons.add,
          ),
        ),
        appBar: AppBar(
          title: Text(
            'Todos',
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          backgroundColor: Colors.indigo[900],
        ),
        body: new ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return new Container(
                padding: EdgeInsets.all(20),
                child: Container(
                    //margin: EdgeInsets.fromLTRB(30, 100, 30, 100),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 40, 49, 73).withOpacity(0.7),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.8), width: 1),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Row(
                        //margin: EdgeInsets.fromLTRB(10,1,1,1),
                        children: <Widget>[
                          Expanded(
                              child: Container(
                            child: Row(children: <Widget>[
                              Icon(
                                Icons.arrow_circle_right,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                tasks[index],
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                              Container(
                                  alignment: Alignment.centerLeft,
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                        onPressed: () {
                                          deletetask(index);
                                          setState(() {});
                                        },
                                        icon: Icon(Icons.delete,
                                            color: Colors.white)),
                                  )),
                            ]),
                          )),
                        ])),
              );
            }));
  }

  void deletetask(int index) {
    User? firebaseUser;
    firebaseUser = _auth.currentUser;
    String id = firebaseUser!.uid;
    late var gid;
    print('---------------------------------------------');
    print(str);
    print('---------------------------------------------');
    print(id);

    final docRef = dba.collection("Users").doc(id);
    docRef.get().then((DocumentSnapshot doc) async {
      final data = doc.data() as Map<String, dynamic>;
      gid = data["gid"];

      print('---------------------------------------------');
      print(gid);

      String k = tasks[index];
       String addr = "/Groups/" + gid + "/SavedLocation";
       //var doc_ref = await FirebaseFirestore.instance.collection("board").where('text',isEqualTo: k).get();
//doc_ref.documents.forEach((result) {
  //print(result.documentID);
});



   // });
  }

  void addto(String str) async {
    User? firebaseUser;
    firebaseUser = _auth.currentUser;
    String id = firebaseUser!.uid;
    late var gid;
    print('---------------------------------------------');
    print(str);
    print('---------------------------------------------');
    print(id);

    final docRef = dba.collection("Users").doc(id);
    docRef.get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      gid = data["gid"];

      print('---------------------------------------------');
      print(gid);
      String taskid = getcode4();
      final addDoc = <String, dynamic>{"text": str};
      dbu
          .collection("Groups")
          .doc(gid)
          .collection("to_do")
          .doc(taskid)
          .set(addDoc);
    });
  }

  Future<void> clear() async {
    tasks.removeRange(0, tasks.length);
    User? firebaseUser;
    firebaseUser = _auth.currentUser;
    String id = firebaseUser!.uid;
    String gid = " ";
    final list = await FirebaseFirestore.instance
        .collection('Users')
        .where('uid', isEqualTo: id)
        .get();
    List<Userget> list1 =
        list.docs.map((d) => Userget.fromJson(d.data())).toList();
    list1.forEach((element) {
      gid = element.getgid(element);
    });
    String addr = "/Groups/" + gid + "/To_do";

    final list2 = await FirebaseFirestore.instance.collection(addr).get();
    List<todoget> list3 =
        list2.docs.map((d) => todoget.fromJson(d.data())).toList();
    list3.forEach((element) {
      tasks.add(element.gettext(element));
    });
  }
}

getcode4() {
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  return getRandomString(4);
}
