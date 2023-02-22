import 'package:flutter/material.dart';
import '../../models/food.dart';
import '../../models/pantry_food.dart';
import 'grocery_list_listview.dart';

class GroceryListView extends StatelessWidget {

  GroceryListView({Key? key}) : super (key: key);
  final groceryList = [PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1)];
  String searchTerm = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xff459657),
          title: const Text('Pocket Kitchen'),
          leading: IconButton(
            onPressed: () {

            },
            icon: const Icon(Icons.edit),
            tooltip: 'Manually enter food items to your pantry',
          ),
          actions: [
            IconButton(
              onPressed: () {

              },
              icon: const Icon(Icons.document_scanner_outlined),
              tooltip: 'Scan food items to your pantry',
            )
          ]
        ),
      body: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
          child:
              Row(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(
                            enabled: true,

                            onChanged: (String input) {
                              searchTerm = input;
                            },
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 3, color: Color(0xff7B7777))
                                ),
                                hintText: "Search",
                              contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                              prefixIcon: Icon(Icons.search)
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
                            child: Text(
                              "Grocery List",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 17,
                                color: Color(0xff7B7777),
                                fontWeight: FontWeight.w600
                              )
                            ),
                          ),
                          Expanded(
                            child:
                            GroceryList(groceryList: groceryList),
                          ),
                        ],
                      )
                    )
                  ]
              )
      ),
    );
  }
}