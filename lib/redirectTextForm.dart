// import 'package:app/login.dart';
// import 'package:app/register.dart';
// import 'package:app/register.dart';

// import 'package:flutter/material.dart';

// import 'constant.dart';
// import 'login.dart';

// class RedirectTextForm extends StatelessWidget {
//   final String upperText;
//   final String functionText;
//   final BuildContext context;
//   RedirectTextForm(
//       {@required this.upperText,
//       @required this.functionText,
//       @required this.context});

//   redirectToLogin() {
//     print('to login page');
//     // Navigator.pop(context);
//     Navigator.of(context).pop();

//     Navigator.push(
//         context, MaterialPageRoute(builder: (context) => LoginPage()));
//   }

//   // redirectToRegister() {
//   //   print('to register page');
//   //   // Navigator.pop(context);
//   //   Navigator.of(context).pop();

//   //   Navigator.push(
//   //       context, MaterialPageRoute(builder: (context) => RegisterPage()));
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Text(this.upperText),
//         TextButton(
//           onPressed: (functionText.compareTo('Login') == 0
//               ? redirectToLogin()
//               : redirectToRegister()),
//           child: Text(this.functionText),
//           style: TextButton.styleFrom(onSurface: primaryLightColor),
//         )
//       ],
//     );
//   }
// }
