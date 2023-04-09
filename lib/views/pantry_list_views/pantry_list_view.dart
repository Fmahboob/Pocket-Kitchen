import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pocket_kitchen/models/app_models/shared_preferences.dart';
import 'package:pocket_kitchen/views/pantry_list_views/pantry_list_item.dart';
import 'package:pocket_kitchen/views/pantry_list_views/unavailable_pantry_item.dart';
import 'package:pocket_kitchen/views/google_sign_in_view.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import '../../main.dart';
import '../../models/app_models/database.dart';
import '../../models/app_models/google_sign_in_api.dart';
import '../../models/data_models/food.dart';
import '../../models/data_models/pantry.dart';
import '../../models/data_models/pantry_food.dart';

abstract class PantryState<T extends StatefulWidget> extends State {
  @override
  void initState() {
    super.initState();
  }
}

class PantryListView extends StatefulWidget {
  const PantryListView({super.key});

  @override
  State<StatefulWidget> createState() => PantryListViewState();
}

class PantryListViewState extends PantryState<PantryListView> {
  final TextEditingController createNameController = TextEditingController();
  final TextEditingController joinNameController = TextEditingController();
  final TextEditingController joinIdController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String searchTerm = "";

  String pantryId = sharedPrefs.currentPantry;
  String pantryName = sharedPrefs.currentPantryName;

  String pantry2Name = "";
  String pantry2OwnerId = "";

  String pantry3Name = "";
  String pantry3OwnerId = "";

  String userCount = "";

  String issueMessage = "";

  static const drawerGreenIcon = Color(0xff459657);
  static const drawerGreyIcon = Color(0xff7B7777);

  static const drawerGreenStyle = TextStyle(fontSize: 20, color: Color(0xff459657));
  static const drawerGreyStyle = TextStyle(fontSize: 20, color: Color(0xff7B7777));

  //Non-matching retrieved name to inputted name on pantry joining snackbar
  final nonMatchSnackBar = const SnackBar(
    content: Text("The Pantry Name and Number do not match."),
  );

