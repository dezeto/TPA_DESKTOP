import 'package:app/register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'MainPage.dart';
import 'constant.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');
    TextEditingController _usernameController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    String _errText = '';

    bool passwordStructure(String value) {
      /*
        Minimum 1 Upper case
        Minimum 1 lowercase
        Minimum 1 Numeric Number
        Minimum 1 Special Character
        Common Allow Character ( ! @ # $ & * ~ )
      */
      String pattern =
          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
      RegExp regExp = new RegExp(pattern);
      return regExp.hasMatch(value);
    }

    Future<bool> checkCreds(String username, String password) async {
      final result = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: username)
          .where('password', isEqualTo: password)
          .get();
      return result.docs.isEmpty;
    }

    bool validateLogin() {
      String _username = _usernameController.text;
      String _password = _passwordController.text;
      bool _valid = true;

      setState(() async {
        _errText = '';
        if (_username.isEmpty) {
          print('Username must not be empty');
          _errText = 'Username must not be empty';
          _valid = false;
        }

        // if (passwordStructure(_password)) {
        //   print('password aman');
        //   _errText = 'Password still not valid';
        //   _valid = false;
        // } else {
        //   print('password masih ada yang salah');
        // }

        if (_valid) {
          // CHECK USER CREDS TO DB
          bool creds = await checkCreds(_username, _password);
          if (!creds) {
            // username creds true
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('email', _username);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MainPage()));
          } else {
            _errText = 'Wrong Credentials';
            _valid = false;
          }
        }
        // _passwordError = passwordError;
      });

      print('username : $_username\n password : $_password');
    }

    Future<bool> usernameCheck(String username) async {
      final result = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: username)
          .get();
      return result.docs.isEmpty;
    }

    Future<User> signin() async {
      GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);
      User user = userCredential.user;

      bool unique = await usernameCheck(user.email);
      if (!unique) {
        // username already exist

      } else {
        users.add({
          'uid': user.uid,
          'email': user.email,
          'photoUrl': user.photoURL,
        });
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // print("duarrr");
      prefs.setString('email', user.email);

      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (BuildContext context) =>
              new MainPage(user: user, googleSignIn: googleSignIn)));
    }

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: BackButton(
          color: Colors.black,
          onPressed: () => {Navigator.pop(context)},
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        child: Container(
          // constraints: BoxConstraints(
          //   maxHeight: MediaQuery.of(context).size.height,
          // ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    alignment: AlignmentDirectional.centerStart,
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'Login',
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  // username
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0)),
                          prefixIcon: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Icon(Icons.account_circle),
                          ),
                          labelText: 'Enter your username'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                  // password
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                        controller: _passwordController,
                        enableSuggestions: false,
                        autocorrect: false,
                        obscureText: _isObscure,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Enter your password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0)),
                          prefixIcon: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Icon(Icons.lock_rounded),
                          ),
                          // suffixIcon: Padding(
                          //   padding: const EdgeInsets.symmetric(vertical: 8.0),
                          //   child: IconButton(
                          //       icon: Icon(_isObscure
                          //           ? Icons.visibility
                          //           : Icons.visibility_off),
                          //       onPressed: () =>
                          //           setState(() => _isObscure = !_isObscure)),
                          // )
                        )),
                  ),
                  // ErrorText
                  Container(
                    child: Text(
                      _errText,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  // login button
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 32.0),
                    child: ElevatedButton(
                      onPressed: () => validateLogin(),
                      child: Text('Login'),
                      style: ElevatedButton.styleFrom(
                        primary: primaryColor,
                        onPrimary: Colors.black,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(16.0),
                        ),
                      ),
                    ),
                  ),
                  // RedirectTextForm(
                  //   upperText: 'Don\'t have an account yet ?',
                  //   functionText: 'Register',
                  //   context: context,
                  // )
                  // to Register page
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Don\'t have an account yet ?'),
                      TextButton(
                        onPressed: () => {
                          Navigator.pop(context),
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterPage())),
                        },
                        child: Text('Register'),
                        style:
                            TextButton.styleFrom(onSurface: primaryLightColor),
                      )
                    ],
                  ),
                ],
              ),
              // GOOGLE
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Row(children: <Widget>[
                      Expanded(
                        child: new Container(
                            margin:
                                const EdgeInsets.only(left: 10.0, right: 20.0),
                            child: Divider(
                              color: Colors.black,
                              height: 36,
                            )),
                      ),
                      Text("or"),
                      Expanded(
                        child: new Container(
                            margin:
                                const EdgeInsets.only(left: 20.0, right: 10.0),
                            child: Divider(
                              color: Colors.black,
                              height: 36,
                            )),
                      ),
                    ]),
                  ),
                  Container(
                    alignment: AlignmentDirectional.bottomCenter,
                    child: TextButton.icon(
                      onPressed: () => signin(),
                      icon: Image.asset(
                        "assets/icons/google.png",
                        height: 30,
                        width: 30,
                        // color: Colors.red,
                        // colorBlendMode: BlendMode.darken,
                        fit: BoxFit.fitWidth,
                      ),
                      label: Text(
                        'Sign in with Google',
                      ),
                      style: TextButton.styleFrom(primary: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
