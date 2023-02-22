import 'package:flutter/material.dart';


class PantryView extends StatelessWidget {
  const PantryView({Key? key,}) : super (key: key);
  static const drawerIcon = Color(0xff459657);
  static const drawerStyle = TextStyle(fontSize: 20, color: Color(0xff459657));


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: const Color(0xff459657),
            title: const Text('Pocket Kitchen'),

        ),
        body: Container(

        ),
        drawer: Container(
          child: Drawer(
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
                          title: const Text('Create Pantry', style: drawerStyle,),
                          leading: const Icon(Icons.add_circle_outline, color: drawerIcon,),
                          onTap: () {},
                        ),
                        ListTile(
                          title: const Text('Join Pantry', style: drawerStyle,),
                          leading: const Icon(Icons.exit_to_app, color: drawerIcon,),
                          onTap: () {},
                        ),
                        ListTile(
                            title: const Text('Delete Pantry', style: drawerStyle,),
                            leading: const Icon(Icons.delete_forever_rounded, color: drawerIcon,),
                            onTap: () {}
                        ),
                        ListTile(
                            title: const Text('Leave Pantry', style: drawerStyle,),
                            leading: const Icon(Icons.arrow_back, color: drawerIcon,),
                            onTap: () {}
                        ),
                        ListTile(
                            title: const Text('Switch Pantry', style: drawerStyle,),
                            leading: const Icon(Icons.swap_calls, color: drawerIcon,),
                            onTap: () {}
                        )
                      ],
                    )),
               const Divider(),
                Container(
                    padding: const EdgeInsets.all(10),
                    height: 100,
                    child: const ListTile(
                        title: Text("pantryName!", style: drawerStyle,),
                        leading: Icon(Icons.desktop_windows_sharp, color: drawerIcon,),
                    )

                ),

              ])),
        ),

    );
  }
}