import 'dart:ffi';

import 'package:flutter/material.dart';
import '../../models/app_models/database.dart';
import '../../models/app_models/shared_preferences.dart';
import '../../models/data_models/food.dart';
import '../../models/data_models/pantry_food.dart';
import 'grocery_list_item.dart';
/*
class GroceryList extends StatefulWidget {
  const GroceryList({Key? key}) : super(key: key);

  @override
  State<GroceryList> createState() => GroceryListState();
}

class GroceryListState extends State<GroceryList> {

  _updatePantryFood (String id, String amount, String pantryId, String foodId) {
    Database.updatePantryFood(id, amount, pantryId, foodId);
  }

  Future<Food> _getFood (String barcode, String name, String id, String qualifier) {
    return Database.getFood(barcode, name, id, qualifier);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: sharedPrefs.getUnavailablePantryFoods().length,
      itemBuilder: (context, index) {
        return GroceryListItem(
          pantryFood: pantryFood,
          food: food,
          onLongPress: () async {
            await _updatePantryFood(pantryFood.id!, "1", pantryFood.pantryId!, pantryFood.foodId!);
          },
        );
      }
    );
  }
}
 */