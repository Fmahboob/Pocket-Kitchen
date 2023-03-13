import 'package:flutter/material.dart';
import 'package:pocket_kitchen/views/signin_view.dart';
import 'package:pocket_kitchen/shared_preferences.dart';

import '../database.dart';
import '../main.dart';
import '../models/user.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  SignUpViewState createState() => SignUpViewState();
}

class SignUpViewState extends State<SignUpView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confPasswordController = TextEditingController();

  late List<User> usersList = [];

  static const passwordMatchSnackBar = SnackBar(
      content: Text("The passwords don't match.")
  );

  static const emailExistsSnackBar = SnackBar(
      content: Text("This account already exists.")
  );

  Future<void> _createUser(String email, String password) async {
    Database.createUser(email, password);
  }

  Future<User> _getUser(String id, String email, String qualifier) async {
    return Database.getUser(id, email, qualifier);
  }

  _getAllUsers() {
    Database.getAllUsers().then((users){
      setState(() {
        usersList = users;
      });
    });
  }

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: const Color(0xff459657),
            title: const Text('Pocket Kitchen')
        ),
        body: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
            child:
              Column(
                children: [
                  const Spacer(),
                  const Text(
                      "Sign Up",
                      style: TextStyle(
                          fontSize: 32,
                          color: Color(0xff7B7777),
                          fontWeight: FontWeight.w500
                      )
                  ),
                  const Spacer(),
                  TextField(
                    enabled: true,
                    controller: emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(width: 3, color: Color(0xff7B7777))
                      ),
                      hintText: 'Email',
                      contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 16.0),
                    child:
                    TextField(
                      enabled: true,
                      controller: passwordController,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 3, color: Color(0xff7B7777))
                        ),
                        hintText: 'Password',
                        contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                      ),
                    ),
                  ),
                  TextField(
                    enabled: true,
                    controller: confPasswordController,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(width: 3, color: Color(0xff7B7777))
                      ),
                      hintText: 'Confirm Password',
                      contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 72.0, 0.0, 64.0),
                    child:
                    TextButton(
                      onPressed: () async {
                        print(sharedPrefs.userId);
                        //check that password matches confirmed password
                        if (passwordController.text == confPasswordController.text) {
                          //check that the email doesn't already exist
                          print("getting user 1");
                          User user = await _getUser("", emailController.text, Database.emailQual);
                          //if email doesn't match existing
                          if (user.email != emailController.text) {
                            print("create user");
                            await _createUser(emailController.text, passwordController.text);
                            //get new user's id
                            print("get user 2");
                            User user = await _getUser("", emailController.text, Database.emailQual);
                            //store id in local storage
                            sharedPrefs.userId = user.id!;
                            //load the app
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const TabBarMain()),
                            );
                            print(sharedPrefs.userId);
                          //if the email already exists
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(emailExistsSnackBar);
                          }
                        //if passwords don't match
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(passwordMatchSnackBar);
                        }
                      },
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Color(0xff459657)),
                      ),
                      child:
                      const Text(
                        "Sign Up",
                        style: TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                          "Already have an account?",
                          style: TextStyle(
                              fontSize: 18,
                              color: Color(0xff7B7777),
                              fontWeight: FontWeight.w400
                          )
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignInView()),
                          );
                        },
                        child:
                        const Text(
                          "Sign In",
                          style: TextStyle(
                              fontSize: 18,
                              color: Color(0xff40CDF4),
                              fontWeight: FontWeight.w400
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
        ),
      );
}