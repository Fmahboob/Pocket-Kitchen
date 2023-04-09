import 'package:flutter/material.dart';
import 'package:pocket_kitchen/models/app_models/shared_preferences.dart';

import '../../models/app_models/database.dart';
import '../../main.dart';
import '../../models/data_models/user.dart';
import '../models/app_models/google_sign_in_api.dart';
import '../models/data_models/food.dart';
import '../models/data_models/pantry.dart';
import '../models/data_models/pantry_food.dart';

class GoogleSignInView extends StatefulWidget {
  const GoogleSignInView({super.key});

  @override
  GoogleSignInViewState createState() => GoogleSignInViewState();
}

class GoogleSignInViewState extends State<GoogleSignInView> {

  //User CRUD Methods
  Future<User> _getUser(String id, email, qualifier) async {
    return Database.getUser(id, email, qualifier);
  }

  Future<void> _createUser(String email) async {
    Database.createUser(email);
  }

  //Pantry CRUD Methods
  Future<List<Pantry>> _getPantries(String ownerId, String qualifier) async {
    return Database.getAllPantries(ownerId, qualifier);
  }

  //Pantry_Food CRUD Methods
  Future<List<PantryFood>> _getPantryFoods(String pantryId) {
    return Database.getAllPantryFoods(pantryId);
  }

  //Food CRUD Methods
  Future<Food> _getFood(String barcode, String name, String id, String weight, String qualifier) {
    return Database.getFood(barcode, name, id, weight, qualifier);
  }

  Future signIn() async {
    //await GoogleSignInAPI.logout();

    //login user through google API
    final googleUser = await GoogleSignInAPI.login();

    //attempt pulling user with google email to see if exists in our system
    final checkUser = await _getUser("", googleUser!.email, Database.emailQual);

    //if returned email isn't signed in email (doesn't exist yet)
    if (checkUser.email != googleUser.email) {

      //create new user
      await _createUser(googleUser.email);

      //retrieve new user id
      final newUser = await _getUser("", googleUser.email, Database.emailQual);

      //set new user id in local storage
      sharedPrefs.userId = newUser.id!;

    //if returned email does match (account exists)
    } else {

      //set new user id in local storage
      sharedPrefs.userId = checkUser.id!;

      //get users pantries
      List<Pantry> pantries = await _getPantries(sharedPrefs.userId, Database.ownerQual);

      //make sure pantries exist
      if (pantries.isNotEmpty) {
        //set current pantry name
        sharedPrefs.currentPantryName = pantries[0].name!;

        //set current pantry owner
        sharedPrefs.currentPantryOwner = pantries[0].ownerId!;

        //add pantries to local storage
        for (var pantry in pantries) {
          sharedPrefs.addNewPantry(pantry.id!);
        }
      }

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
    }

    //display main app to user
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TabBarMain(flag: 0)),
    );
  }

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: const Color(0xff459657),
            title: const Text('Pocket Kitchen')
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
          child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                            "Link Pocket Kitchen with your Google account.",
                            maxLines: 4,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 32,
                                color: Color(0xff7B7777),
                                fontWeight: FontWeight.w500
                            )
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 72.0, 0.0, 64.0),
                          child:
                          TextButton(
                            onPressed: signIn,
                            style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(Color(0xff459657)),
                            ),
                            child:
                            const Text(
                              "Google Sign In",
                              style: TextStyle(
                                  fontSize: 28,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
              ),
        );
}