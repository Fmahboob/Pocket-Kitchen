import 'package:flutter/material.dart';

class PantryListItem extends StatefulWidget {
  final VoidCallback onLongPress;

  const PantryListItem({super.key, required this.onLongPress});
  @override
  State<StatefulWidget> createState() => PantryListItemState();

}

class PantryListItemState extends State<PantryListItem> {
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