import 'package:flutter/material.dart';

class CuisinesView extends StatelessWidget {
  const CuisinesView({Key? key}) : super (key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: const Color(0xff459657),
            title: const Text('Recipes'),
        ),
        body: Container(

        )
    );
  }
}