import 'package:app/constant.dart';
import 'package:flutter/material.dart';

import 'constant.dart';
import 'login.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(
            left: 24.0, right: 24.0, top: 32.0, bottom: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 400,
              // decoration: BoxDecoration(
              //     border: Border.all(color: Colors.grey, width: 2),
              //     borderRadius: BorderRadius.circular(10.0)),
              child: Center(
                child: Image.asset('assets/images/donuts.jpg'),
                // child: Text('Image here'),
              ),
            ),
            // padding: const EdgeInsets.only(top: 16.0, bottom: 24.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage())),
                  },
                  child: Text('Get Started'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    primary: primaryColor,
                    onPrimary: primaryLightColor,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(16.0),
                    ),
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     Text('Don\'t have an account yet ? '),
                //     TextButton(
                //       onPressed: null,
                //       child: Text('Register'),
                //       style: TextButton.styleFrom(onSurface: primaryLightColor),
                //     )
                //   ],
                // )
              ],
            )
          ],
        ),
      ),
    );
  }
}
