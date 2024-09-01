import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:barcode_scanner/models/items.dart';
import 'package:barcode_scanner/models/shop.dart';
import 'package:barcode_scanner/components/item_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({Key? key}) : super(key: key);

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  void removeFromSaved(DocumentSnapshot item) {
    User? user = FirebaseAuth.instance.currentUser;
    String? userUid = user?.uid;

    if (userUid != null) {
      CollectionReference savedItemsCollection =
      FirebaseFirestore.instance.collection('users').doc(userUid).collection('saved items');

      // Remove the item from the user's collection
      savedItemsCollection.doc(item.id).delete();
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
              Text(
                "Saved Items",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 25),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .collection('saved items')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    } else if (snapshot.hasData) {
                      if (snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text(
                            "Save something from the shop to see it here.",
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                          ),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final itemData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                            return GestureDetector(
                              onTap: () async {
                                String? url = itemData['url'];
                                if (url != null && url.isNotEmpty) {
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    print('Could not launch $url');
                                  }
                                }
                              },
                              child: ItemTile(
                                item: Item(
                                  name: itemData['itemName'] ?? '',
                                  price: itemData['price'] ?? '',
                                  imagePath: itemData['image'] ?? '',
                                  sustainabilityScore: 0,
                                  url: itemData['url'] ?? '',
                                ),
                                onPressed: () => removeFromSaved(snapshot.data!.docs[index]),
                                icon: Icon(Icons.delete),
                              ),
                            );
                          },
                        );
                      }
                    } else {
                      return const Center(
                        child: Text(
                          "No data available",
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    }
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
