import 'package:barcode_scanner/components/bottom_nav_bar.dart';
import 'package:barcode_scanner/pages/auth_page.dart';
import 'package:barcode_scanner/pages/saved_page.dart';
import 'package:barcode_scanner/pages/shop_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:csv/csv.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:firebase_auth/firebase_auth.dart';

import '../const.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

void signUserOut(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => AuthPage()),
  );
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  String itemName = "Scan a barcode";
  bool searching = false;
  int _selectedIndex = 0;

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [ShopPage(), SavedPage()];

  Future<void> _scanBarcode() async {
    String barcode = await FlutterBarcodeScanner.scanBarcode(
      "#004080",
      "Cancel",
      true,
      ScanMode.BARCODE,
    );

    print("Scanned Barcode: $barcode");

    if (barcode == '-1') {
      setState(() {
        itemName = "Scan cancelled";
      });
    } else {
      try {
        setState(() {
          searching = true;
        });

        String item = await getItemName(barcode);

        setState(() {
          itemName = item;
        });
      } catch (e) {
        setState(() {
          itemName = "Unknown error: $e";
        });
      } finally {
        setState(() {
          searching = false;
        });
      }
    }
  }

  Future<String> getItemName(String barcode) async {
    String barcodeData = await loadAsset('assets/barcodes.csv');
    List<List<dynamic>> barcodesTable = CsvToListConverter().convert(barcodeData);

    for (List<dynamic> row in barcodesTable) {
      if (row[0].toString().trim() == barcode.trim()) {
        return row[5].toString();
      }
    }

    return "item not found";
  }

  Future<String> loadAsset(String path) async {
    return await rootBundle.loadString(path);
  }

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
              onPressed: () => signUserOut(context),
              icon: Icon(Icons.logout_rounded),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _pages[_selectedIndex],
          ),
          searching
              ? Container(
            width: 200,
            height: 8,
            child: LinearProgressIndicator(
              value: null,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              backgroundColor: Colors.grey,
            ),
          )
              : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              itemName,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        Center(
        child: OutlinedButton(
          onPressed: _scanBarcode,
          style: OutlinedButton.styleFrom(
            alignment: Alignment.center,
            padding: EdgeInsets.all(10.0),
            side: BorderSide(color: Colors.pink[100]!),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Container(
            alignment: Alignment(0,0.75),
            padding: EdgeInsets.all(16.0),
            child: Icon(
              Icons.camera_alt_outlined,
              color: Colors.pink[100],
            ),
          ),
        ),
      ),
    ],
      ),
      backgroundColor: backgroundColor,
      bottomNavigationBar: MyBottomNavBar(
        onTabChange: (index) => navigateBottomBar(index),
      ),
    );
  }
}