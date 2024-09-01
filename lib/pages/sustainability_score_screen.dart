import 'package:barcode_scanner/components/app_colors.dart';
import 'package:barcode_scanner/const.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../components/my_textfield.dart';

class ResultScreen extends StatefulWidget {
  final String ingredients;

  ResultScreen({Key? key, required this.ingredients}) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late TextEditingController ingredientsController;
  late Map<String, String> sustainabilityRatings = {};
  late String sustainabilityScore = "";
  bool showTable = false;

  @override
  void initState() {
    super.initState();
    ingredientsController = TextEditingController(text: widget.ingredients);
    ingredientsController.addListener(_updateText);
    _loadCSVData();
    _updateText();
  }

  Future<void> _loadCSVData() async {
    try {
      final csvString = await rootBundle.loadString('assets/ingredients_v1.csv');
      final List<List<dynamic>> csvList = CsvToListConverter().convert(csvString);

      for (var row in csvList) {
        if (row.isNotEmpty && row.length >= 2) {
          String key = row[0].toString().toLowerCase();
          String value = row[1].toString();
          sustainabilityRatings[key] = value;
        }
      }

      print('Sustainability Ratings: $sustainabilityRatings');
    } catch (e) {
      print('Error loading CSV data: $e');
    }
  }

  double getRating(String key) {
    String rating = findPartialMatch(key);
    if (rating != "0") {
      return double.parse(rating);
    } else {
      return 0;
    }
  }

  String textToNumber(String inputText) {
    List<String> ingredientsList = inputText.split(',');
    double total = 0;
    int count = 0;

    for (var ingredient in ingredientsList) {
      String key = ingredient.toLowerCase().trim();
      double rating = getRating(key);
      if (rating != 0) {
        total += rating;
      } else {
        for (int i = 0; i < ingredient.length; i++) {
          total += ingredient.codeUnitAt(i);
        }
      }
      count++;
    }

    double score = ((total / count) % 100);
    return score.toStringAsFixed(2);
  }

  String findPartialMatch(String key) {
    for (var entry in sustainabilityRatings.entries) {
      if (entry.key.contains(key)) {
        return entry.value;
      }
    }
    return "0";
  }

  void _updateText() {
    setState(() {
      sustainabilityScore = textToNumber(ingredientsController.text);
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: backgroundColor,
      title: const Text(""),
    ),
    backgroundColor: backgroundColor,
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input Text Field at the top
            MyTextField(
              controller: ingredientsController,
              hintText: 'Enter ingredients',
              obscureText: false,
              maxLines: null,
            ),
            const SizedBox(height: 20),
            // Sustainability Score Display
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                Container(
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
                        widthFactor: double.parse(sustainabilityScore) / 100,
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
                        left: (double.parse(sustainabilityScore) / 100) * 200 - 5,
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
                SizedBox(height: 16.0),

                // Explanation Table
                Visibility(
                  visible: showTable,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "100 indicates complete sustainability. Common sustainability issues with ingredients such as excessive CO2 emissions, overuse of pesticides, and use of animal feed are considered when each score is calculated. Here is a list of the qualities we grade on and how they affect the sustainability score:",
                        textAlign: TextAlign.center,
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
          ],
        ),
      ),
    ),
  );

  @override
  void dispose() {
    ingredientsController.dispose();
    super.dispose();
  }
}
