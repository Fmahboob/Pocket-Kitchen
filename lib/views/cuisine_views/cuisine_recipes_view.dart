import 'package:flutter/material.dart';
import 'package:pocket_kitchen/models/recipe_model/recipe_list.dart';
import 'package:pocket_kitchen/views/cuisine_views/recipe_view.dart';

import '../../models/recipe_model/recipe_data.dart';

class CuisinesRecipesView extends StatefulWidget {
  final String title;
  final String selectedCuisine;
  const CuisinesRecipesView({super.key, required this.title, required this.selectedCuisine});

  @override
  State<StatefulWidget> createState() => CuisinesRecipesViewState();
}

class CuisinesRecipesViewState extends State<CuisinesRecipesView>{
  late Future<List<RecipeList>> futureRecipes;
  String pantryName = "Robbie's Home";

  @override
  void initState() {
    super.initState();
    futureRecipes = RecipeData().recipesByCuisine(widget.selectedCuisine);
    setState(() {

    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xff459657),
    title: Text(pantryName),
    ),
     body:
      Column(
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


