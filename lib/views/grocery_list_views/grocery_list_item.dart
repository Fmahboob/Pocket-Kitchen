import '../../models/pantry_food.dart';
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
                        height: isExpanded ? 175 : 30,
                        child:
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                              child:
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: const [
                                      Text(
                                          "Carrots",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500
                                          )
                                      )
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