import 'package:app/addOrder.dart';
import 'package:app/constant.dart';
import 'package:app/item_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'HomePage.dart';
import 'UserPage.dart';

class MainPage extends StatefulWidget {
  MainPage({this.user, this.googleSignIn});
  final User user;
  final GoogleSignIn googleSignIn;
  @override
  _MainPageState createState() => _MainPageState(
        user: user,
        googleSignIn: googleSignIn,
      );
}

class _MainPageState extends State<MainPage> {
  User user;
  GoogleSignIn googleSignIn;
  _MainPageState({this.user, this.googleSignIn});

  int _selectedIndex = 0;

  PageController _pageController = PageController();
  List<Widget> _screens = [HomePage(), AddOrderPage(), UserPage()];

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      drawer: Drawer(
        child: ListView(
          children: [],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_rounded), label: 'User')
        ],
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      appBar: AppBar(
        title: Text(
          'KioLah',
          style: TextStyle(color: Colors.black),
        ),
        automaticallyImplyLeading: true,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [],
      ),
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: _onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }
}
