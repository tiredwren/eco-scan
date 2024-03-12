import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import '../pages/add_to_cart_page.dart';
import 'items.dart';
import 'package:flutter/services.dart' show rootBundle;

class SustainableShop extends ChangeNotifier {
  // items list
  // final List<Item> _shop = [
  //   // test items
  //   Item(name: "Apple", price: "300", imagePath: "lib/images/apple.png"),
  //   Item(name: "Google", price: "200", imagePath: "lib/images/google.png"),
  //   Item(name: "Apple", price: "300", imagePath: "lib/images/apple.png"),
  //   Item(name: "Google", price: "200", imagePath: "lib/images/google.png"),
  //   Item(name: "Apple", price: "300", imagePath: "lib/images/apple.png"),
  //   Item(name: "Google", price: "200", imagePath: "lib/images/google.png"),
  //   Item(name: "Apple", price: "300", imagePath: "lib/images/apple.png"),
  //   Item(name: "Google", price: "200", imagePath: "lib/images/google.png"),
  //   Item(name: "Apple", price: "300", imagePath: "lib/images/apple.png"),
  //   Item(name: "Google", price: "200", imagePath: "lib/images/google.png"),
  //   Item(name: "Apple", price: "300", imagePath: "lib/images/apple.png"),
  //   Item(name: "Google", price: "200", imagePath: "lib/images/google.png"),
  //   Item(name: "Apple", price: "300", imagePath: "lib/images/apple.png"),
  //   Item(name: "Google", price: "200", imagePath: "lib/images/google.png")
  // ];

  // final List<Item> _shop = [
  //   // test items
  //   Item(name: "Apple", ean: "300"),
  //   Item(name: "Apple", ean: "300"),
  //   Item(name: "Apple", ean: "300"),
  //   Item(name: "Apple", ean: "300"),
  //   Item(name: "Apple", ean: "300"),
  //   Item(name: "Apple", ean: "300"),
  //   Item(name: "Apple", ean: "300"),
  //   Item(name: "Apple", ean: "300"),
  //   Item(name: "Apple", ean: "300"),
  //   Item(name: "Apple", ean: "300"),
  //   Item(name: "Apple", ean: "300"),
  //   Item(name: "Apple", ean: "300"),
    
  // ];

  final List<Item> _shop = [];

  Future<void> loadCSV() async {
    try {
      final String csvData = await rootBundle.loadString("assets/items.csv");
      final List<List<dynamic>> csvList = CsvToListConverter().convert(csvData);
      
      for (var i = 0; i < csvList.length; i++) {
        final String ean = csvList[i][0].toString(); // assuming EAN is a String
        final String name = csvList[i][1].toString(); // assuming Name is a String
        final Item item = Item(ean: ean, name: name);
        _shop.add(item);
        print(_shop);
      }

      notifyListeners();
    } catch (e) {
      print("Error loading CSV: $e");
    }
  }

  List<Item> _savedItems = [];

  // get item list
  List<Item> get sustainableShop => _shop;

  // get user's saved items
  List<Item> get savedItems => _savedItems;

  // add saved item
  void addSavedItem(Item item) {
    _savedItems.add(item);
    notifyListeners();
  }

    // remove saved item
    void removeSavedItem(Item item) {
      _savedItems.remove(item);
      notifyListeners();
    }
}


