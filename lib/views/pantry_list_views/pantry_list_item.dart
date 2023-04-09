import 'package:flutter/material.dart';

import '../../main.dart';
import '../../models/app_models/database.dart';
import '../../models/app_models/shared_preferences.dart';
import '../../models/data_models/food.dart';
import '../../models/data_models/pantry_food.dart';

class PantryListItem extends StatefulWidget {
  final VoidCallback onLongPress;
  final PantryFood pantryFood;
  final Food food;
  final int index;

  const PantryListItem({
    super.key,
    required this.onLongPress,
    required this.pantryFood,
    required this.food,
    required this.index
  });
  @override
  State<StatefulWidget> createState() => PantryListItemState();
}

class PantryListItemState extends State<PantryListItem> {
  get pantryFood => widget.pantryFood;
  get food => widget.food;
  get index => widget.index;
  bool isExpanded = false;

  String updateLabel = "";

  String imgUrl = "";
  String categoryOutput = "";

  final TextEditingController percentController = TextEditingController();

  String whatsLeft() {
    if (food.ownUnit == "0") {
      double percentDecimal = double.parse(pantryFood.amount);
      double percentWhole = percentDecimal * 100;
      String percentStr = percentWhole.toStringAsFixed(0);
      return "$percentStr%";
    } else {
      return pantryFood.amount.toString();
    }
  }

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
          if (food.ownUnit == "0") {
            updateLabel = "% Left:";
          } else {
            updateLabel = "# Left:";
          }

          if (food.category == "" || food.category == " " || food.category == null) {
            categoryOutput = "No category for this item.";
          } else {
            categoryOutput = food.category;
          }
        });

        if (food.imgUrl == "") {
          imgUrl = "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg?20200913095930";
        } else {
          imgUrl = food.imgUrl;
        }
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
                    color: Color(0xff459657),
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
                          flex: isExpanded ? 4 : 100,
                          child:
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width - 32.0,
                                ),
                                child:
                                Text(
                                  food.name,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: isExpanded ? 4 : 1,
                                  overflow: TextOverflow.ellipsis,
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
                        Visibility(
                          visible: isExpanded,
                          child: Column(
                            children: [
                              Visibility(
                                visible: isExpanded,
                                child: const Spacer(),
                              ),

                              Visibility(
                                visible: isExpanded,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 0.0),
                                  child: Text(
                                    updateLabel,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: isExpanded,
                                child: const Spacer(),
                              ),
                              SizedBox(
                                height: 40,
                                width: 60,
                                child: TextFormField(
                                  enabled: true,
                                  controller: percentController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: const OutlineInputBorder(),
                                    hintText: whatsLeft(),
                                    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: isExpanded,
                                child: const Spacer(),
                              ),
                              Visibility(
                                visible: isExpanded,
                                child: Container(
                                  height: 40,
                                  width: 60,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    color: Colors.white,
                                  ),
                                  child: TextButton(
                                    onPressed: () async {
                                        //check to update as % or # of
                                        if (food.ownUnit == "0") {
                                          String amountStr = "";
                                          //check for % in input
                                          if (percentController.text.endsWith("%")) {
                                            //remove the %
                                            String decimalStr = "";
                                            for (var rune in percentController.text.runes) {
                                              if (rune != "%") {
                                                decimalStr = "$decimalStr$rune";
                                              }
                                            }
                                            //convert percent and update pantry food
                                            double decimal = double.parse(decimalStr) / 100;
                                            if (decimal == 0.0) {
                                              amountStr = "0";
                                            } else {
                                              amountStr = decimal.toString();
                                            }
                                            await _updatePantryFood(pantryFood.id, amountStr, pantryFood.pantryId, pantryFood.foodId);

                                            List<PantryFood> pantryFoodsList = sharedPrefs.pantryFoodList;

                                            for (PantryFood aPantryFood in pantryFoodsList) {
                                              if (aPantryFood.id == pantryFood.id) {
                                                aPantryFood.amount = amountStr;
                                              }
                                            }

                                            sharedPrefs.pantryFoodList = pantryFoodsList;
                                          } else {
                                            //convert percent and update pantry food
                                            double decimal = double.parse(percentController.text) / 100;
                                            if (decimal == 0.0) {
                                              amountStr = "0";
                                            } else {
                                              amountStr = decimal.toString();
                                            }
                                            await _updatePantryFood(pantryFood.id, amountStr, pantryFood.pantryId, pantryFood.foodId);

                                            List<PantryFood> pantryFoodsList = sharedPrefs.pantryFoodList;

                                            for (PantryFood aPantryFood in pantryFoodsList) {
                                              if (aPantryFood.id == pantryFood.id) {
                                                aPantryFood.amount = amountStr;
                                              }
                                            }

                                            sharedPrefs.pantryFoodList = pantryFoodsList;
                                          }
                                        } else {
                                          //update pantry food
                                          await _updatePantryFood(pantryFood.id, percentController.text, pantryFood.pantryId, pantryFood.foodId);

                                          List<PantryFood> pantryFoodsList = sharedPrefs.pantryFoodList;

                                          for (PantryFood aPantryFood in pantryFoodsList) {
                                            if (aPantryFood.id == pantryFood.id) {
                                              aPantryFood.amount = percentController.text;
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
                                    child: Container(
                                      color: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                                      child: const Text(
                                        'Apply',
                                        style: TextStyle(color: Color(0xff459657), fontSize: 13.0),
                                      ),
                                    ),
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

}