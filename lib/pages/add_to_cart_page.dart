import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/items.dart';

class AddToCartPage extends StatefulWidget {
  final Item item;
  final VoidCallback addToSavedCallback;

  const AddToCartPage({Key? key, required this.item, required this.addToSavedCallback})
      : super(key: key);

  @override
  State<AddToCartPage> createState() => _AddToCartPageState();
}

class _AddToCartPageState extends State<AddToCartPage> {
  void saveItem() {
    widget.addToSavedCallback();
    Navigator.pop(context);
  }

  void buyNow() async {
    if (await canLaunch(widget.item.url)) {
      await launch(widget.item.url);
    } else {
      throw 'Could not launch ${widget.item.url}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add to Cart'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.grey[200],
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
              SizedBox(height: 8.0),
              Text(
                "sustainability score",
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(height: 5.0),
              Container(
                width: 200,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    colors: [
                      Colors.red,
                      Colors.yellow,
                      Colors.green,
                    ],
                    stops: [0, 0.5, 1],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Stack(
                  children: [
                    FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: widget.item.sustainabilityScore / 100,
                      child: Container(
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.transparent),
                        ),
                      ),
                    ),
                    Positioned(
                      left: (widget.item.sustainabilityScore / 100) * 200 - 5,
                      top: 0,
                      child: Container(
                        width: 10,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
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
              SizedBox(height: 16.0),
              MaterialButton(
                child: Text(
                  'Buy Now',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: buyNow,
                color: Colors.grey[800],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
