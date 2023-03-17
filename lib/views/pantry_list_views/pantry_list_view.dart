import 'package:flutter/material.dart';
import 'package:pocket_kitchen/models/app_models/shared_preferences.dart';
import 'package:pocket_kitchen/views/pantry_list_views/pantry_list_item.dart';
import 'package:pocket_kitchen/views/pantry_list_views/unavailable_pantry_item.dart';
import 'package:pocket_kitchen/views/google_sign_in_view.dart';

import '../../models/app_models/google_sign_in_api.dart';

class PantryListView extends StatefulWidget {
  const PantryListView({super.key});

  @override
  State<StatefulWidget> createState() => PantryListViewState();

}
class PantryListViewState extends State<PantryListView> {
  final TextEditingController createNameController = TextEditingController();
  final TextEditingController joinNameController = TextEditingController();
  final TextEditingController joinIdController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String pantryName = "Robbie's Home";
  String pantryId = "154";
  String pantry2Name = "Robbie's Cottage";
  String pantry3Name = "Sarah's Home";

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
                        onTap: () {
                          createPantryDialog();
                        },
                      ),
                      ListTile(
                        title: const Text('Join Pantry', style: drawerStyle,),
                        leading: const Icon(Icons.exit_to_app, color: drawerIcon,),
                        onTap: () {
                          joinPantryDialog();
                        },
                      ),
                      ListTile(
                          title: const Text('Delete Pantry', style: drawerStyle,),
                          leading: const Icon(Icons.delete_forever_rounded, color: drawerIcon,),
                          onTap: () {
                            deletePantryDialog();
                          }
                      ),
                      ListTile(
                          title: const Text('Leave Pantry', style: drawerStyle,),
                          leading: const Icon(Icons.arrow_back, color: drawerIcon,),
                          onTap: () {
                            leavePantryDialog();
                          }
                      ),
                      ListTile(
                          title: const Text('Switch Pantry', style: drawerStyle,),
                          leading: const Icon(Icons.swap_calls, color: drawerIcon,),
                          onTap: () {
                            switchPantryDialog();
                          }
                      )
                    ],
                  )),
             const Divider(),
              Container(
                  padding: const EdgeInsets.all(10),
                  height: 100,
                  child:
                  ListTile(
                      title: Text("$pantryName #$pantryId", style: drawerStyle,),
                      leading: const Icon(Icons.inventory_2_outlined, color: drawerIcon,),
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
                        onPressed: () async {
                          await GoogleSignInAPI.logout();
                          sharedPrefs.userId = "";
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const GoogleSignInView()),
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

  Future createPantryDialog() => showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (context, setState) =>
              AlertDialog(
                title:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                        "Create a Pantry",
                        style: TextStyle(
                            fontSize: 32,
                            color: Color(0xff7B7777),
                            fontWeight: FontWeight.w400
                        )
                    ),
                  ],
                ),
                content:
                    Form(
                      key: _formKey,
                      child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: createNameController,
                            validator: (value) {
                              if (value == "" || value == " " || value!.isEmpty) {
                                return "Please enter a pantry name";
                              }
                            },
                            enabled: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 3, color: Color(0xff7B7777))
                              ),
                              hintText: "Pantry Name",
                              contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          if(_formKey.currentState!.validate()) {
                            //create pantry logic
                            Navigator.pop(context);
                          }
                        },
                        style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(Color(0xff459657)),
                        ),
                        child:
                        const Text(
                          "Create",
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

  Future joinPantryDialog() => showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (context, setState) =>
              AlertDialog(
                title:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                        "Join a Pantry",
                        style: TextStyle(
                            fontSize: 32,
                            color: Color(0xff7B7777),
                            fontWeight: FontWeight.w400
                        )
                    ),
                  ],
                ),
                content:
                    Form(
                      key: _formKey,
                      child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: joinNameController,
                            validator: (value) {
                              if (value == "" || value == " " || value!.isEmpty) {
                                return "Please enter a pantry name";
                              }
                            },
                            enabled: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 3, color: Color(0xff7B7777))
                              ),
                              hintText: "Pantry Name",
                              contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                            child:
                            TextFormField(
                              controller: joinIdController,
                              validator: (value) {
                                if (value == "" || value == " " || value!.isEmpty) {
                                  return "Please enter a pantry number";
                                }
                              },
                              enabled: true,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 3, color: Color(0xff7B7777))
                                ),
                                hintText: "Pantry Number",
                                contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          if(_formKey.currentState!.validate()) {
                            //join pantry logic
                            Navigator.pop(context);
                          }
                        },
                        style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(Color(0xff459657)),
                        ),
                        child:
                        const Text(
                          "Join",
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

  Future deletePantryDialog() => showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (context, setState) =>
              AlertDialog(
                content:
                Text(
                  "Are you sure you want to delete your pantry '$pantryName'?",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
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
                          //delete pantry logic
                          Navigator.pop(context);
                        },
                        style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(Color(0xff459657)),
                        ),
                        child:
                        const Text(
                          "Delete",
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

  Future leavePantryDialog() => showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (context, setState) =>
              AlertDialog(
                content:
                Text(
                  "Are you sure you want to leave the pantry '$pantryName'?",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
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
                          //leave pantry logic
                          Navigator.pop(context);
                        },
                        style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(Color(0xff459657)),
                        ),
                        child:
                        const Text(
                          "Leave",
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

  Future switchPantryDialog() => showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (context, setState) =>
              AlertDialog(
                content:
                Text(
                  "Switch From '$pantryName', to",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Color(0xff7B7777),
                      fontWeight: FontWeight.w400
                  ),
                ),
                actions: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          //switch pantry logic
                          Navigator.pop(context);
                        },
                        style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(Color(0xff459657)),
                        ),
                        child:
                        Text(
                          pantry2Name,
                          style: const TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                              fontWeight: FontWeight.w400
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                        child:
                        TextButton(
                          onPressed: () {
                            //switch pantry logic
                            Navigator.pop(context);
                          },
                          style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(Color(0xff459657)),
                          ),
                          child:
                          Text(
                            pantry3Name,
                            style: const TextStyle(
                                fontSize: 32,
                                color: Colors.white,
                                fontWeight: FontWeight.w400
                            ),
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