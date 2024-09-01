import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/items.dart';
import '../components/app_colors.dart';
import '../components/bottom_nav_bar.dart';

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
  int _selectedIndex = 0;

  // Define icons for tabs
  final List<IconData> _icons = [
    Icons.info,
    Icons.favorite_border,
    Icons.shopping_cart,
  ];

  // Define labels for tabs
  final List<String> _labels = [
    'Info ',
    'Add',
    'Buy',
  ];

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

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) {
        saveItem();
      } else if (index == 2) {
        buyNow();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Text(""),
        ),
        backgroundColor: AppColors.background,
        iconTheme: IconThemeData(
          color: Colors.grey[900], // set back button color to grey[900]
        ),
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image at the top of the page
            Image.asset(
              widget.item.imagePath,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // Center all content horizontally
                children: [
                  Text(
                    widget.item.name,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    widget.item.price,
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center, // Center price label text
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Sustainability Score",
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(width: 5), // Add some space between text and icon
                      Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          icon: Icon(Icons.help_outline, size: 20),
                          onPressed: () {
                            setState(() {
                              showTable = !showTable;
                            });
                          },
                          tooltip: showTable ? 'Hide Explanation' : 'Show Explanation',
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: Container(
                      width: 220,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.red,
                            AppColors.yellow,
                            AppColors.green,
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
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(color: Colors.transparent),
                              ),
                            ),
                          ),
                          Positioned(
                            left: (widget.item.sustainabilityScore / 100) * 220 - 5, // Adjusted to match the container width
                            top: 0,
                            child: Container(
                              width: 20,
                              height: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),

                  // Visibility widget for the explanation table
                  Visibility(
                    visible: showTable,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center, // Center explanation content
                      children: [
                        Text(
                          "100 indicates complete sustainability. Common sustainability issues with ingredients such as excessive CO2 emissions, overuse of pesticides, and use of animal feed are considered when each score is calculated. Here is a list of the qualities we grade on and how they affect the sustainability score:",
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16.0),
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
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavBar(
        onTabChange: navigateBottomBar,
        labels: _labels,
        numberOfTabs: _icons.length,
        icons: _icons, // Pass icons to the bottom navigation bar
      ),
    );
  }
}
