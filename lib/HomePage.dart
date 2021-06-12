import 'package:app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constant.dart';
import 'item_card.dart';

class HomePage extends StatefulWidget {
  // final User user;
  // final GoogleSignIn googleSignIn;
  // HomePage({this.user, this.googleSignIn});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    AlertDialog alertDialog;
    User user;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = new GoogleSignIn();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference preOrders = firestore.collection('preorders');
    CollectionReference users = firestore.collection('users');

    user = auth.currentUser;
    readData() {
      preOrders.get();
    }

    void signOut() {
      alertDialog = new AlertDialog(
        title: Text('Sign out'),
        content: Text('Are you sure to Sign Out ?'),
        actions: [
          TextButton(
              onPressed: () =>
                  (Navigator.of(context, rootNavigator: true).pop()),
              child: Text('No')),
          TextButton(
            onPressed: () async {
              googleSignIn.signOut();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('email');

              Navigator.of(context, rootNavigator: true).pop();
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new MyLoginPage()));
            },
            child: Text('Yes'),
          ),
        ],
        elevation: 24.0,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      );
      showDialog(context: context, builder: (_) => alertDialog);
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
            bottom: 32.0, left: 32.0, right: 32.0, top: 16.0),
        child: Container(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Container(
                          child: Text('Welcome back,',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 24)),
                        ),
                      ),
                      Container(
                        child: Text(user.displayName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 20)),
                      ),
                    ],
                  ),
                  TextButton(
                    child: Container(
                      child: Image.asset(user.photoURL, fit: BoxFit.fitWidth),
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: new NetworkImage(user.photoURL),
                              fit: BoxFit.cover)),
                    ),
                    onPressed: () => signOut(),
                    style: TextButton.styleFrom(
                      primary: primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(100)),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          child: Text(
                            'Ongoing Order',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                        ),
                      ],
                    ),
                    // GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), itemBuilder: (context, position){
                    //   return Card(
                    //     child: Text('test'),
                    //   )
                    // })
                    // READ DATA PREORDER
                    StreamBuilder<QuerySnapshot>(
                        stream: preOrders
                            .where('preOrderOwner',
                                isEqualTo: 'andrewtanjaya21@gmail.com')
                            .snapshots(),
                        builder: (_, snapshot) {
                          if (snapshot.hasData) {
                            return Container(
                              child: Column(
                                children: snapshot.data.docs
                                    .map((preorder) => ItemCard(
                                          preorder.data()['preOrderName'],
                                          preorder.data()['price'],
                                          preorder.data()['restaurantName'],
                                          preorder.data()['maximumPeople'],
                                          onUpdate: () {
                                            // UPDATE PREORDER
                                            preOrders.doc(preorder.id).update({
                                              'quantity':
                                                  preorder.data()['quantity'] +
                                                      1
                                            });
                                          },
                                          onDelete: () {
                                            // DELETE PREORDER
                                            preOrders.doc(preorder.id).delete();
                                          },
                                        ))
                                    .toList(),
                              ),
                            );
                          } else {
                            return Text('Loading');
                          }
                        })
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
