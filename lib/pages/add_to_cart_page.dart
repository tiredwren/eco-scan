import 'package:barcode_scanner/const.dart';
import 'package:barcode_scanner/models/shop.dart';
import 'package:barcode_scanner/pages/shop_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/items.dart';

class AddToCartPage extends StatefulWidget {
  final Item item;
  final VoidCallback addToSavedCallback; // Add this line
  const AddToCartPage({Key? key, required this.item, required this.addToSavedCallback}) : super(key: key);

  @override
  State<AddToCartPage> createState() => _AddToCartPageState();
}


class _AddToCartPageState extends State<AddToCartPage> {

  void saveItem() {
    widget.addToSavedCallback();
    Navigator.pop(context);
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                widget.item.imagePath,
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 16.0),
              Text(
                widget.item.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text(
                widget.item.price,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16.0),
              MaterialButton(
                child: Text(
                  'Add to Cart',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: saveItem,
                color: Colors.grey[800],
              ),
            ],
          ),
        ),
      ),
    );
  }
}