import 'package:flutter/material.dart';

class CuisinesView extends StatefulWidget {
  const CuisinesView({super.key});

  @override
  State<StatefulWidget> createState() => CuisinesViewState();
}

class CuisinesViewState extends State<CuisinesView> {
  String pantryName = "Robbie's Home";
  List<String> categories = ["American", "Italian", "Chinese", "Middle Eastern", "Mexican", "Japanese", "Korean", "Indian", "German", "African", "British", "Eastern European", "European", "Greek", "Japanese", "Korean", "Mediterranean", "Spanish", "Thai", "Others"];
  // By default first one is selected
  int selectedIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xff459657),
        title: Text(pantryName),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
            child: Text(
                "Cuisines",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 17,
                    color: Color(0xff459657),
                    fontWeight: FontWeight.w600
                )
            ),
          ),

             Expanded(
               child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                 return cuisinesListItem(index);
    },

            ),
             ),
        ],
      ),
    );
  }


  Widget cuisinesListItem(int index) {
    return GestureDetector(
      onTap: () {

            },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 4.0),
        child: Container(
            height: 50,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Color(0xff459657),

            ),
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 4.0, 4.0, 4.0),
              child: Text(categories[index],
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w500
                ),),
            )
        ),
      ),
    );
  }
}





