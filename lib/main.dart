import 'package:flutter/material.dart';
import 'package:pocket_kitchen/shared_preferences.dart';
import 'package:pocket_kitchen/views/cuisines_view.dart';
import 'package:pocket_kitchen/views/grocery_list_views/grocery_list_view.dart';
import 'package:pocket_kitchen/views/pantry_list_views/pantry_list_view.dart';
import 'package:pocket_kitchen/views/signup_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sharedPrefs.init();
  runApp(
    const PocketKitchen(),
  );
}

class PocketKitchen extends StatelessWidget {
  const PocketKitchen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: sharedPrefs.signedIn ? const TabBarMain() : const SignUpView()
    );
  }
}

class TabBarMain extends StatelessWidget {
  const TabBarMain({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
          length: 3,
          child: Scaffold(
              bottomNavigationBar: tabBarMenu(),
              body: const TabBarView(
                children: [
                  PantryListView(),
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