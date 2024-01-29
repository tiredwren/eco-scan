import 'package:barcode_scanner/components/item_tile.dart';
import 'package:barcode_scanner/models/shop.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/items.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {

  // add to saved items method
  Future<void> addToSaved(Item item) async {
    CollectionReference savedItemsCollection = FirebaseFirestore.instance.collection('saved items');

    // check if the item already exists in firestore
    QuerySnapshot queryResult = await savedItemsCollection.where('itemName', isEqualTo: item.name).get();
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
      setState(() {
        Provider.of<SustainableShop>(context, listen: false).addSavedItem(item);

        // Convert the Item object to a map
        Map<String, dynamic> itemData = {
          'itemName': item.name,
          'price': item.price.toString(),
          'image': item.imagePath.toString(),
          // Add other properties as needed
        };

        // Get a reference to the 'saved items' collection
        CollectionReference savedItemsCollection = FirebaseFirestore.instance.collection('saved items');

        // Add the item to the collection
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
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<SustainableShop>(builder: (context,value,child) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            const Text("Welcome to EcoScan",
              style: TextStyle(fontSize: 20),
            ),

            const SizedBox(height: 25),

            // list of items
            Expanded(child: ListView.builder(
                    itemCount: value.sustainableShop.length,
                    itemBuilder: (context, index) {

                  Item eachItem = value.sustainableShop[index];

                  return ItemTile(
                      item: eachItem,
                      icon: Icon(Icons.add),
                      onPressed: () => addToSaved(eachItem)
                  );
                    }),

              )],
        ),
      ),
    ),
    );
  }
}
