import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PageThree extends StatefulWidget {

  @override
  State<PageThree> createState() => _PageThreeState();
}

class _PageThreeState extends State<PageThree> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[200],
      body: Center(
        child: Stack(
          children: [
            Container(
                alignment: Alignment(0,-0.3),
                child: Lottie.network('https://lottie.host/8666cfd0-098c-4cec-b53c-efae57ee3e71/MbszuSH9Gj.json')),
          Container(
              alignment: Alignment(0,0.25),
              padding: const EdgeInsets.all(40.0),
              child: Text(
                "When shopping, scan the ingredients list on your products before you buy them to quickly check how sustainable they are!",
                style: TextStyle(fontSize: 18, color: Colors.white),
            )
          )]
        )
      ),
    );
  }
}
