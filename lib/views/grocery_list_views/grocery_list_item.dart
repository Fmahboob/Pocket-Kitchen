import '../../models/app_models/database.dart';
import '../../models/data_models/food.dart';
import '../../models/data_models/pantry_food.dart';
import 'package:flutter/material.dart';

class GroceryListItem extends StatefulWidget {
  final PantryFood pantryFood;
  final VoidCallback onLongPress;

  const GroceryListItem({
    Key? key,
    required this.pantryFood,
    required this.onLongPress
  }) : super(key: key);

  @override
  State<GroceryListItem> createState() => GroceryListItemState();
}

class GroceryListItemState extends State<GroceryListItem> {
  get pantryFood => widget.pantryFood;
  bool isExpanded = false;

  _getFood(String id) {
    Database.getFood("", "", id, Database.idQual);
  }

  _updatePantryFood (String id, String amount, String pantryId, String foodId) {
    Database.updatePantryFood(id, amount, pantryId, foodId);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      onLongPress: widget.onLongPress,
      child:
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
            child:
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child:
                    AnimatedContainer(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Color(0xff7B7777),
                        ),
                        duration: const Duration(milliseconds: 100),
                        height: isExpanded ? 175 : 40,
                        child:
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                              child:
                                  Row(
                                    children: [
                                      Visibility(
                                        visible: isExpanded,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
                                          child: Container(
                                            height: 159,
                                            width: 159,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(5)),
                                              color: Colors.white,
                                            ),
                                            child: Image.network("https://www.pngmart.com/files/5/Ketchup-PNG-HD.png"),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child:
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              constraints: BoxConstraints(
                                                maxWidth: MediaQuery.of(context).size.width - 32.0,
                                              ),
                                              child: Text(
                                                "Heinz Tomato Ketchup, 750mL/25oz., Bottle, {Imported From Canada",
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                maxLines: isExpanded ? 4 : 1,
                                                overflow: isExpanded ? TextOverflow.ellipsis: TextOverflow.fade,
                                              ),
                                            ),
                                            Visibility(
                                              visible: isExpanded,
                                              child: const Spacer(),
                                            ),
                                            Visibility(
                                              visible: isExpanded,
                                              child: const Padding(
                                                padding: EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 0.0),
                                                child: Text(
                                                  "Vegetable, organic, classic, yummy",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w500
                                                  ),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                          flex: isExpanded ? 1 : 0,
                                          child: Column(
                                            children: [
                                              Visibility(
                                                visible: isExpanded,
                                                child: const Spacer(),
                                              ),
                                              Visibility(
                                                visible: isExpanded,
                                                child: Container(
                                                  height: 40,
                                                  width: 40,
                                                  decoration: const BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                                    color: Colors.white,
                                                  ),
                                                  child: IconButton(
                                                    icon: const Icon(Icons.check),
                                                    color: const Color(0xff459657),
                                                    tooltip: 'Manually restock this item',
                                                    onPressed: () {
                                                      manualRestockDialog();
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                      ),
                                    ],
                                  ),
                            ),
                    )
                )
              ],
            ),
          ),
    );
  }

  Future manualRestockDialog() => showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (context, setState) =>
              AlertDialog(
                content:
                const Text(
                  "Are you sure you want to manually restock this item?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff7B7777),
                      fontWeight: FontWeight.w400
                  ),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Food food = _getFood(pantryFood.foodId!);
                          _updatePantryFood(pantryFood.id!, food.weight!, pantryFood.pantryId!, pantryFood.foodId!);

                          Navigator.pop(context);
                        },
                        style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(Color(0xff459657)),
                        ),
                        child:
                        const Text(
                          "Restock",
                          style: TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                              fontWeight: FontWeight.w400
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
      )
  );
}