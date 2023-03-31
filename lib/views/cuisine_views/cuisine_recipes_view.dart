import 'package:flutter/material.dart';
import 'package:pocket_kitchen/models/recipe_model/recipe_list.dart';


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
    body: FutureBuilder<List<RecipeList>>(
      future: futureRecipes,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          final List<RecipeList> recipes = snapshot.data!;
          return Column(
            children: [
              const Padding(
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
              Expanded(
                child: ListView.builder(
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    final RecipeList recipe = recipes[index];
                    return  Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              color: Color(0xff459657),

                            ),
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 4.0, 4.0, 4.0),
                              child: Text(recipe.title, style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500
                              ),),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 4.0, 4.0, 4.0),
                              child: Image.network(recipe.imageUrl)),
                        ],
                      );

                  },
                ),
              ),
            ],
          );
        }
        else {
          return Center(
            child: Text('${snapshot.error}'),
          );
        }
      },
    ),
    );
  }
}


