import 'package:flutter/material.dart';

class GroceryListView extends StatelessWidget {
  const GroceryListView({Key? key}) : super (key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xff459657),
          title: const Text('Pocket Kitchen'),
          leading: IconButton(
            onPressed: () {

            },
            icon: const Icon(Icons.edit),
            tooltip: 'Scan food items to your pantry',
          ),
          actions: [
            IconButton(
              onPressed: () {

              },
              icon: const Icon(Icons.document_scanner_outlined),
              tooltip: 'Scan food items to your pantry',
            )
          ]
        ),
      body: Container(

        )
      );
  }
}