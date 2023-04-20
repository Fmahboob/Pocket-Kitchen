import 'package:flutter/material.dart';
import 'package:pocket_kitchen/models/recipe_model/recipe_detail.dart';
import 'package:pocket_kitchen/models/recipe_model/recipe_list.dart';
import 'package:pocket_kitchen/views/cuisine_views/recipe_view.dart';


import '../../models/app_models/shared_preferences.dart';
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
    title: Text(sharedPrefs.currentPantryName),
    ),
    body: FutureBuilder<List<RecipeList>>(
      future: futureRecipes,
      builder: (context, snapshot) {
        if (snapshot.hasData) {

          final List<RecipeList> recipes = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 0.0),
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
                      return  Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                        child: GestureDetector(
                              onTap: () {
                                RecipeData().fetchRecipeDetail(recipe.id).then((recipeDetail) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>
                                        RecipeView(recipeDetail: recipeDetail)),
                                  );
                                });
                              },

                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                                  child:
                                  Container(
                                    height: 40,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                      color: Color(0xff459657),
                                    ),
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                                      child: Text(
                                        recipe.title,
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                      ),),
                                    ),
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                                    child: Image.network(recipe.imageUrl)),
                              ],
                            ),
                        ),
                      );

                    },
                  ),
                ),
            ],
          );
        }
        else if (snapshot.hasError) {
          return Center(
            child: Text('${snapshot.error}'),
          );
        }
          else {
        return const Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
            Color(0xff459657),
            ),
        ),

        );
        }
      },
    ),
    );
  }
}


