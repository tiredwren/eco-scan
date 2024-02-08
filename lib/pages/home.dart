import 'package:barcode_scanner/components/bottom_nav_bar.dart';
import 'package:barcode_scanner/pages/textScanner.dart';
import 'package:barcode_scanner/pages/saved_page.dart';
import 'package:barcode_scanner/pages/shop_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../const.dart';


class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

void signUserOut() {
  FirebaseAuth.instance.signOut();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {

  final user = FirebaseAuth.instance.currentUser!;

  // for nav bar
  int _selectedIndex = 0;

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // pages
  final List<Widget> _pages = [
    ShopPage(),
    SavedPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Text("EcoScan"),
        ),
        backgroundColor: Colors.grey[900],
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: IconButton(
              onPressed: signUserOut,
              icon: Icon(Icons.logout_rounded),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainScreen()),
              );
            },
            child: Text('Press Me Above NavBar'),
          ),

          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
      bottomNavigationBar: MyBottomNavBar(
        onTabChange: (index) => navigateBottomBar(index),
      ),
    );
  }
}