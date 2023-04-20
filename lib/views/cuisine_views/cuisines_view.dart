import 'package:flutter/material.dart';
import 'package:pocket_kitchen/views/cuisine_views/cuisine_recipes_view.dart';

import '../../models/app_models/shared_preferences.dart';

class CuisinesView extends StatefulWidget {
  const CuisinesView({super.key});

  @override
  State<StatefulWidget> createState() => CuisinesViewState();
}

class CuisinesViewState extends State<CuisinesView> {
  // All static cuisines
  List<String> categories = [  "African", "American", "British", "Chinese", "Eastern European", "European", "German", "Greek", "Indian", "Italian", "Japanese", "Korean", "Mediterranean", "Mexican", "Middle Eastern", "Spanish", "Thai"];
  // By default first one is selected
  int selectedIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xff459657),
        title: Text(sharedPrefs.currentPantryName),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 0.0),
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
        String category = categories[index];
        //Go to cuisines page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CuisinesRecipesView(title: category,
              selectedCuisine: category),
          ),
        );
            },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
        child: Container(
            height: 40,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Color(0xff459657),
            ),
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
              child: Text(categories[index],
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
        ),
      ),
    );
  }
}





