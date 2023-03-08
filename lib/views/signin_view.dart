import 'package:flutter/material.dart';
import 'package:pocket_kitchen/views/signup_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database.dart';
import '../models/user.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  SignInViewState createState() => SignInViewState();
}

class SignInViewState extends State<SignInView> {
  SharedPreferences prefs = SharedPreferences.getInstance() as SharedPreferences;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confPasswordController = TextEditingController();

  static const passwordMatchSnackBar = SnackBar(
    content: Text("The passwords don't match.")
  );

  static const emailNonExistSnackBar = SnackBar(
      content: Text("This account doesn't exist.")
  );

  _getUser(String email) {
    Database.getUser(email);
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
                  "Sign In",
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
                  onPressed: () {
                    //check that password matches confirmed password
                    if (passwordController.text == confPasswordController.text) {
                      //get the user's account details
                      User user = _getUser(emailController.text);

                      //check that the email/account exists
                      if (user.email != "" || user.email != " " || user.email != null) {
                        //store user id in local storage
                        prefs.setInt("userId", user.id! as int);
                      //if the email doesn't exist
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(emailNonExistSnackBar);
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
                    "Sign In",
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
                      "Don't have have an account?",
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
                        MaterialPageRoute(builder: (context) => const SignUpView()),
                      );
                    },
                    child:
                    const Text(
                      "Sign Up",
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