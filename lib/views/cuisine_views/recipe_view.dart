
import 'package:flutter/material.dart';
import 'package:pocket_kitchen/models/recipe_model/recipe_detail.dart';

import '../../models/app_models/shared_preferences.dart';

class RecipeView extends StatefulWidget {
  final RecipeDetail recipeDetail;
  const RecipeView({super.key, required this.recipeDetail});

  @override
  State<StatefulWidget> createState() => RecipeViewState();
  
}

class RecipeViewState extends State<RecipeView>{
  static const textStyle = TextStyle(fontSize: 20, color: Color(0xff7B7777));
  static const headingStyle = TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xff459657),
        title: Text(sharedPrefs.currentPantryName),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4.0, 8.0, 4.0, 8.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Color(0xff459657),

              ),
              alignment: Alignment.center,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Recipe Title", style: headingStyle
                ),
                ),
              ),
            ),
          const Padding(
              padding: EdgeInsets.fromLTRB(8.0, 4.0, 4.0, 4.0),
              child: Text("Image",
                style: textStyle,
              )),
          Row(
            children: const [
              Padding(
                padding: EdgeInsets.fromLTRB(8.0, 4.0, 4.0, 4.0),
                child: Text("Cook Time",
                  style: textStyle,),
              ),

            Padding(
              padding: EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 4.0),
              child: Text("min",
                style: textStyle,),
            ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4.0, 8.0, 4.0, 8.0),
            child: Container(
    decoration: const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(5)),
    color: Color(0xff459657),

    ),
              child: Row(
                children: const [
                 Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Ingredients",
                          style: headingStyle,),
                      ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Available",
                      style: headingStyle,),
                  ),

                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),

              child: Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 4.0),
                    child: Text("Ingredients",
                      style: textStyle,),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 4.0),
                    child: Text("X",
                      style: textStyle,),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(4.0, 4.0, 8.0, 4.0),
                    child: Text("Available",
                      style: textStyle,),
                  ),

                ],
              ),
            ),

          Padding(
            padding: const EdgeInsets.fromLTRB(4.0, 8.0, 4.0, 8.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Color(0xff459657),

              ),
              alignment: Alignment.centerLeft,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Instructions", style: headingStyle
                ),
              ),
            ),
          ),
          const Padding(
              padding: EdgeInsets.fromLTRB(8.0, 4.0, 4.0, 4.0),
              child: Text("Instruct",
                style: textStyle,
              ),
          ),
        ],
      ),
    );
  }
}