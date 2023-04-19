import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pocket_kitchen/models/app_models/shared_preferences.dart';
import '../../models/app_models/database.dart';
import '../../main.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import '../../models/data_models/user.dart';
import '../models/app_models/google_sign_in_api.dart';
import '../models/data_models/food.dart';
import '../models/data_models/pantry.dart';
import '../models/data_models/pantry_food.dart';
import '../models/data_models/pantry_user.dart';

class GoogleSignInView extends StatefulWidget {
  const GoogleSignInView({super.key});

  @override
  GoogleSignInViewState createState() => GoogleSignInViewState();
}

class GoogleSignInViewState extends State<GoogleSignInView> {

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

  //User CRUD Methods
  Future<User> _getUser(String id, email, qualifier) async {
    return Database.getUser(id, email, qualifier);
  }

  Future<void> _createUser(String email) async {
    Database.createUser(email);
  }

  //Pantry CRUD Methods
  Future<Pantry> _getPantry(String id, String name, String ownerId, String qualifier) async {
    return Database.getPantry(id, name, ownerId, qualifier);
  }

  //Pantry_Food CRUD Methods
  Future<List<PantryFood>> _getPantryFoods(String pantryId) {
    return Database.getAllPantryFoods(pantryId);
  }

  //Food CRUD Methods
  Future<Food> _getFood(String barcode, String name, String id, String weight, String qualifier) {
    return Database.getFood(barcode, name, id, weight, qualifier);
  }

  //PantryUser CRUD Methods
  Future<List<PantryUser>> _getAllPantryUsers(String userId, String qualifier) {
    return Database.getAllPantryUsers(userId, qualifier);
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

      //set new user email in local storage
      sharedPrefs.userEmail = googleUser.email;

      //update user with email
      String body = "Thank you for using Pocket Kitchen, you have successfully signed up! Please feel free to reply any issues to this email address. Happy eating!";
      String subject = "Welcome to Pocket Kitchen.";

      sendEmail(toEmail: sharedPrefs.userEmail, body: body, subject: subject);

    //if returned email does match (account exists)
    } else {

      //set new user id in local storage
      sharedPrefs.userId = checkUser.id!;

      //set new user email in local storage
      sharedPrefs.userEmail = googleUser.email;

      //get all user pantries
      List<PantryUser> pantryUsers = await _getAllPantryUsers(sharedPrefs.userId, Database.ownerQual);
      List<Pantry> pantries = [];

      for (PantryUser pantryUser in pantryUsers) {
        Pantry pantry = await _getPantry(pantryUser.pantryId!, "", "", Database.idQual);
        pantries.add(pantry);
      }

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
                            "Welcome to Pocket Kitchen! Sign in to get started.",
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
                          SignInButton(
                            Buttons.Google,
                            onPressed: signIn,
                          ),
                        ),
                      ],
                    ),
              ),
        );
}