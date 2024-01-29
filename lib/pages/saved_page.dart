import 'package:barcode_scanner/components/item_tile.dart';
import 'package:barcode_scanner/models/items.dart';
import 'package:barcode_scanner/models/shop.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({Key? key}) : super(key: key);

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  void removeFromSaved(DocumentSnapshot item) {
    FirebaseFirestore.instance.collection('saved items').doc(item.id).delete();
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

              const SizedBox(height: 25),
              
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection("saved items").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final item = snapshot.data!.docs[index];
                          return ItemTile(
                            item: Item(
                              name: item['itemName'],
                              price: item['price'],
                              imagePath: item['image'],
                            ),
                            onPressed: () => removeFromSaved(item),
                            icon: Icon(Icons.delete),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
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
