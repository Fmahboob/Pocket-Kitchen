import 'package:flutter/material.dart';

class CuisinesRecipesView extends StatefulWidget {
  const CuisinesRecipesView({super.key});

  @override
  State<StatefulWidget> createState() => CuisinesRecipesViewState();
}

class CuisinesRecipesViewState extends State<CuisinesRecipesView>{
  String pantryName = "Robbie's Home";
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xff459657),
    title: Text(pantryName),
    ),
    body: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const [
       Padding(
        padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
        child: Text(
            "Recipes",
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 17,
                color: Color(0xff459657),
                fontWeight: FontWeight.w600
            )
        ),
      ),
    ],
    ),
    );
  }
}


