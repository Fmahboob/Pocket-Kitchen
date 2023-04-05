import 'package:flutter/material.dart';

import '../../models/app_models/database.dart';
import '../../models/data_models/food.dart';
import '../../models/data_models/pantry_food.dart';

class PantryListItem extends StatefulWidget {
  final VoidCallback onLongPress;
  final PantryFood pantryFood;
  final Food food;

  const PantryListItem({
    super.key,
    required this.onLongPress,
    required this.pantryFood,
    required this.food
  });
  @override
  State<StatefulWidget> createState() => PantryListItemState();
}

class PantryListItemState extends State<PantryListItem> {
  get pantryFood => widget.pantryFood;
  get food => widget.food;
  bool isExpanded = false;

  final TextEditingController percentController = TextEditingController();

  String percentLeft() {
    double percentDecimal = double.parse(pantryFood.amount);
    double percentWhole = percentDecimal * 100;
    String percentStr = percentWhole.toStringAsFixed(0);
    return "$percentStr%";
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
                              child: Image.network(food.imgUrl ?? "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg?20200913095930"),
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
                                    food.category ?? "No category.",
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
                                child: const Padding(
                                  padding: EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 0.0),
                                  child: Text(
                                    "% Left:",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
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
                                    hintText: percentLeft(),
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
                                    onPressed: () {
                                      setState(() async {
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
                                          await _updatePantryFood(pantryFood.id, decimal.toString(), pantryFood.pantryId, pantryFood.foodId);
                                        } else {
                                          //convert percent and update pantry food
                                          double decimal = double.parse(percentController.text) / 100;
                                          await _updatePantryFood(pantryFood.id, decimal.toString(), pantryFood.pantryId, pantryFood.foodId);
                                        }
                                      });
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