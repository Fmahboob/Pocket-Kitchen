import 'package:flutter/material.dart';
import '../../models/pantry_food.dart';
import 'grocery_list_item.dart';

class GroceryList extends StatefulWidget {
  final List<PantryFood> groceryList;

  const GroceryList({Key? key, required this.groceryList}) : super(key: key);

  @override
  State<GroceryList> createState() => GroceryListState();
}

class GroceryListState extends State<GroceryList> {

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

          },
        );
      }
    );
  }
}