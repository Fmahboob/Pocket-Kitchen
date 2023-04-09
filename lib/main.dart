import 'package:flutter/material.dart';
import 'package:pocket_kitchen/models/app_models/shared_preferences.dart';
import 'package:pocket_kitchen/views/cuisine_views/cuisines_view.dart';
import 'package:pocket_kitchen/views/google_sign_in_view.dart';
import 'package:pocket_kitchen/views/grocery_list_views/grocery_list_view.dart';
import 'package:pocket_kitchen/views/pantry_list_views/create_join_pantry_screen.dart';
import 'package:pocket_kitchen/views/pantry_list_views/pantry_list_view.dart';

//main app run
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sharedPrefs.init();
  runApp(
    const RestartWidget(
        child: PocketKitchen()
    )
  );
}

//wrapping widget to allow state restarting
class RestartWidget extends StatefulWidget {
  const RestartWidget({super.key, required this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()?.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}

//main app load up webbing logic
class PocketKitchen extends StatelessWidget {
  const PocketKitchen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: sharedPrefs.signedIn ? const TabBarMain(flag: 0) : const GoogleSignInView()
    );
  }
}

//main app
class TabBarMain extends StatelessWidget {
  final int flag;

  const TabBarMain({
    super.key,
    required this.flag
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: !sharedPrefs.hasPantries ? const NoPantryView() : DefaultTabController(
          length: 3,
          initialIndex: flag,
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

//app tab bar
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