import 'package:flutter/material.dart';

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
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Result'),
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
