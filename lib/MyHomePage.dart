import 'package:app/main.dart';
import 'package:app/profile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'main.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({this.user, this.googleSignIn});
  final User user;
  final GoogleSignIn googleSignIn;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AlertDialog alertDialog;
  void signOut() {
    alertDialog = new AlertDialog(
      content: Container(
        height: 250.0,
        child: Column(
          children: <Widget>[
            ClipOval(
              child: new Image.network(widget.user.photoURL),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "Signout?",
                style: new TextStyle(fontSize: 15.0),
              ),
            ),
            new Divider(),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    widget.googleSignIn.signOut();
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => new MyLoginPage()));
                  },
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.check),
                      Padding(padding: const EdgeInsets.all(5.0)),
                      Text("Yes")
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.close),
                      Padding(padding: const EdgeInsets.all(5.0)),
                      Text("Cancel")
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );

    showDialog(context: context, builder: (_) => alertDialog);
    // showDialog(context: context,child : alertDialog);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: 170.0,
          width: double.infinity,
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: <Widget>[
                Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: new NetworkImage(widget.user.photoURL),
                          fit: BoxFit.cover)),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          "Welcome",
                          style: new TextStyle(
                              fontSize: 18.0, color: Colors.white),
                        ),
                        new Text(
                          widget.user.displayName,
                          style: new TextStyle(
                              fontSize: 18.0, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
                new IconButton(
                    icon: Icon(Icons.exit_to_app,
                        color: Colors.white, size: 30.0),
                    onPressed: () {
                      signOut();
                    }),
                RaisedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(new MaterialPageRoute(
                        builder: (BuildContext context) => new Profile()));
                  },
                  child: Text("Go to profile page"),
                )
              ],
            ),
          )),
    );
  }
}
