import 'package:flutter/material.dart';

import 'items.dart';

class SustainableShop extends ChangeNotifier {
  // items list
  final List<Item> _shop = [
    // test items
    Item(name: "Apple", price: "300", imagePath: "lib/images/apple.png"),
    Item(name: "Google", price: "200", imagePath: "lib/images/google.png")
  ];
  // saved items
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