import 'package:flutter/material.dart';

import '../../main.dart';
import '../../models/app_models/database.dart';
import '../../models/app_models/shared_preferences.dart';
import '../../models/data_models/food.dart';
import '../../models/data_models/pantry_food.dart';

class UnavailablePantryItem extends StatefulWidget {
  final VoidCallback onLongPress;
  final PantryFood pantryFood;
  final Food food;
  final int index;

  const UnavailablePantryItem({
    super.key,
    required this.onLongPress,
    required this.pantryFood,
    required this.food,
    required this.index
  });

  @override
  State<StatefulWidget> createState() => UnavailablePantryItemState();
}

class UnavailablePantryItemState extends State<UnavailablePantryItem> {
  get pantryFood => widget.pantryFood;
  get food => widget.food;
  get index => widget.index;

  String imgUrl = "";
  String categoryOutput = "";

  bool isExpanded = false;

  //PantryFood CRUD Methods
  _updatePantryFood (String id, String amount, String pantryId, String foodId) {
    Database.updatePantryFood(id, amount, pantryId, foodId);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;

          if (food.imgUrl == "") {
            imgUrl = "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg?20200913095930";
          } else {
            imgUrl = food.imgUrl;
          }

          if (food.category == "" || food.category == " " || food.category == null) {
            categoryOutput = "No category for this item.";
          } else {
            categoryOutput = food.category;
          }
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
                    color: Color(0xff9E4848),
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
                              child: Image.network(imgUrl),
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
                                  food.name,
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
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 0.0),
                                  child: Text(
                                    categoryOutput,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
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
                        onPressed: () async {

                            if (food.ownUnit == "0") {
                              //update the availability to full (100%/1)
                              await _updatePantryFood(pantryFood.id!, "1", pantryFood.pantryId!, pantryFood.foodId!);

                              List<PantryFood> pantryFoodsList = sharedPrefs.pantryFoodList;

                              for (PantryFood aPantryFood in pantryFoodsList) {
                                if (aPantryFood.id == pantryFood.id) {
                                  aPantryFood.amount = "1";
                                }
                              }

                              sharedPrefs.pantryFoodList = pantryFoodsList;
                            } else {
                              //update the availability to full (100% of food weight)
                              await _updatePantryFood(pantryFood.id!, food.weight, pantryFood.pantryId!, pantryFood.foodId!);

                              List<PantryFood> pantryFoodsList = sharedPrefs.pantryFoodList;

                              for (PantryFood aPantryFood in pantryFoodsList) {
                                if (aPantryFood.id == pantryFood.id) {
                                  aPantryFood.amount = food.weight;
                                }
                              }

                              sharedPrefs.pantryFoodList = pantryFoodsList;
                            }
                            Navigator.pop(context);

                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const TabBarMain(flag: 0)),
                            );
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