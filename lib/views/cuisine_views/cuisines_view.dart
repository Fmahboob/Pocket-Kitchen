import 'package:flutter/material.dart';


class CuisinesView extends StatefulWidget {
  const CuisinesView({super.key});

  @override
  State<StatefulWidget> createState() => CuisinesViewState();
}

class CuisinesViewState extends State<CuisinesView> {
  String pantryName = "Robbie's Home";
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xff459657),
        title: Text(pantryName),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
            child: Text(
                "Cuisines",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 17,
                    color: Color(0xff459657),
                    fontWeight: FontWeight.w600
                )
            ),
          ),

          Expanded(

            child: ListView.builder(

              itemBuilder: (context, index) {
                return Container();

              },

            ),
          ),


        ],
      ),
    );
  }
}





