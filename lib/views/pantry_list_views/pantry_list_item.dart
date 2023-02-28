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
                    color: Color(0xff459657),
                  ),
                  duration: const Duration(milliseconds: 100),
                  height: isExpanded ? 250 : 40,
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
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
                              Visibility(
                                visible: isExpanded,
                                child:  const Padding(
                                  padding: EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 0.0),
                                  child: Text(
                                    "Percentage Left",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ),

                              ),
                              Visibility(
                                visible: isExpanded,
                                child:   Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                Container(
                                  height: 30,
                                  width: 50,

                                  child: TextField(
                                    enabled: true,
                                    onChanged: (String input) {
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none
                                      )
                                    ),
                                  ),
                                ),

                    TextButton(
                                      onPressed: () {},
                                      child: Container(
                                        color: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                        child: const Text(
                                          'Apply',
                                          style: TextStyle(color: Color(0xff459657), fontSize: 13.0),
                                        ),
                                      ),
                                    ),
                                  ],
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