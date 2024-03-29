
import 'package:flutter/material.dart';

import '../../models/app_models/shared_preferences.dart';
import '../../models/data_models/food.dart';
import '../../models/data_models/pantry_food.dart';
import '../../models/recipe_model/recipe_detail.dart';

class RecipeView extends StatefulWidget {
  final RecipeDetail recipeDetail;
  const RecipeView({super.key, required this.recipeDetail});

  @override
  State<StatefulWidget> createState() => RecipeViewState();
  
}

class RecipeViewState extends State<RecipeView>{
  static const textStyle = TextStyle(fontSize: 20, color: Color(0xff7B7777), fontWeight: FontWeight.w500);
  static const headingStyle = TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500
  );

  String availabilityStr = "";
  late Color ingredientColor;
  String availabilityChar = "";

  List<dynamic> ingredientInPantry(ExtendedIngredients ingredient) {
    for (PantryFood pantryFood in sharedPrefs.pantryFoodList) {
      for (Food food in sharedPrefs.foodList) {
        if (pantryFood.foodId == food.id) {
          if (food.name!.toLowerCase().contains(ingredient.name.toLowerCase())) {
            if (food.ownUnit == "0") {
              double weight = double.parse(food.weight!);
              double percent = double.parse(pantryFood.amount!);
              double currAmount = weight * percent;

              if (food.weight == "1000") {
                return [3, pantryFood];
              }
              return [convertUnitsFromKg(currAmount, ingredient.unit, ingredient.amount)];
            } else {
              return [convertUnitsFromCups(double.parse(pantryFood.amount!), ingredient.unit, ingredient.amount)];
            }
          } else {
            List<String> listOfWordsInIngredient = ingredient.name.split("\\s+");
            List<String> listOfWordsInFood = food.name!.split("\\s+");
            int counter = 0;

            for (String ingWord in listOfWordsInIngredient) {
              for (String foodWord in listOfWordsInFood) {
                if (foodWord.contains(ingWord)) {
                  counter += 1;

                  if (counter == listOfWordsInIngredient.length) {
                    double weight = double.parse(food.weight!);
                    double percent = double.parse(pantryFood.amount!);
                    double currAmount = weight * percent;

                    if (food.weight == "1000") {
                      return [3, pantryFood];
                    }

                    return [convertUnitsFromKg(currAmount, ingredient.unit, ingredient.amount)];
                  }
                }
              }
            }
          }
        }
      }
    }
    return [1];
  }

  int convertUnitsFromKg(double currAmount, String unit, double recipeAmount) {
    unit = unit.toLowerCase();
    if (unit == "oz" || unit == "ounces" || unit == "ounce") {
      double amountInOz = currAmount * 35.274;
      if (amountInOz >= recipeAmount) {
        return 0;
      }  else {
        return 1;
      }
    } else if (unit == "tsp" || unit == "teaspoon" || unit == "teaspoons" || unit == "tea spoon" || unit == "tea spoons") {
      double amountInTsp = currAmount * 204.082;
      if (amountInTsp >= recipeAmount) {
        return 0;
      } else {
        return 1;
      }
    } else if (unit == "tbsp" || unit == "tablespoon" || unit == "tablespoons" || unit == "table spoon" || unit == "table spoons") {
      double amountInTbsp = currAmount * 67.568;
      if (amountInTbsp >= recipeAmount) {
        return 0;
      } else {
        return 1;
      }
    } else if (unit == "cup" || unit == "cups" || unit == "serving" || unit == "servings" || unit == "can" || unit == "cans" || unit.contains("handful")) {
      double amountInCups = currAmount * 6;
      if (amountInCups >= recipeAmount) {
        return 0;
      } else {
        return 1;
      }
    } else if (unit == "lbs." || unit == "lbs" || unit == "lb" || unit == "lb." || unit == "pounds" || unit == "pound") {
      double amountInLbs = currAmount * 2.205;
      if (amountInLbs >= recipeAmount) {
        return 0;
      } else {
        return 1;
      }
    } else {
      return 2;
    }
  }

  int convertUnitsFromCups(double currAmount, String unit, double recipeAmount) {
    unit = unit.toLowerCase();
    if (unit == "oz" || unit == "ounces" || unit == "ounce") {
      double amountInOz = currAmount * 8;
      if (amountInOz >= recipeAmount) {
        return 0;
      }  else {
        return 1;
      }
    } else if (unit == "tsp" || unit == "teaspoon" || unit == "teaspoons" || unit == "tea spoon" || unit == "tea spoons") {
      double amountInTsp = currAmount * 48;
      if (amountInTsp >= recipeAmount) {
        return 0;
      } else {
        return 1;
      }
    } else if (unit == "tbsp" || unit == "tablespoon" || unit == "tablespoons" || unit == "table spoon" || unit == "table spoons") {
      double amountInTbsp = currAmount * 16;
      if (amountInTbsp >= recipeAmount) {
        return 0;
      } else {
        return 1;
      }
    } else if (unit == "cup" || unit == "cups" || unit == "serving" || unit == "servings" || unit == "can" || unit == "cans" || unit.contains("handful")) {
      if (currAmount >= recipeAmount) {
        return 0;
      } else {
        return 1;
      }
    } else if (unit == "lbs." || unit == "lbs" || unit == "lb" || unit == "lb." || unit == "pounds" || unit == "pound") {
      double amountInLbs = currAmount / 2;
      if (amountInLbs >= recipeAmount) {
        return 0;
      } else {
        return 1;
      }
    } else {
      return 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipeDetail = widget.recipeDetail;
    String instructions = recipeDetail.instructions.replaceAll(RegExp(r'<[^>]*>|\\'), '');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xff459657),
        title: Text(sharedPrefs.currentPantryName),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 0.0),
              child: Container(
                height: 40,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Color(0xff459657),
                ),
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                  child: Text(recipeDetail.title, style: headingStyle
                  ),
                  ),
                ),
              ),
            Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                child: Image.network(recipeDetail.imageUrl)),
            Row(
              children:[
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 8.0),
                  child: Text("Cook Time: ${recipeDetail.cookTime} mins.",
                    style: textStyle,),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
              child: Container(
                height: 40,
                  decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Color(0xff459657),
                ),
                child: Row(
                  children: const [
                   Padding(
                          padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                          child: Text("Ingredients",
                            style: headingStyle,),
                        ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                      child: Text("Availability",
                        style: headingStyle,),
                    ),

                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),

                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: recipeDetail.extendedIngredients.length,
                    itemBuilder: (context, index) {
                      final ingredient = recipeDetail.extendedIngredients[index];
                      List <dynamic> inPantryFlag = ingredientInPantry(ingredient);
                      if (inPantryFlag[0] == 0) {
                        availabilityStr = "Available";
                        availabilityChar = "\u2713";
                        ingredientColor = const Color(0xff459657);
                      } else if (inPantryFlag[0] == 1) {
                        availabilityStr = "Unavailable";
                        availabilityChar = "X";
                        ingredientColor = const Color(0xff9E4848);
                      } else if (inPantryFlag[0] == 2) {
                        availabilityStr = "Unknown Unit";
                        availabilityChar = "?";
                        ingredientColor = const Color(0xfff5d16e);
                      } else if (inPantryFlag[0] == 3) {
                        double percentDecimal = double.parse(inPantryFlag[1].amount);
                        double percentWhole = percentDecimal * 100;
                        String percentStr = "${percentWhole.toStringAsFixed(0)}%";

                        availabilityStr = "Unsure, $percentStr in pantry";
                        availabilityChar = "?";
                        ingredientColor = const Color(0xfff5d16e);
                      }
                      return Row(
                        children: [
                          Expanded(
                            child: Padding(

                              padding: EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 0.0),
                              child: Text(
                                "${ingredient.name}  ${ingredient.amount}  ${ingredient.unit}",
                                style: TextStyle(
                                  color: ingredientColor
                                )
                              )
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                            child: Text(availabilityChar,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: ingredientColor,
                                  fontWeight: FontWeight.w500)
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                            child: Text(availabilityStr,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: ingredientColor,
                                  fontWeight: FontWeight.w500
                              )),

                          ),

                        ],
                      );
                    }
                  ),

              ),

            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
              child: Container(
                height: 40,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Color(0xff459657),

                ),
                alignment: Alignment.centerLeft,
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                  child: Text("Instructions", style: headingStyle
                  ),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                child: Text(instructions,
                  style: textStyle,
                ),
            ),
          ],
        ),
      ),
    );
  }
}