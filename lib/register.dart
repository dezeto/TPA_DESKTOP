import 'package:app/redirectTextForm.dart';
import 'package:app/register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'MainPage.dart';
import 'MyHomePage.dart';
import 'constant.dart';
import 'login.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    TextEditingController _usernameController = TextEditingController();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _confirmPasswordController = TextEditingController();

    String _errText = '';

    Future<bool> usernameCheck(String username) async {
      final result = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: username)
          .get();
      return result.docs.isEmpty;
    }

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

    bool validateRegister() {
      String _username = _usernameController.text;
      String _password = _passwordController.text;
      String _email = _emailController.text;
      String _confirmPassword = _confirmPasswordController.text;
      bool _valid = true;
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference users = firestore.collection('users');

      setState(() async {
        _errText = '';
        if (_username.isEmpty) {
          print('Username must not be empty');
          _errText = 'Username must not be empty';
          _valid = false;
        }

        if (passwordStructure(_password)) {
          print('password aman');
          _errText = 'Password still not valid';
          _valid = false;
        } else {
          print('password masih ada yang salah');
        }

        if (_password != _confirmPassword) {
          print('confirm password and password must match');
          _valid = false;
        }

        if (_email.isEmpty) {
          print('email must be filled');
          _valid = false;
        }

        if (_valid) {
          // ADD NEW USER
          bool unique = await usernameCheck(_username);
          if (!unique) {
            // username already exist
            _errText = 'Username already exist, please log in';
            _valid = false;
          } else {
            users.add({
              'email': _email,
              'name': _username,
              'password': _password,
              'photoUrl':
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQNL_ZnOTpXSvhf1UaK7beHey2BX42U6solRA&usqp=CAU'
            });

            Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          }
        }
        // _passwordError = passwordError;
      });

      print('username : $_username\n password : $_password');
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Container(
                  alignment: AlignmentDirectional.centerStart,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Register',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
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
                // mail
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0)),
                        prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Icon(Icons.mail_rounded),
                        ),
                        labelText: 'Enter your email'),
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
                // Confirm Password
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                      controller: _confirmPasswordController,
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
                        labelText: 'Confirm your password',
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
                // Register button
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  child: ElevatedButton(
                    onPressed: () => validateRegister(),
                    child: Text('Register'),
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
                    Text('Already have an account ?'),
                    TextButton(
                      onPressed: () => {
                        Navigator.pop(context),
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage())),
                      },
                      child: Text('Login'),
                      style: TextButton.styleFrom(onSurface: primaryLightColor),
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
                    label: Text('Sign up with Google'),
                    style: TextButton.styleFrom(primary: Colors.blue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
