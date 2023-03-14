import 'package:flutter/material.dart';
import 'package:pocket_kitchen/views/sign_in_sign_up_views/signup_view.dart';
import 'package:pocket_kitchen/models/app_models/shared_preferences.dart';

import '../../models/app_models/database.dart';
import '../../main.dart';
import '../../models/data_models/user.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  SignInViewState createState() => SignInViewState();
}

class SignInViewState extends State<SignInView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  static const emailNonExistSnackBar = SnackBar(
      content: Text("This account doesn't exist.")
  );

  Future<User> _getUser(String id, email, qualifier) async {
    return Database.getUser(id, email, qualifier);
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
              Form(
                key: _formKey,
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
                    TextFormField(
                      enabled: true,
                      validator: (value) {
                        if (value != passwordController.text) {
                          return 'Passwords must match';
                        }
                      },
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
        ),
      );
}