import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PageTwo extends StatefulWidget {

  @override
  State<PageTwo> createState() => _PageTwoState();
}

class _PageTwoState extends State<PageTwo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[400],
      body: Center(
          child: Stack(
              children: [
                Container(
                    alignment: Alignment(0,-0.25),
                    child: Lottie.network('https://lottie.host/60b161b0-1124-4eec-9c70-c5bfaef27d09/14RzLDbMVu.json')),
                Container(
                    alignment: Alignment(0,0.25),
                    padding: const EdgeInsets.all(40.0),
                    child: Text(
                      "Review a curated list of sustainable items and save your favorites so you can access them later.",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    )
                )]
          )
      ),
    );
  }
}