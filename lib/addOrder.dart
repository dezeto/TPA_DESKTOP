import 'package:app/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AddOrderPage extends StatefulWidget {
  // AddOrderPage({this.user, this.googleSignIn});
  // final User user;
  // final GoogleSignIn googleSignIn;
  @override
  _AddOrderPageState createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  final _formKey = GlobalKey<FormState>();
  User user;
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    user = auth.currentUser;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference preorders = firestore.collection('preorders');

    TextEditingController _preOrderNameController = TextEditingController();
    TextEditingController _restaurantNameController = TextEditingController();
    TextEditingController _foodNameController = TextEditingController();
    TextEditingController _quantityController = TextEditingController();
    TextEditingController _priceController = TextEditingController();
    TextEditingController _foodNotesController = TextEditingController();
    TextEditingController _maximumOfPeopleController = TextEditingController();

    addOrder() async {
      String preOrderName = _preOrderNameController.text;
      String restaurantName = _restaurantNameController.text;
      String foodName = _foodNameController.text;
      int quantity = int.parse(_quantityController.text);
      int price = int.parse(_priceController.text);
      String foodNotes = _foodNotesController.text;
      int maximumPeople = int.parse(_maximumOfPeopleController.text);

      preorders.add({
        'preOrderOwner': 'andrewtanjaya21@gmail.com',
        'preOrderName': preOrderName,
        'restaurantName': restaurantName,
        'foodName': foodName,
        'quantity': quantity,
        'price': price,
        'foodNotes': foodNotes,
        'maximumPeople': maximumPeople,
        'duration': DateTime.now()
      });

      _preOrderNameController.text = "";
      _restaurantNameController.text = "";
      _foodNameController.text = "";
      _quantityController.text = "";
      _priceController.text = "";
      _foodNotesController.text = "";
      _maximumOfPeopleController.text = "";

      print(
          'preOder : $preOrderName\nrestaurantName : $restaurantName foodName : $foodName\nQuantity : $quantity\nprice : $price\nfoodNotes : $foodNotes\nmaximumPeople : $maximumPeople');
    }

    return Scaffold(
        // appBar: AppBar(
        //   elevation: 0.0,
        //   backgroundColor: Colors.white,
        //   automaticallyImplyLeading: true,
        //   // leading: BackButton(
        //   //   color: Colors.black,
        //   //   onPressed: () => {Navigator.pop(context)},
        //   // ),
        // ),

        /*
      Preorder :
    - Nama preorder
    - Nama restorannya apa
    - Mau makanan apa
    - Mau berapa
    - Harga Per pcs
    - notes makanan
    - Maximal orang
      */
        body: Container(
      color: Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      alignment: AlignmentDirectional.centerStart,
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        'Add New Order',
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        controller: _preOrderNameController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0)),
                            prefixIcon: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Icon(Icons.title_rounded),
                            ),
                            labelText: 'Enter the title'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        controller: _restaurantNameController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0)),
                            prefixIcon: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Icon(Icons.place_rounded),
                            ),
                            labelText: 'Enter restaurant name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        controller: _foodNameController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0)),
                            prefixIcon: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Icon(Icons.fastfood_rounded),
                            ),
                            labelText: 'Enter food\'s name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0)),
                            prefixIcon: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Icon(Icons.format_list_numbered_rounded),
                            ),
                            labelText: 'Enter food quantity'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0)),
                            prefixIcon: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Icon(Icons.attach_money_rounded),
                            ),
                            labelText: 'Enter price'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        controller: _maximumOfPeopleController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0)),
                            prefixIcon: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Icon(Icons.people_alt_rounded),
                            ),
                            labelText: 'Enter maximum people'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        controller: _foodNotesController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0)),
                            prefixIcon: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Icon(Icons.note_rounded),
                            ),
                            labelText: 'Enter food\'s notes'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: ElevatedButton(
                        onPressed: () => addOrder(),
                        child: Text(
                          'Add Order',
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0)),
                        ),
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    ));
  }
}
