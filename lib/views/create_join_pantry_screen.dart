
import 'package:flutter/material.dart';

class CreatePantryScreen extends StatelessWidget {
  const CreatePantryScreen({super.key});

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
                padding: const EdgeInsets.fromLTRB(25, 50, 50, 10),
                child: Row(
                  children: [
                    TextButton(onPressed: () {

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
                child: Text("to get started", style: TextStyle(
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


}