  Future sendEmail ({
    required String toEmail,
    required String body,
    required String subject
  }) async {
    final serviceId = "service_q7nwxas";
    final templateId = "template_urdi0mi";
    final userId = "O8xDFSkMu9GTHepJo";
    final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({
        "service_id": serviceId,
        "user_id": userId,
        "template_id": templateId,
        "template_params" : {
          "toEmail": toEmail,
          "body": body,
          "subject": subject
        }
      }),
    );
  }

  //Pantry CRUD methods
  _createPantry(String name, String ownerId) {
    Database.createPantry(name, ownerId);
  }

  Future<Pantry> _getPantry(String id, String name, String ownerId, String qualifier) {
    return Database.getPantry(id, name, ownerId, qualifier);
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

  //PantryFood CRUD Methods
  _updatePantryFood(String id, String amount, String pantryId, String foodId) {
    Database.updatePantryFood(id, amount, pantryId, foodId);
  }

  _getPantryFood (String foodId) {
    Database.getPantryFood(foodId);
  }

  Future<List<PantryFood>> _getPantryFoods(String pantryId) {
    return Database.getAllPantryFoods(pantryId);
  }

  //Food CRUD Methods
  Future<Food> _getFood(String barcode, String name, String id, String weight, String qualifier) {
    return Database.getFood(barcode, name, id, weight, qualifier);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                         onChanged: (String search) {
                           setState(() {
                             searchTerm = search;
                           });
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
                               itemCount: sharedPrefs.getAllListsFiltered(searchTerm)[0].length,
                               itemBuilder: (context, index) {
                                 return PantryListItem(
                                     pantryFood: sharedPrefs.getAllListsFiltered(searchTerm)[0][index],
                                     food: sharedPrefs.getAllListsFiltered(searchTerm)[2][index],
                                     index: index,
                                     onLongPress: () {
                                      manualEmptyDialog(sharedPrefs.getAllListsFiltered(searchTerm)[0][index], sharedPrefs.getAllListsFiltered(searchTerm)[2][index], index);
                                     });
                               },
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
                              itemCount: sharedPrefs.getAllListsFiltered(searchTerm)[1].length,
                              itemBuilder: (context, index) {
                                return UnavailablePantryItem(
                                    pantryFood: sharedPrefs.getAllListsFiltered(searchTerm)[1][index],
                                    food: sharedPrefs.getAllListsFiltered(searchTerm)[3][index],
                                    index: index,
                                    onLongPress: () {
                                      manualRestockDialog(sharedPrefs.getAllListsFiltered(searchTerm)[1][index], sharedPrefs.getAllListsFiltered(searchTerm)[3][index], index);
                                    },
                                );
                              }
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
                        onTap: () async {

                          //get 2nd pantry name
                          Pantry pantry2 = await _getPantry(sharedPrefs.pantries[1], "", "", Database.idQual);

                          //set 2nd pantry name
                          pantry2Name = pantry2.name ?? "";

                          if (sharedPrefs.pantries[2] == "") {
                            print(createNameController.text);
                            print(pantry2Name);
                            print(sharedPrefs.currentPantryName);
                            createPantryDialog();
                          } else {
                            issueMessage = "You already have 3 pantries. Leave or delete a pantry to create another one.";
                            issueDialog();
                          }
                        },
                      ),
                      ListTile(
                        title: const Text('Join Pantry', style: drawerGreenStyle),
                        leading: const Icon(Icons.exit_to_app, color: drawerGreenIcon,),
                        onTap: () {
                          if (sharedPrefs.pantries[2] == "") {
                            joinPantryDialog();
                          } else {
                            issueMessage = "You already have 3 pantries. Leave or delete a pantry to join another one.";
                            issueDialog();
                          }
                        },
                      ),
                      ListTile(
                          title: Text('Delete Pantry', style: sharedPrefs.ownsCurrentPantry() ? drawerGreyStyle : drawerGreenStyle),
                          leading: Icon(Icons.delete_forever_rounded, color: sharedPrefs.ownsCurrentPantry() ? drawerGreyIcon: drawerGreenIcon,),
                          onTap: () async {
                            //get current pantry for its ownerId
                            if (sharedPrefs.ownsCurrentPantry() == false) {
                              //get 2nd pantry name
                              Pantry pantry2 = await _getPantry(sharedPrefs.pantries[1], "", "", Database.idQual);
                              Pantry currPantry = await _getPantry(sharedPrefs.pantries[0], "", "", Database.idQual);
                              //set 2nd pantry name
                              pantry2Name = pantry2.name ?? "";
                              pantry2OwnerId = pantry2.ownerId ?? "";
                              userCount = currPantry.userCount ?? "";

                              deletePantryDialog();
                            } else {
                              issueMessage = "You must own the pantry to delete it.";
                              issueDialog();
                            }
                          }
                      ),
                      ListTile(
                          title: Text('Leave Pantry', style: sharedPrefs.ownsCurrentPantry() ? drawerGreenStyle : drawerGreyStyle),
                          leading: Icon(Icons.arrow_back, color: sharedPrefs.ownsCurrentPantry() ? drawerGreenIcon : drawerGreyIcon),
                          onTap: () async {
                            if (sharedPrefs.ownsCurrentPantry() == true) {
                              //get 2nd pantry name
                              Pantry pantry2 = await _getPantry(sharedPrefs.pantries[1], "", "", Database.idQual);

                              //set 2nd pantry name
                              pantry2Name = pantry2.name ?? "";
                              pantry2OwnerId = pantry2.ownerId ?? "";

                              leavePantryDialog();
                            } else {
                              issueMessage = "You cannot leave a pantry you own.";
                              issueDialog();
                            }
                          }
                      ),
                      ListTile(
                          title: const Text('Switch Pantry', style: drawerGreenStyle,),
                          leading: const Icon(Icons.swap_calls, color: drawerGreenIcon,),
                          onTap: () async {

                            if (sharedPrefs.secondPantryExists) {
                              //get 2nd pantry name
                              Pantry pantry2 = await _getPantry(sharedPrefs.pantries[1], "", "", Database.idQual);

                              //set 2nd pantry name
                              pantry2Name = pantry2.name ?? "";
                              pantry2OwnerId = pantry2.ownerId ?? "";

                              //get 3rd pantry name
                              Pantry pantry3 = await _getPantry(sharedPrefs.pantries[2], "", "", Database.idQual);

                              //set 2nd pantry name
                              pantry3Name = pantry3.name ?? "";
                              pantry3OwnerId = pantry3.ownerId ?? "";

                              switchPantryDialog();
                            } else {
                              issueMessage = "You don't have any pantries to switch to.";
                              issueDialog();
                            }
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

                          //reset user id
                          sharedPrefs.userId = "";

                          //reset user email
                          sharedPrefs.userEmail = "";

                          //reset current pantry owner id
                          sharedPrefs.currentPantryOwner = "";

                          //reset current pantry name
                          sharedPrefs.currentPantryName = "";

                          //remove pantries from local storage
                          if (sharedPrefs.currentPantry != "") {
                            sharedPrefs.removeCurrentPantry();
                            if(sharedPrefs.currentPantry != "") {
                              sharedPrefs.removeCurrentPantry();
                              if (sharedPrefs.currentPantry != "") {
                                sharedPrefs.removeCurrentPantry();
                              }
                            }
                          }

                          //remove all pantry foods and foods from local storage
                          sharedPrefs.foodList = [];
                          sharedPrefs.pantryFoodList = [];

                          Navigator.pop(context);
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

                            //check that you don't have a pantry with this name
                            if (createNameController.text != pantry2Name && createNameController.text != sharedPrefs.currentPantryName) {
                              //create the pantry
                              await _createPantry(createNameController.text, sharedPrefs.userId);

                              //get new pantry id
                              Pantry newPantry = await _getPantry("", createNameController.text, sharedPrefs.userId, Database.bothQual);

                              //create new pantry_user
                              await _createPantryUser(newPantry.id!, sharedPrefs.userId);

                              //add new pantry id and name to local storage
                              sharedPrefs.addNewPantry(newPantry.id!);
                              sharedPrefs.currentPantryName = newPantry.name!;
                              sharedPrefs.currentPantryOwner = newPantry.ownerId!;

                              //update pantry foods
                              sharedPrefs.pantryFoodList = [];
                              sharedPrefs.foodList = [];

                              if (sharedPrefs.currentPantry != "") {
                                List<Food> foods = [];

                                List<PantryFood> pantryFoods = await _getPantryFoods(sharedPrefs.currentPantry);

                                for (PantryFood pantryFood in pantryFoods) {
                                  Food food = await _getFood("", "", pantryFood.foodId!, "", Database.idQual);
                                  foods.add(food);
                                }

                                sharedPrefs.pantryFoodList = pantryFoods;
                                sharedPrefs.foodList = foods;

                                //update user with email
                                String body = "\'" + createNameController.text + "\' was successfully created. It\'s Pantry Number is " + newPantry.id! + ". Thank you for using Pocket Kitchen!";
                                String subject = "Pantry created successfully.";

                                sendEmail(toEmail: sharedPrefs.userEmail, body: body, subject: subject);
                              }

                              Navigator.pop(context);
                              Navigator.pop(context);
                              //push main app
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const TabBarMain(flag: 0)),
                              );
                            } else {
                              createNameController.text = "";
                              Navigator.pop(context);
                              issueMessage = "You have already created a pantry with this name.";
                              issueDialog();
                            }
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
                            Pantry joiningPantry = await _getPantry(joinIdController.text, joinNameController.text, "", Database.idQual);

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
                              sharedPrefs.currentPantryOwner = joiningPantry.ownerId!;

                              //update pantry foods
                              sharedPrefs.pantryFoodList = [];
                              sharedPrefs.foodList = [];

                              if (sharedPrefs.currentPantry != "") {
                                List<Food> foods = [];

                                List<PantryFood> pantryFoods = await _getPantryFoods(sharedPrefs.currentPantry);

                                for (PantryFood pantryFood in pantryFoods) {
                                  Food food = await _getFood("", "", pantryFood.foodId!, "", Database.idQual);
                                  foods.add(food);
                                }

                                sharedPrefs.pantryFoodList = pantryFoods;
                                sharedPrefs.foodList = foods;
                              }

                              //update user with email
                              String body = "\'" + joinNameController.text + "\' was successfully joined. Thank you for using Pocket Kitchen!";
                              String subject = "Pantry joined successfully.";

                              sendEmail(toEmail: sharedPrefs.userEmail, body: body, subject: subject);

                              Navigator.pop(context);
                              Navigator.pop(context);
                              //push main app
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const TabBarMain(flag: 0)),
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
                  "Are you sure you want to delete your pantry '$pantryName'? $userCount user(s) use this pantry.",
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
                          sharedPrefs.currentPantryOwner = pantry2OwnerId;

                          //update pantry foods
                          sharedPrefs.pantryFoodList = [];
                          sharedPrefs.foodList = [];

                          if (sharedPrefs.currentPantry != "") {
                            List<Food> foods = [];

                            List<PantryFood> pantryFoods = await _getPantryFoods(sharedPrefs.currentPantry);

                            for (PantryFood pantryFood in pantryFoods) {
                              Food food = await _getFood("", "", pantryFood.foodId!, "", Database.idQual);
                              foods.add(food);
                            }

                            sharedPrefs.pantryFoodList = pantryFoods;
                            sharedPrefs.foodList = foods;
                          }

                          //update user with email
                          String body = "A pantry was successfully deleted. This pantry is gone forever. Thank you for using Pocket Kitchen!";
                          String subject = "Pantry deleted successfully.";

                          sendEmail(toEmail: sharedPrefs.userEmail, body: body, subject: subject);

                          Navigator.pop(context);
                          Navigator.pop(context);

                          //repush main app
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const TabBarMain(flag: 0)),
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
                          Pantry leavePantry = await _getPantry(sharedPrefs.currentPantry, "", "", Database.idQual);

                          //update user count
                          int userCount = (leavePantry.userCount as int) - 1;

                          //update pantry's user count
                          await _updatePantry(leavePantry.id!, leavePantry.name!, userCount.toString(), leavePantry.ownerId!);

                          //remove Pantry_User
                          await _deletePantryUser(sharedPrefs.currentPantry, sharedPrefs.userId);

                          //remove pantry from local storage
                          sharedPrefs.removeCurrentPantry();
                          sharedPrefs.currentPantryName = pantry2Name;
                          sharedPrefs.currentPantryOwner = pantry2OwnerId;

                          //update pantry foods
                          sharedPrefs.pantryFoodList = [];
                          sharedPrefs.foodList = [];

                          if (sharedPrefs.currentPantry != "") {
                            List<Food> foods = [];

                            List<PantryFood> pantryFoods = await _getPantryFoods(sharedPrefs.currentPantry);

                            for (PantryFood pantryFood in pantryFoods) {
                              Food food = await _getFood("", "", pantryFood.foodId!, "", Database.idQual);
                              foods.add(food);
                            }

                            sharedPrefs.pantryFoodList = pantryFoods;
                            sharedPrefs.foodList = foods;
                          }

                          //update user with email
                          String body = "A pantry was successfully left. You can rejoin at any time with the valid Pantry Name and Number. Thank you for using Pocket Kitchen!";
                          String subject = "Pantry left successfully.";

                          sendEmail(toEmail: sharedPrefs.userEmail, body: body, subject: subject);

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
                              onPressed: () async {

                                //update current pantry (2 means 2nd pantry was selected as new current)
                                sharedPrefs.switchCurrentPantry(2);
                                sharedPrefs.currentPantryName = pantry2Name;
                                sharedPrefs.currentPantryOwner = pantry2OwnerId;

                                //update pantry foods
                                sharedPrefs.pantryFoodList = [];
                                sharedPrefs.foodList = [];

                                if (sharedPrefs.currentPantry != "") {
                                  List<Food> foods = [];

                                  List<PantryFood> pantryFoods = await _getPantryFoods(sharedPrefs.currentPantry);

                                  for (PantryFood pantryFood in pantryFoods) {
                                    Food food = await _getFood("", "", pantryFood.foodId!, "", Database.idQual);
                                    foods.add(food);
                                  }

                                  sharedPrefs.pantryFoodList = pantryFoods;
                                  sharedPrefs.foodList = foods;
                                }

                                Navigator.pop(context);
                                Navigator.pop(context);

                                //repush main app
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const TabBarMain(flag: 0)),
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
                                onPressed: () async {

                                  //update current pantry (3 means 3rd pantry was selected as new current)
                                  sharedPrefs.switchCurrentPantry(3);
                                  sharedPrefs.currentPantryName = pantry3Name;
                                  sharedPrefs.currentPantryOwner = pantry3OwnerId;

                                  //update pantry foods
                                  sharedPrefs.pantryFoodList = [];
                                  sharedPrefs.foodList = [];

                                  if (sharedPrefs.currentPantry != "") {
                                    List<Food> foods = [];

                                    List<PantryFood> pantryFoods = await _getPantryFoods(sharedPrefs.currentPantry);

                                    for (PantryFood pantryFood in pantryFoods) {
                                      Food food = await _getFood("", "", pantryFood.foodId!, "", Database.idQual);
                                      foods.add(food);
                                    }

                                    sharedPrefs.pantryFoodList = pantryFoods;
                                    sharedPrefs.foodList = foods;
                                  }

                                  Navigator.pop(context);
                                  Navigator.pop(context);

                                  //repush main app
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const TabBarMain(flag: 0)),
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
                        ],
                      ),
                    ],
                  ),
                ],
              )
      )
  );

  Future issueDialog() => showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (context, setState) =>
              AlertDialog(
                content:
                Text(
                  issueMessage,
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
                          Navigator.pop(context);
                        },
                        style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(Color(0xff459657)),
                        ),
                        child:
                        const Text(
                          "OK",
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

  Future manualEmptyDialog(PantryFood pantryFood, Food food, int index) => showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (context, setState) =>
              AlertDialog(
                content:
                const Text(
                  "Are you sure this item is completely out of stock?",
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
                          _updatePantryFood(pantryFood.id!, "0", pantryFood.pantryId!, pantryFood.foodId!);

                          List<PantryFood> pantryFoodsList = sharedPrefs.pantryFoodList;

                          for (PantryFood aPantryFood in pantryFoodsList) {
                            if (aPantryFood.id == pantryFood.id) {
                              aPantryFood.amount = "0";
                            }
                          }

                          sharedPrefs.pantryFoodList = pantryFoodsList;

                          Navigator.pop(context);

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const TabBarMain(flag: 0)),
                          );
                        },
                        style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(Color(0xff459657)),
                        ),
                        child:
                        const Text(
                          "Out of Stock",
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

  Future manualRestockDialog(PantryFood pantryFood, Food food, int index) => showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (context, setState) =>
              AlertDialog(
                content:
                const Text(
                  "Are you sure you want to manually restock this item?",
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

                          if (food.ownUnit == "0") {
                            //update the availability to full (100%/1)
                            await _updatePantryFood(pantryFood.id!, "1", pantryFood.pantryId!, pantryFood.foodId!);

                            List<PantryFood> pantryFoodsList = sharedPrefs.pantryFoodList;

                            for (PantryFood aPantryFood in pantryFoodsList) {
                              if (aPantryFood.id == pantryFood.id) {
                                aPantryFood.amount = "1";
                              }
                            }

                            sharedPrefs.pantryFoodList = pantryFoodsList;
                          } else {
                            //update the availability to full (100% of food weight)
                            await _updatePantryFood(pantryFood.id!, food.weight!, pantryFood.pantryId!, pantryFood.foodId!);

                            List<PantryFood> pantryFoodsList = sharedPrefs.pantryFoodList;

                            for (PantryFood aPantryFood in pantryFoodsList) {
                              if (aPantryFood.id == pantryFood.id) {
                                aPantryFood.amount = food.weight;
                              }
                            }
                            sharedPrefs.pantryFoodList = pantryFoodsList;
                          }

                          Navigator.pop(context);

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const TabBarMain(flag: 0)),
                          );
                        },
                        style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(Color(0xff459657)),
                        ),
                        child:
                        const Text(
                          "Restock",
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