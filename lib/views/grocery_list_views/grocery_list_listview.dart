import 'package:flutter/material.dart';
import '../../database.dart';
import '../../models/food.dart';
import '../../models/pantry_food.dart';
import 'grocery_list_item.dart';

class GroceryList extends StatefulWidget {
  final List<PantryFood> groceryList;

  const GroceryList({Key? key, required this.groceryList}) : super(key: key);

  @override
  State<GroceryList> createState() => GroceryListState();
}

class GroceryListState extends State<GroceryList> {

  _getFood(String id) {
    Database.getFood(id);
  }

  _updatePantryFood (String id, String amount, String pantryId, String foodId) {
    Database.updatePantryFood(id, amount, pantryId, foodId);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: widget.groceryList.length,
      itemBuilder: (context, index) {
        final pantryFood = widget.groceryList[index];
        return GroceryListItem(
          pantryFood: pantryFood,
          onLongPress: () {
            Food food = _getFood(pantryFood.foodId!);
            _updatePantryFood(pantryFood.id!, food.weight!, pantryFood.pantryId!, pantryFood.foodId!);
          },
        );
      }
    );
  }
}