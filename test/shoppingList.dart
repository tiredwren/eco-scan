import 'package:flutter/material.dart';

void main() => runApp(MyShoppingList());

class MyShoppingList extends StatefulWidget {
  const MyShoppingList({ Key? key}) : super(key: key);

  @override
  _MyShoppingListState createState() => _MyShoppingListState();
}

class _MyShoppingListState extends State<MyShoppingList> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: ListView.builder(itemBuilder: (context, index) {
            return Card(
              child: ListTile( 
                title: Row(children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.purple
                    ),
                    child: Center(child: Text('ID', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))
                  ),
                  SizedBox(width: 10),
                  Column(children : [
                    Text('Name', style: TextStyle(fontWeight: FontWeight.w600)),
                    Text('Desc'),
                  ])
                ],)
              )
            );
          })
        ),
      ),
    );
  }
}

//Need API database?