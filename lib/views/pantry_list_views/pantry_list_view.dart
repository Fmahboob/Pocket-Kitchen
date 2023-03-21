import 'package:flutter/material.dart';
import 'package:pocket_kitchen/models/app_models/shared_preferences.dart';
import 'package:pocket_kitchen/views/pantry_list_views/create_join_pantry_screen.dart';
import 'package:pocket_kitchen/views/pantry_list_views/pantry_list_item.dart';
import 'package:pocket_kitchen/views/pantry_list_views/unavailable_pantry_item.dart';
import 'package:pocket_kitchen/views/google_sign_in_view.dart';

import '../../main.dart';
import '../../models/app_models/database.dart';
import '../../models/app_models/google_sign_in_api.dart';
import '../../models/data_models/pantry.dart';

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

  String pantryId = sharedPrefs.currentPantry;
  String pantryName = sharedPrefs.currentPantryName;
  String pantry2Name = "";
  String pantry3Name = "";

  static const drawerGreenIcon = Color(0xff459657);
  static const drawerGreyIcon = Color(0xff7B7777);

  static const drawerGreenStyle = TextStyle(fontSize: 20, color: Color(0xff459657));
  static const drawerGreyStyle = TextStyle(fontSize: 20, color: Color(0xff7B7777));

  //Non-matching retrieved name to inputted name on pantry joining snackbar
  final nonMatchSnackBar = const SnackBar(
    content: Text("The Pantry Name and Number do not match."),
  );

  //Pantry CRUD methods
  _createPantry(String name, String ownerId) {
    Database.createPantry(name, ownerId);
  }

  Future<Pantry> _getPantry(String id, String name, String qualifier) {
    return Database.getPantry(id, name, qualifier);
  }

  _updatePantry(String id, String name, String userCount, String ownerId) {
    Database.updatePantry(id, name, userCount, ownerId);
  }

  _deletePantry(String id) {
    Database.deletePantry(id);
  }

  //Pantry_User CRUD methods
  _createPantryUser(String pantryId, String userId) {
    Database.createPantryUser(pantryId, userId);
  }

  _deletePantryUser(String pantryId, String userId) {
    Database.deletePantryUser(pantryId, userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: const Color(0xff459657),
            title: Text(sharedPrefs.currentPantryName),
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(

                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget> [
                     Padding(
                       padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                       child: TextField(
                         enabled: true,
                         onChanged: (String input) {
                           //searchTerm = input;
                         },
                         decoration: const InputDecoration(
                             border: OutlineInputBorder(
                                 borderSide: BorderSide(width: 3, color: Color(0xff7B7777))
                             ),
                             hintText: "Search",
                             contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                             prefixIcon: Icon(Icons.search)
                         ),
                       ),
                     ),

                      const Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
                        child: Text("Available", style: TextStyle(
                            fontSize: 17,
                            color: Color(0xff459657),
                            fontWeight: FontWeight.w600
                        ),),
                      ),

                         ListView.builder(
                           shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index){
                          return PantryListItem(onLongPress: () {

                          });
                        },
                           itemCount: 10,
                        ),


                      const Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
                        child: Text("Unavailable", style: TextStyle(
                            fontSize: 17,
                            color: Color(0xff9E4848),
                            fontWeight: FontWeight.w600
                        ),),
                      ),

                       ListView.builder(
                           shrinkWrap: true,
                           physics: const NeverScrollableScrollPhysics(),
                           itemBuilder: (context, index){
                          return const UnavailablePantryItem();
                        },
                         itemCount: 10,
                        ),



                    ],
                  ),
          ),
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
                        title: const Text('Create Pantry', style: drawerGreenStyle,),
                        leading: const Icon(Icons.add_circle_outline, color: drawerGreenIcon,),
                        onTap: () {
                          createPantryDialog();
                        },
                      ),
                      ListTile(
                        title: const Text('Join Pantry', style: drawerGreenStyle),
                        leading: const Icon(Icons.exit_to_app, color: drawerGreenIcon,),
                        onTap: () {
                          joinPantryDialog();
                        },
                      ),
                      ListTile(
                          title: Text('Delete Pantry', style: sharedPrefs.ownsCurrentPantry("3") ? drawerGreyStyle : drawerGreenStyle),
                          leading: Icon(Icons.delete_forever_rounded, color: sharedPrefs.ownsCurrentPantry("3") ? drawerGreyIcon: drawerGreenIcon,),
                          onTap: () async {
                            if (sharedPrefs.ownsCurrentPantry("3") == false) {
                              //get 2nd pantry name
                              Pantry pantry2 = await _getPantry(sharedPrefs.pantries[1], "", Database.idQual);

                              //set 2nd pantry name
                              pantry2Name = pantry2.name ?? "";

                              deletePantryDialog();
                            }
                          }
                      ),
                      ListTile(
                          title: Text('Leave Pantry', style: sharedPrefs.ownsCurrentPantry("3") ? drawerGreenStyle : drawerGreyStyle),
                          leading: Icon(Icons.arrow_back, color: sharedPrefs.ownsCurrentPantry("3") ? drawerGreenIcon : drawerGreyIcon),
                          onTap: () async {
                            print(sharedPrefs.currentPantry);
                            Pantry pantry = await _getPantry("", sharedPrefs.currentPantryName, Database.nameQual);
                            print(pantry.id!);
                            if (sharedPrefs.ownsCurrentPantry("3") == true) {
                              //get 2nd pantry name
                              Pantry pantry2 = await _getPantry(sharedPrefs.pantries[1], "", Database.idQual);

                              //set 2nd pantry name
                              pantry2Name = pantry2.name ?? "";

                              leavePantryDialog();
                            }
                          }
                      ),
                      ListTile(
                          title: const Text('Switch Pantry', style: drawerGreenStyle,),
                          leading: const Icon(Icons.swap_calls, color: drawerGreenIcon,),
                          onTap: () async {

                            //get 2nd pantry name
                            Pantry pantry2 = await _getPantry(sharedPrefs.pantries[1], "", Database.idQual);

                            //set 2nd pantry name
                            pantry2Name = pantry2.name ?? "";

                            //get 3rd pantry name
                            Pantry pantry3 = await _getPantry(sharedPrefs.pantries[2], "", Database.idQual);

                            //set 2nd pantry name
                            pantry3Name = pantry3.name ?? "";

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
                      title: Text("$pantryName #$pantryId", style: drawerGreenStyle,),
                      leading: const Icon(Icons.inventory_2_outlined, color: drawerGreenIcon,),
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

                          //load sign in
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
                        onPressed: () async {
                          if(_formKey.currentState!.validate()) {

                            //create the pantry
                            await _createPantry(createNameController.text, sharedPrefs.userId);

                            //get new pantry id
                            Pantry newPantry = await _getPantry("", createNameController.text, Database.nameQual);

                            //create new pantry_user
                            await _createPantryUser(newPantry.id!, sharedPrefs.userId);

                            //add new pantry id and name to local storage
                            sharedPrefs.addNewPantry(newPantry.id!);
                            sharedPrefs.currentPantryName = newPantry.name!;

                            Navigator.pop(context);
                            Navigator.pop(context);
                            //push main app
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const TabBarMain()),
                            );

                            //reload app
                            //RestartWidget.restartApp(context);
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
                        onPressed: () async {
                          if(_formKey.currentState!.validate()) {
                            //retrieve desired pantry
                            Pantry joiningPantry = await _getPantry(joinIdController.text, joinNameController.text, Database.idQual);

                            //check that name matches inputted name
                            if (joiningPantry.name == joinNameController.text) {

                              //update user count for pantry
                              int userCount = int.parse(joiningPantry.userCount!) + 1;

                              //update pantry
                              _updatePantry(joiningPantry.id!, joiningPantry.name!, userCount.toString(), joiningPantry.ownerId!);

                              //create new pantry_user
                              await _createPantryUser(joiningPantry.id!, sharedPrefs.userId);

                              //add pantry id and name to local storage
                              sharedPrefs.addNewPantry(joiningPantry.id!);
                              sharedPrefs.currentPantryName = joiningPantry.name!;

                              Navigator.pop(context);
                              Navigator.pop(context);
                              //push main app
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const TabBarMain()),
                              );

                              //reload app
                              //RestartWidget.restartApp(context);

                              //if name doesn't match id, inform user with snackbar
                            } else {
                              nonMatchSnackBar;
                              Navigator.pop(context);
                            }
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
                        onPressed: () async {

                          //delete the pantry
                          await _deletePantry(sharedPrefs.currentPantry);

                          //remove it from local storage
                          sharedPrefs.removeCurrentPantry();
                          sharedPrefs.currentPantryName = pantry2Name;

                          Navigator.pop(context);
                          Navigator.pop(context);

                          //repush main app
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const TabBarMain()),
                          );
                          //restart app
                          //RestartWidget.restartApp(context);
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
                        onPressed: () async {

                          //retrieve pantry's user count
                          Pantry leavePantry = await _getPantry(sharedPrefs.currentPantry, "", Database.idQual);

                          //update user count
                          int userCount = (leavePantry.userCount as int) - 1;

                          //update pantry's user count
                          await _updatePantry(leavePantry.id!, leavePantry.name!, userCount.toString(), leavePantry.ownerId!);

                          //remove Pantry_User
                          await _deletePantryUser(sharedPrefs.currentPantry, sharedPrefs.userId);

                          //remove pantry from local storage
                          sharedPrefs.removeCurrentPantry();
                          sharedPrefs.currentPantryName = pantry2Name;

                          Navigator.pop(context);
                          Navigator.pop(context);

                          //repush main app
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const GoogleSignInView()),
                          );
                          //restart app
                          //RestartWidget.restartApp(context);
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
                  "Switch from '$pantryName', to...",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Color(0xff7B7777),
                      fontWeight: FontWeight.w400
                  ),
                ),
                actions: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Visibility(
                            visible: sharedPrefs.secondPantryExists,
                            child:
                            TextButton(
                              onPressed: () {

                                //update current pantry (2 means 2nd pantry was selected as new current)
                                sharedPrefs.switchCurrentPantry(2);
                                sharedPrefs.currentPantryName = pantry2Name;

                                Navigator.pop(context);
                                Navigator.pop(context);

                                //repush main app
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const TabBarMain()),
                                );

                                //restart app
                                //RestartWidget.restartApp(context);
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
                          ),
                          Visibility(
                            visible: sharedPrefs.thirdPantryExists,
                            child:
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                              child:
                              TextButton(
                                onPressed: () {

                                  //update current pantry (3 means 3rd pantry was selected as new current)
                                  sharedPrefs.switchCurrentPantry(3);
                                  sharedPrefs.currentPantryName = pantry3Name;

                                  Navigator.pop(context);
                                  Navigator.pop(context);

                                  //repush main app
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const TabBarMain()),
                                  );

                                  //restart app
                                  //RestartWidget.restartApp(context);
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
                          ),
                          Visibility(
                            visible: !sharedPrefs.secondPantryExists,
                            child:
                            const Text(
                              "There are no pantries to switch to.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xff7B7777),
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              )
      )
  );

}