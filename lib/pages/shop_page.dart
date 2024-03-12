import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/items.dart';
import '../components/item_tile.dart';
import './add_to_cart_page.dart';
import '../models/shop.dart';
import 'package:csv/csv.dart';
import 'package:flutter/src/services/asset_bundle.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  late List<Item> allItems;
  late List<Item> displayedItems;

  @override
  void initState() {
    super.initState();
    // Initialize the list of items from the SustainableShop class
    allItems = Provider.of<SustainableShop>(context, listen: false).sustainableShop;
    displayedItems = List.from(allItems);
  }

  void addToSaved(Item item) {
    // Implement your addToSaved logic here
  }

  void onQueryChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        displayedItems = List.from(allItems);
      } else {
        displayedItems = allItems.where((item) => item.name.toLowerCase().contains(query.toLowerCase())).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            const Text(
              "Welcome to EcoScan",
              style: TextStyle(fontSize: 20),
            ),
            SearchBar(onQueryChanged: onQueryChanged),
            Expanded(
              child: ListView.builder(
                itemCount: displayedItems.length,
                itemBuilder: (context, index) {
                  Item eachItem = displayedItems[index];
                  return ItemTile(
                    item: eachItem,
                    icon: Icon(Icons.arrow_forward),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddToCartPage(item: eachItem, addToSavedCallback: () => addToSaved(eachItem)),
                      ),
                    ),
                  );
                },
              ),
              
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  final Function(String) onQueryChanged;

  SearchBar({required this.onQueryChanged});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  String query = '';

  void onQueryChanged(String newQuery) {
    setState(() {
      query = newQuery;
    });

    widget.onQueryChanged(newQuery);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: 
      TextField(
        onChanged: onQueryChanged,
        decoration: InputDecoration(
          labelText: 'Search',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.white),
          ),
          prefixIcon: Icon(Icons.search),
          filled: true,
          fillColor: Colors.white, 
        ),
      ),
      
    );
  }
}