import 'package:barcode_scanner/pages/barcode_scanner.dart';
import 'package:barcode_scanner/tutorial/page_one.dart';
import 'package:barcode_scanner/tutorial/page_three.dart';
import 'package:barcode_scanner/tutorial/page_two.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Tutorial extends StatefulWidget {
  const Tutorial({Key? key}) : super(key: key);

  @override
  State<Tutorial> createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {

  // controller to keep track of which page we're on

  PageController _controller = PageController();

  // on last page?

  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            controller: _controller,
            children: [
              PageOne(),
              PageTwo(),
              PageThree()
            ],
          ),
          // dot indicators
          Container(
              alignment: Alignment(0,0.75),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => BarcodeScanner())
                        );
                  },
                      child: Text('skip')),
                  SmoothPageIndicator(controller: _controller, count: 3),

                  onLastPage
                      ? GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => BarcodeScanner())
                        );
                      },
                      child: Text('done'))

                      : GestureDetector(
                      onTap: () {
                        _controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeIn
                        );
                      },
                      child: Text('next'))

                ],
              )
          )
        ],
      ),

    );
  }
}
