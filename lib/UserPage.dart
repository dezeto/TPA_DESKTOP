import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'constant.dart';

class UserPage extends StatefulWidget {
  // UserPage({Key? key}) : super(key: key);
  @override
  UserPageState createState() => UserPageState();
}

class UserPageState extends State<UserPage> with AutomaticKeepAliveClientMixin {
  User user;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String initialCountry = 'NG';
  PhoneNumber number = PhoneNumber(isoCode: 'NG');
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  File imageFile;

  /// Get from gallery
  _getFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
    }
  }

  var paymentInfo = [
    {
      'name': 'OVO',
      'logo': 'assets/icons/ovo.png',
      'prefix': '',
      'isChecked': false,
    },
    {
      'name': 'BCA',
      'logo': 'assets/icons/bca.png',
      'prefix': '',
      'isChecked': false,
    },
    {
      'name': 'GOPAY',
      'logo': 'assets/icons/gopay.png',
      'prefix': '',
      'isChecked': false,
    },
  ];

  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
        await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'US');

    setState(() {
      this.number = number;
    });
  }

  TextEditingController _nameController = TextEditingController();
  bool isChecked = false;
  String name = '';

  final TextEditingController controller = TextEditingController();

  getPaymentType() {
    var list = [];
    for (var pay in paymentInfo) {
      print('name : ${pay['name']}, isChecked : ${pay['isChecked']}');
      if (pay['isChecked'] == true) {
        print(pay.toString());
        list.add(pay);
      }
    }
    return list;
  }

  updateProfile() {
    // name : username
    // number : phoneNumber
    // paymentType : List<Object>
    var list = getPaymentType();
    for (var item in list) {
      print(item.toString());
    }
    // imageFile : profilePic
    // print(
    //     'name : ${this.name}, isoCode : ${number.isoCode}, number : ${number.phoneNumber}');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    user = auth.currentUser;
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                // name
                // Container(
                //   alignment: AlignmentDirectional.centerStart,
                //   padding: EdgeInsets.symmetric(vertical: 16.0),
                //   child: Text(
                //     'Update Profile ',
                //     style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                //     textAlign: TextAlign.left,
                //   ),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      child: Container(
                        child: Image.asset(user.photoURL, fit: BoxFit.fitWidth),
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: new NetworkImage(user.photoURL),
                                fit: BoxFit.cover)),
                      ),
                      onPressed: () => _getFromGallery(),
                      style: TextButton.styleFrom(
                        primary: primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(100)),
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: AlignmentDirectional.centerStart,
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Username',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0)),
                        prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Icon(Icons.title_rounded),
                        ),
                        labelText: 'Your New Username'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onSaved: (value) => setState(() => name = value),
                  ),
                ),
                Container(
                  alignment: AlignmentDirectional.centerStart,
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Phone Number',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                ),
                InternationalPhoneNumberInput(
                  onInputChanged: (PhoneNumber number) {
                    print(number.phoneNumber);
                  },
                  onInputValidated: (bool value) {
                    print(value);
                  },
                  selectorConfig: SelectorConfig(
                    selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                  ),
                  ignoreBlank: false,
                  autoValidateMode: AutovalidateMode.disabled,
                  selectorTextStyle: TextStyle(color: Colors.black),
                  initialValue: number,
                  textFieldController: controller,
                  formatInput: false,
                  keyboardType: TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                  inputBorder: OutlineInputBorder(),
                  onSaved: (PhoneNumber number) {
                    print('On Saved: $number');
                    this.number = number;
                  },
                ),
                // payment options
                Container(
                  alignment: AlignmentDirectional.centerStart,
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Payment Options',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (var pay in paymentInfo)
                      Container(
                        alignment: Alignment.center,
                        child: OutlinedButton(
                          onPressed: () {
                            pay['isChecked'] == true
                                ? pay['isChecked'] = false
                                : pay['isChecked'] = true;
                            // print(
                            //     'name : ${pay['name']}, isChecked : ${pay['isChecked']}');
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: Image.asset(
                              '${pay['logo']}',
                              fit: BoxFit.fitWidth,
                              width: 50,
                              height: 30,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                width: 1.0,
                                color: pay['isChecked'] == true
                                    ? Colors.blue
                                    : Colors.grey,
                                style: BorderStyle.solid,
                              ),
                              primary: Colors.grey),
                        ),
                      ),
                  ],
                ),
                //qr code
                // ovo / bca
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 12.0),
                  padding: EdgeInsets.symmetric(horizontal: 64),
                  child: ElevatedButton(
                    onPressed: () {
                      final isValid = formKey.currentState.validate();
                      FocusScope.of(context).unfocus();
                      if (isValid) {
                        formKey.currentState.save();
                        updateProfile();
                        // print('number : ' + this.number.toString());
                        // getPaymentType();
                      }
                    },
                    child: Text(
                      'Update User',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
