import 'package:flutter/material.dart';
import 'package:pocket_kitchen/views/sign_in_sign_up_views/signup_view.dart';
import 'package:pocket_kitchen/models/app_models/shared_preferences.dart';

import '../../models/app_models/database.dart';
import '../../main.dart';
import '../../models/data_models/user.dart';
import '../models/app_models/google_sign_in_api.dart';

class GoogleSignInView extends StatefulWidget {
  const GoogleSignInView({super.key});

  @override
  GoogleSignInViewState createState() => GoogleSignInViewState();
}

class GoogleSignInViewState extends State<GoogleSignInView> {

  Future<User> _getUser(String id, email, qualifier) async {
    return Database.getUser(id, email, qualifier);
  }

  Future signIn() async {
    await GoogleSignInAPI.login();
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                          "Sign In with Google",
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
                            /*
                      //check that password matches confirmed password
                      if (passwordController.text == confPasswordController.text) {
                        //get the user's account details
                        User user = await _getUser("", emailController.text, Database.emailQual);

                        //check that the email/account exists
                        if (user.email != null && user.email != "" && user.email != " ") {
                          //store user id in local storage
                          sharedPrefs.userId = user.id!;
                          //load the app
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const TabBarMain()),
                          );
                          print(sharedPrefs.userId);
                          //if the email doesn't exist
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(emailNonExistSnackBar);
                        }
                        //if passwords don't match
                      }
                       */
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
                ],
              ),
          ),
        );
}