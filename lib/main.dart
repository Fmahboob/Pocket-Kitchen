import 'package:flutter/material.dart';
import 'package:pocket_kitchen/views/cuisines_view.dart';
import 'package:pocket_kitchen/views/grocery_list_view.dart';
import 'package:pocket_kitchen/views/pantry_view.dart';

void main() {
  runApp(const PocketKitchen());
}

class PocketKitchen extends StatelessWidget {
  const PocketKitchen({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
          length: 3,
          child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: const Color(0xff459657),
                title: const Text('Pocket Kitchen'),
              ),
              bottomNavigationBar: tabBarMenu(),
              body: const TabBarView(
                children: [
                  PantryView(),
                  GroceryListView(),
                  CuisinesView()
                ],
              )
          )
        )
    );
  }
}

Widget tabBarMenu() {
  return const TabBar(
    unselectedLabelColor: Color(0xff7B7777),
    labelColor: Color(0xff459657),
    indicatorColor: Color(0xff459657),
    tabs: [
      Tab(
        text: "Pantry",
        icon: Icon(Icons.inventory_2_outlined),
      ),
      Tab(
        text: "Grocery List",
        icon: Icon(Icons.sticky_note_2_outlined),
      ),
      Tab(
        text: "Recipes",
        icon: Icon(Icons.book_outlined)
      ),
    ],
  );
}