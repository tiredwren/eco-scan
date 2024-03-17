import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PageOne extends StatefulWidget {

  @override
  State<PageOne> createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      body: Center(
          child: Stack(
              children: [
                Container(
                    alignment: Alignment(0,-0.3),
                    child: Lottie.network('https://lottie.host/fdbb4f69-ea2d-418c-9bfd-e3c94ce71d8d/oS9wp2eQ6f.json')),
                Container(
                    alignment: Alignment(0,0.3),
                    padding: const EdgeInsets.all(40.0),
                    child: Text(
                      "Welcome to EcoScan! Become a more sustainable shopper without wasting your time.",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    )
                )]
          )
      ),
    );
  }
}