import 'package:flutter/material.dart';

class PantryView extends StatelessWidget {
  const PantryView({Key? key}) : super (key: key);

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
              icon: const Icon(Icons.menu),
              tooltip: 'Scan food items to your pantry',
            ),
        ),
        body: Container(

        )
    );
  }
}