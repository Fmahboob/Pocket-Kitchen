
import 'package:flutter/material.dart';
import 'package:pocket_kitchen/main.dart';

import '../../models/app_models/database.dart';
import '../../models/app_models/shared_preferences.dart';
import '../../models/data_models/pantry.dart';

class NoPantryView extends StatefulWidget {
  const NoPantryView({super.key});

  @override
  State<StatefulWidget> createState() => NoPantryViewState();

}

class NoPantryViewState extends State<NoPantryView> {
  final TextEditingController createNameController = TextEditingController();
  final TextEditingController joinNameController = TextEditingController();
  final TextEditingController joinIdController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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

  //Pantry_User CRUD methods
  _createPantryUser(String pantryId, String userId) {
    Database.createPantryUser(pantryId, userId);
  }

  //Non-matching retrieved name to inputted name on pantry joining snackbar
  final nonMatchSnackBar = const SnackBar(
    content: Text("The Pantry Name and Number do not match."),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xff459657),
          title: const Text('Pocket Kitchen'),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(50, 200, 50, 50),
                child: Text("We have nothing to track!", style: TextStyle(
                  fontSize: 30,
                  color: Colors.black45,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(25, 50, 25, 0),
                child: Row(
                  children: [
                    TextButton(onPressed: () {
                      createPantryDialog();
        }, child: const Text("Create", style: TextStyle(
                      fontSize: 30,
                      color: Colors.black45,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                    ),
                    ),
                    ),
                  const Text("or", style: TextStyle(
                    fontSize: 30,
                    color: Colors.black45,
                    fontWeight: FontWeight.w500,
                  ),
                  ),
                  TextButton(onPressed: () {
                    joinPantryDialog();
                  }, child: const Text("Join", style: TextStyle(
                    fontSize: 30,
                    color: Colors.black45,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                  ),)),
                    const Text("a pantry", style: TextStyle(
                      fontSize: 30,
                      color: Colors.black45,
                      fontWeight: FontWeight.w500,
                    ),
                    ),
                  ],

                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(50, 0, 50, 50),
                child: Text("to get started.", style: TextStyle(
                  fontSize: 30,
                  color: Colors.black45,
                  fontWeight: FontWeight.w500,
                ),),
              ),
            ],
          ),

        )
    );
  }

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

                            //add new pantry id to local storage
                            sharedPrefs.addNewPantry(newPantry.id!);

                            //reload app
                            RestartWidget.restartApp(context);
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
                              int userCount = (joiningPantry.userCount! as int) + 1;

                              //update pantry
                              _updatePantry(joiningPantry.id!, joiningPantry.name!, userCount.toString(), joiningPantry.ownerId!);

                              //create new pantry_user
                              await _createPantryUser(joiningPantry.id!, sharedPrefs.userId);

                              //add pantry id to local storage
                              sharedPrefs.addNewPantry(joiningPantry.id!);

                              //reload app
                              RestartWidget.restartApp(context);

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
}