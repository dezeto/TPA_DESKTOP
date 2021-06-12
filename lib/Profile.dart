import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void _create() async {
    try {
      await firestore.collection('users').doc('123').set({
        'email' : 'andrewtanjaya21@gmail.com',
        'id' : '123',
        'name' : 'andrew tan',
        'photoUrl' : 'abc'

      });
    } catch (e) {
      print(e);
    }
  }

  void _read() async {
    DocumentSnapshot documentSnapshot;
    try {
      documentSnapshot = await firestore.collection('users').doc('123').get();
      print(documentSnapshot.data()['email']);
      
    } catch (e) {
      print(e);
    }
  }

  void _update() async {
    try {
      firestore.collection('users').doc('123').update({
        'name' : 'bobi',
        
      });
    } catch (e) {
      print(e);
    }
  }

  void _delete() async {
    try {
      firestore.collection('users').doc('123').delete();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          RaisedButton(
            child: Text("Create"),
            onPressed: (){_create();},
          ),
          RaisedButton(
            child: Text("Read"),
            onPressed: (){_read();},
          ),
          RaisedButton(
            child: Text("Update"),
            onPressed: (){_update();},
          ),
          RaisedButton(
            child: Text("Delete"),
            onPressed: (){_delete();},
          ),
        ]),
      ),
    );
  }
}