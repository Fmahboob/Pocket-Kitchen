import 'package:flutter/material.dart';
import 'package:pocket_kitchen/models/app_models/shared_preferences.dart';
import 'package:pocket_kitchen/views/pantry_list_views/pantry_list_item.dart';
import 'package:pocket_kitchen/views/pantry_list_views/unavailable_pantry_item.dart';

import '../sign_in_sign_up_views/signin_view.dart';

class PantryListView extends StatefulWidget {
  const PantryListView({super.key});

  @override
  State<StatefulWidget> createState() => PantryListViewState();

}
class PantryListViewState extends State<PantryListView> {
  static const drawerIcon = Color(0xff459657);
  static const drawerStyle = TextStyle(fontSize: 20, color: Color(0xff459657));


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: const Color(0xff459657),
            title: const Text('Pocket Kitchen'),
            actions: [
              IconButton(
            onPressed: () {
              signOutDialog();
            },
            icon: const Icon(Icons.exit_to_app_sharp),
            tooltip: 'Sign Out',
          ),
    ]
        ),
        body: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget> [
           Padding(
             padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
             child: TextField(
               onChanged: (value){

               },
               controller: TextEditingController(),

               decoration: const InputDecoration(
                 filled: true,
                   fillColor: Colors.white,
                   hintText: "Search",
                   prefixIcon: Icon(Icons.search, color: Colors.black38,),
                   enabledBorder: OutlineInputBorder(
                     borderSide: BorderSide(
                       width: 1.0,
                       color: Colors.grey,
                     ),
                   ),

                 focusedBorder: OutlineInputBorder(
                   borderSide: BorderSide(width: 2.0, color: Colors.black38,)
                 )

               ),
             ),
           ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Text("Available", style: TextStyle(fontSize: 15, color: Color(0xff459657)),),
            ),
            Expanded(child: ListView.builder(itemBuilder: (context, index){
              return PantryListItem(onLongPress: () {

              });
            }
            )
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Text("Unavailable", style: TextStyle(fontSize: 15, color: Color(0xff9E4848)),),
            ),
            
            Expanded(child: ListView.builder(itemBuilder: (context, index){
              return const UnavailablePantryItem();
            }
            )
            )

          ],
        ),
        drawer: Drawer(
            elevation: 1.5,
            child: Column(children: <Widget>[
              DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ), child: Image.asset("lib/assets/logo.png")),
              Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      ListTile(
                        title: const Text('Create Pantry', style: drawerStyle,),
                        leading: const Icon(Icons.add_circle_outline, color: drawerIcon,),
                        onTap: () {},
                      ),
                      ListTile(
                        title: const Text('Join Pantry', style: drawerStyle,),
                        leading: const Icon(Icons.exit_to_app, color: drawerIcon,),
                        onTap: () {},
                      ),
                      ListTile(
                          title: const Text('Delete Pantry', style: drawerStyle,),
                          leading: const Icon(Icons.delete_forever_rounded, color: drawerIcon,),
                          onTap: () {}
                      ),
                      ListTile(
                          title: const Text('Leave Pantry', style: drawerStyle,),
                          leading: const Icon(Icons.arrow_back, color: drawerIcon,),
                          onTap: () {}
                      ),
                      ListTile(
                          title: const Text('Switch Pantry', style: drawerStyle,),
                          leading: const Icon(Icons.swap_calls, color: drawerIcon,),
                          onTap: () {}
                      )
                    ],
                  )),
             const Divider(),
              Container(
                  padding: const EdgeInsets.all(10),
                  height: 100,
                  child: const ListTile(
                      title: Text("pantryName!", style: drawerStyle,),
                      leading: Icon(Icons.desktop_windows_sharp, color: drawerIcon,),
                  )

              ),

            ])),

    );
  }

  Future signOutDialog() => showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (context, setState) =>
              AlertDialog(
                content:
                const Text(
                  "Are you sure you want to sign out?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xff7B7777),
                      fontWeight: FontWeight.w400
                  ),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          sharedPrefs.userId = "";
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignInView()),
                          );
                        },
                        style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(Color(0xff459657)),
                        ),
                        child:
                        const Text(
                          "Sign Out",
                          style: TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                              fontWeight: FontWeight.w400
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
      )
  );
}