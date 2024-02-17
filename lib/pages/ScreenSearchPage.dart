//just a test screen page for now

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ScreenSearchPage extends StatefulWidget {
  //List<Map<String, dynamic>> allUsers = []
  _ScreenSearchPageState createState() => _ScreenSearchPageState();
}

class _ScreenSearchPageState extends State<ScreenSearchPage> {
  List<String> data = [
    "Apple",
    "Banana",
    "Cherry",
    "Peach",
    "Pumpkin",
    "Plum",
  ];

 List<String> searchResults = [];

 void onQueryChanged(String query) {
    setState(() {
        searchResults = data.where((item) => item.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Search Bar Tutorial'),
      ),
      body: Column(
        children: [
          SearchBar(onQueryChanged: onQueryChanged),
          Expanded(child: Center(
            child: Text('Search results will be displayed here'
            ),
          ),
          ),
        ],
        ),  
      );
  }
}

//stateful --> user can interact with widget
class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  String query = '';

  void onQueryChanged(String query) {
    setState(() {
        query =  newQuery;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(padding: EdgeInsets.all(16),
    child: TextField(
      decoration: InputDecoration( 
      labelText: 'Search',
      border: OutlineInputBorder(),
      prefixIcon: Icon(Icons.search)
      ),
    ),
  );
  }
}
  