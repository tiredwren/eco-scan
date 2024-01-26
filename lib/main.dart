import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:csv/csv.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BarcodeScanner(),
    );
  }
}

class BarcodeScanner extends StatefulWidget {
  @override
  _BarcodeScannerState createState() => _BarcodeScannerState();
}

class _BarcodeScannerState extends State<BarcodeScanner> {
  String itemName = "Scan a barcode";
  bool searching = false;

  Future<void> _scanBarcode() async {
    String barcode = await FlutterBarcodeScanner.scanBarcode(
      "#004080",
      "Cancel",
      true,
      ScanMode.BARCODE,
    );

    if (barcode == '-1') {
      // Handle scan cancellation
      setState(() {
        itemName = "Scan cancelled";
      });
    } else {
      try {
        setState(() {
          searching = true; // Set searching to true while searching
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
          searching = false; // Set searching to false after search is complete
        });
      }
    }
  }

  Future<String> getItemName(String barcode) async {
    String csvData = await loadAsset('assets/barcodes.csv');
    List<List<dynamic>> csvTable = CsvToListConverter().convert(csvData);

    for (List<dynamic> row in csvTable) {
      if (row.contains(barcode)) {
        return row[0].toString();
      }
    }

    return "Item not found";
  }

  Future<String> loadAsset(String path) async {
    return await rootBundle.loadString(path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Barcode Scanner"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Item Name:",
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 10.0),
            searching
                ? CircularProgressIndicator()
                : Text(
              itemName,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scanBarcode,
        tooltip: 'Scan',
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}
