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
  bool showTable = false;

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
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
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
                "Sustainability Score",
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
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    showTable = !showTable;
                  });
                },
                child: Text(showTable ? 'Hide Explanation' : 'Why?'),
              ),
              SizedBox(height: 16.0),
              Visibility(
                visible: showTable,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "100 indicates complete sustainability. Common sustainability issues with ingredients such as excessive CO2 emissions, overuse of pesticides, and use of animal feed are considered when each score is calculated. Here is a list of the qualities we grade on and how they affect the sustainability score:",                      textAlign: TextAlign.center,
                    ),
                    DataTable(
                      columns: [
                        DataColumn(label: Text('Category')),
                        DataColumn(label: Text('Score')),
                      ],
                      rows: [
                        DataRow(cells: [
                          DataCell(Text('Dairy products (ruminants)')),
                          DataCell(Text('-70')),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Dairy products (non-ruminants)')),
                          DataCell(Text('-60')),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Meat products (ruminant animals)')),
                          DataCell(Text('-85')),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Meat products (non-ruminants)')),
                          DataCell(Text('-65')),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Non-organics')),
                          DataCell(Text('-5')),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Sea-animal products')),
                          DataCell(Text('-70')),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Human-rights issues')),
                          DataCell(Text('-20')),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Habitat Destruction')),
                          DataCell(Text('-50')),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Water use issues (not animal related)')),
                          DataCell(Text('-30')),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Organic')),
                          DataCell(Text('5+')),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Pesticide Use')),
                          DataCell(Text('-15')),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Emissions')),
                          DataCell(Text('-30')),
                        ]),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: saveItem,
              child: Text('Add to Cart'),
              style: ElevatedButton.styleFrom(
                primary: Colors.grey[900],
              ),
            ),
            ElevatedButton(
              onPressed: buyNow,
              child: Text('Buy Now'),
              style: ElevatedButton.styleFrom(
                primary: Colors.grey[900],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
