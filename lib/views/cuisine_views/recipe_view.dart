
import 'package:flutter/material.dart';

class RecipeView extends StatefulWidget {
  const RecipeView({super.key});

  @override
  State<StatefulWidget> createState() => RecipeViewState();
  
}

class RecipeViewState extends State<RecipeView>{
  String pantryName = "Robbie's Home";
  static const textStyle = TextStyle(fontSize: 20, color: Color(0xff7B7777));
  static const headingStyle = TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xff459657),
        title: Text(pantryName),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 4.0, 8.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Color(0xff459657),

              ),
              alignment: Alignment.center,
              child: const Padding(
                padding: EdgeInsets.fromLTRB(8.0, 4.0, 4.0, 4.0),
                child: Text("Recipe Title", style: headingStyle
                ),
                ),
              ),
            ),
          const Padding(
              padding: EdgeInsets.fromLTRB(16.0, 4.0, 4.0, 4.0),
              child: Text("Image",
                style: textStyle,
              )),
          Row(
            children: const [
              Padding(
                padding: EdgeInsets.fromLTRB(16.0, 4.0, 4.0, 4.0),
                child: Text("Cook Time",
                  style: textStyle,),
              ),

            Padding(
              padding: EdgeInsets.fromLTRB(8.0, 4.0, 4.0, 4.0),
              child: Text("min",
                style: textStyle,),
            ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
    height: 50,
    decoration: const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(5)),
    color: Color(0xff459657),

    ),
              child: Row(
                children: const [
                 Padding(
                        padding: EdgeInsets.fromLTRB(8.0, 4.0, 4.0, 4.0),
                        child: Text("Ingredients",
                          style: headingStyle,),
                      ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
                    child: Text("Available",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w500
                      ),),
                  ),

                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Color(0xff459657),

              ),
              alignment: Alignment.centerLeft,
              child: const Padding(
                padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                child: Text("Instructions", style:headingStyle
                ),
              ),
            ),
          ),
          const Padding(
              padding: EdgeInsets.fromLTRB(16.0, 4.0, 4.0, 4.0),
              child: Text("Instruct",
                style: textStyle,
              )),



        ],
      ),
    );
  }
}