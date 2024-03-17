// import 'package:flutter/material.dart';
//
// class SearchScreen extends StatefulWidget {
//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }
//
// class _SearchScreenState extends State<SearchScreen> {
//   //sample for now
//   List<String> data = [];
//
//   List<String> searchResults = [];
//
//   @override
//   void initState() {
//     super.initState();
//     initializeData();
//   }
//
//   void initializeData() {
//     // itemData is map from shop_page
//     itemData.forEach((key, value) {
//       if (key == 'itemName') {
//         data.add(value);
//       }
//     });
//   }
//
//   void onQueryChanged(String query) {
//     setState(() {
//       searchResults = data
//           .where((item) => item.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//       ),
//       body: Column(
//         children: [
//           SearchBar(onQueryChanged: onQueryChanged),
//           Expanded(
//             child: ListView.builder(
//               itemCount: searchResults.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(searchResults[index]),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class SearchBar extends StatefulWidget {
//   final Function(String) onQueryChanged;
//
//   SearchBar({required this.onQueryChanged});
//
//   @override
//   _SearchBarState createState() => _SearchBarState();
// }
//
// class _SearchBarState extends State<SearchBar> {
//   String query = '';
//
//   void onQueryChanged(String newQuery) {
//     setState(() {
//       query = newQuery;
//     });
//
//     widget.onQueryChanged(newQuery);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(16),
//       child: TextField(
//         onChanged: onQueryChanged,
//         decoration: InputDecoration(
//           labelText: 'Search',
//           border: OutlineInputBorder(),
//           prefixIcon: Icon(Icons.search),
//         ),
//       ),
//     );
//   }
// }
//
