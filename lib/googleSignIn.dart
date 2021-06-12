// import 'dart:js';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// import 'MyHomePage.dart';

// class GoogleSignIn extends StatelessWidget {
//   final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
//   final GoogleSignIn googleSignIn = new GoogleSignIn();

//   Future<User> signin() async {
//     GoogleSignInAccount googleSignInAccount =
//         (await googleSignIn.signin()) as GoogleSignInAccount;
//     GoogleSignInAuthentication googleSignInAuthentication =
//         await googleSignInAccount.authentication;
//     final AuthCredential credential = GoogleAuthProvider.credential(
//       accessToken: googleSignInAuthentication.accessToken,
//       idToken: googleSignInAuthentication.idToken,
//     );
//     UserCredential userCredential =
//         await firebaseAuth.signInWithCredential(credential);
//     User user = userCredential.user;

//     Navigator.of(context).pushReplacement(new MaterialPageRoute(
//         builder: (BuildContext context) =>
//             new MyHomePage(user: user, googleSignIn: googleSignIn)));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
