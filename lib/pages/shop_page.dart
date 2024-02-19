import 'package:barcode_scanner/components/item_tile.dart';
import 'package:barcode_scanner/models/shop.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/items.dart';
import 'add_to_cart_page.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  // add to saved items method
  void addToSaved(Item item) async {
    User? user = FirebaseAuth.instance.currentUser;
    String? userUid = user?.uid;

    if (userUid != null) {
      CollectionReference savedItemsCollection =
      FirebaseFirestore.instance.collection('users').doc(userUid).collection('saved items'); // Adjust the collection path

      // Check if the item already exists in the user's collection
      QuerySnapshot queryResult =
      await savedItemsCollection.where('itemName', isEqualTo: item.name).get();

      if (queryResult.docs.isNotEmpty) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Center(
                child: Text("This item is already saved."),
              ),
            );
          },
        );
      } else {
        // Convert the Item object to a map
        Map<String, dynamic> itemData = {
          'itemName': item.name,
          'price': item.price.toString(),
          'image': item.imagePath.toString(),
          // Add other properties as needed
        };

        // Add the item to the user's collection
        savedItemsCollection.add(itemData).then((value) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Center(
                  child: Text("Item saved."),
                ),
              );
            },
          );
        }).catchError((error) {
          print("Error adding item to Firestore: $error");
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Center(
                  child: Text("Error saving item."),
                ),
              );
            },
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SustainableShop>(
      builder: (context, value, child) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              const Text(
                "Welcome to EcoScan",
                style: TextStyle(fontSize: 20),
              ),

              const SizedBox(height: 25),

              // list of items
              Expanded(
                child: ListView.builder(
                  itemCount: value.sustainableShop.length,
                  itemBuilder: (context, index) {
                    Item eachItem = value.sustainableShop[index];
                    return ItemTile(
                      item: eachItem,
                      icon: Icon(Icons.arrow_forward),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddToCartPage(item: eachItem, addToSavedCallback: () => addToSaved(eachItem),)))
                          //() => addToSaved(eachItem),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}