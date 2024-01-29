import 'package:barcode_scanner/components/item_tile.dart';
import 'package:barcode_scanner/models/items.dart';
import 'package:barcode_scanner/models/shop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {

  void removeFromSaved(Item item) {
    Provider.of<SustainableShop>(context, listen: false).removeSavedItem(item);

}
  @override
  Widget build(BuildContext context) {
    return Consumer<SustainableShop>(
      builder: (context, value, child) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                Text(
                  "Saved Items",
                  style: TextStyle(fontSize: 20),
                ),

                Expanded(
                  child: ListView.builder(
                      itemCount: value.savedItems.length,
                      itemBuilder: (context, index) {
                    // get individual saved items
                    Item eachItem = value.savedItems[index];
                    return ItemTile(
                        item: eachItem,
                        onPressed: () => removeFromSaved(eachItem),
                        icon: Icon(Icons.delete),
                    );
                }
                ),
                ),
              ],
            ),
          )),
        );
      }
    }
