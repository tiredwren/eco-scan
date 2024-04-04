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

  @override
  void initState() {
    super.initState();
    ingredientsController = TextEditingController(text: widget.ingredients);
    ingredientsController.addListener(_updateText);
    _loadCSVData();
    _updateText();
  }

  Future<void> _loadCSVData() async {
    final csvString = await rootBundle.loadString('assets/ingredients_v1.csv');
    final List<List<dynamic>> csvList = CsvToListConverter().convert(csvString);

    for (var row in csvList) {
      if (row.isNotEmpty && row.length >= 2) {
        String key = row[0].toString().toLowerCase();
        String value = row[1].toString();
        sustainabilityRatings[key] = value;
      }
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
      title: const Text('Edit Ingredients'),
    ),
    body: SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            MyTextField(
              controller: ingredientsController,
              hintText: 'Enter ingredients',
              obscureText: false,
              maxLines: null,
            ),
            const SizedBox(height: 20),
            Text(
              "Sustainability Score",
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            SizedBox(height: 5.0),
            // displaying sustainability score as a bar spectrum
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
                    widthFactor: double.parse(sustainabilityScore) / 100,
                    child: Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.transparent),
                      ),
                    ),
                  ),
                  // Position the white dot indicator
                  Positioned(
                    left: (double.parse(sustainabilityScore) / 100) * 200 -
                        5, // position of circle indicator
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
