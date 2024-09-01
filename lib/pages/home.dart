import 'package:flutter/material.dart';
import 'package:barcode_scanner/components/app_colors.dart';
import 'package:barcode_scanner/components/bottom_nav_bar.dart';
import 'package:barcode_scanner/pages/text_scanner.dart';
import 'package:barcode_scanner/pages/saved_page.dart';
import 'package:barcode_scanner/pages/shop_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  // Define icons for tabs
  final List<IconData> _icons = [
    Icons.shopping_cart,
    Icons.shopping_bag,
    Icons.camera_enhance_rounded,
  ];

  // Define labels for tabs
  final List<String> _labels = [
    'Shop',
    'Saved',
    'Scan',
  ];

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // pages
  final List<Widget> _pages = [
    ShopPage(),
    SavedPage(),
    ScanPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Text("EcoScan", style: TextStyle(color: Colors.grey[900]),),
        ),
        backgroundColor: AppColors.background,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: IconButton(
              onPressed: signUserOut,
              icon: Icon(Icons.logout_rounded),
              color: Colors.grey[900],
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.background,
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: MyBottomNavBar(
        onTabChange: navigateBottomBar,
        labels: _labels,
        numberOfTabs: _icons.length,
        icons: _icons, // Pass icons to the bottom navigation bar
      ),
    );
  }
}
