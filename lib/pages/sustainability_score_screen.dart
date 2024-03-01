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

  @override
  void initState() {
    super.initState();
    ingredientsController = TextEditingController(text: widget.ingredients);
    _loadCSVData(); // load csv data when page starts
  }

  Map<String, String> sustainabilityRatings = {};
  Future<void> _loadCSVData() async {
    // load csv file data into memory
    final csvString = await rootBundle.loadString('assets/ingredients_v1.csv');
    final List<List<dynamic>> csvList = CsvToListConverter().convert(csvString);

    // store data in a map with lowercase keys
    for (var row in csvList) {
      if (row.isNotEmpty && row.length >= 2) {
        String key = row[0].toString().toLowerCase();
        String value = row[1].toString();
        sustainabilityRatings[key] = value;
      }
    }
  }

  // function to handle the button press and pass the entered text
  void getRating() {
    final List<String> ingredientsList = ingredientsController.text.split(',');

    for (var ingredient in ingredientsList) {
      String key = ingredient.toLowerCase().trim();
      String rating = findPartialMatch(key);
      print("Ingredient: $ingredient, Sustainability Rating: $rating");
    }
  }

  String findPartialMatch(String key) {
    for (var entry in sustainabilityRatings.entries) {
      if (entry.key.contains(key)) {
        return entry.value;
      }
    }
    return "N/A";
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
            ElevatedButton(
              onPressed: () {
                getRating();
              },
              child: const Text('See Sustainability Score'),
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
