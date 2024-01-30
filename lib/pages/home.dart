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
  HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

//shift to home page/shop once home page/shop is made:
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

  // for nav bar
  int _selectedIndex = 0;

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // pages
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
    List<List<dynamic>> barcodesTable =
    CsvToListConverter().convert(barcodeData);
    print(barcodesTable);
    for (List<dynamic> row in barcodesTable) {
      print("Row: $row");
      print("Comparing ${row[0]} with $barcode");
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
          Expanded( // Use Expanded to allow the bottom navigation to take remaining space
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
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scanBarcode,
        tooltip: 'Scan',
        child: Icon(Icons.camera_alt),
      ),
      backgroundColor: backgroundColor,
      bottomNavigationBar: MyBottomNavBar(
        onTabChange: (index) => navigateBottomBar(index),
      ),
    );
  }
}