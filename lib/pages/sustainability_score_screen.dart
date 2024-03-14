import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_openai/langchain_openai.dart';

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
  getRating() {
    final List<String> ingredientsList = ingredientsController.text.split(',');

    for (var ingredient in ingredientsList) {
      String key = ingredient.toLowerCase().trim();
      String rating = findPartialMatch(key);
      if (rating == null) {
        return "";
      }
      else {
        return rating;
      }

    }
  }

  textToNumber(String inputText) {
    int total = 0;
    int count = inputText.length;
    for (int i = 0; i < inputText.length; i++) {
      total += inputText.codeUnitAt(i);
    }
    int real = int.parse(getRating());
    total += real;
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
              textToNumber(ingredientsController.text).toString()
            ),
            ElevatedButton(
              onPressed: () {
                textToNumber(ingredientsController.text);
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
