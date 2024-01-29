import 'package:barcode_scanner/components/item_tile.dart';
import 'package:barcode_scanner/models/shop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/items.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});


  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {

  bool itemSelected = false;

  // add to saved items method
  void addToSaved(Item item) {
    if (itemSelected) {
      showDialog(context: context, builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text("This item is already saved."),
          ),
        );
      }
      );
    } else {
      setState(() {
        itemSelected = !itemSelected;
        Provider.of<SustainableShop>(context, listen: false).addSavedItem(item);
        showDialog(context: context, builder: (context) {
          return AlertDialog(
            title: Center(
              child: Text("Item saved."),
            ),
          );
        }
        );
        }
      );
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
            Expanded(
                child: ListView.builder(
                    itemCount: value.sustainableShop.length,
                    itemBuilder: (context, index) {

                  Item eachItem = value.sustainableShop[index];

                  return ItemTile(
                      item: eachItem,
                      icon: Icon(Icons.add),
                      onPressed: () => addToSaved(eachItem));
            }),
            ),
          ],
        ),
      ),
    ),
    );
  }
}
