import 'package:flutter/material.dart';
import '../../models/food.dart';
import '../../models/pantry_food.dart';
import 'grocery_list_listview.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:pocket_kitchen/database.dart';
import '../../models/user.dart';

class GroceryListView extends StatefulWidget {
  const GroceryListView({super.key});

  @override
  GroceryListViewState createState() => GroceryListViewState();
}
class GroceryListViewState extends State<GroceryListView> {
  List<PantryFood> groceryList = [PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1), PantryFood(id: 1, amount: 5.55, pantryId: 0, foodId: 1)];
  List<Food> allFoods = [];

  String searchTerm = "";
  bool isChecked = false;
  String barcodeNo = "";

  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  _scan() async{
    await FlutterBarcodeScanner.scanBarcode("#000000", "Cancel", true, ScanMode.BARCODE).then((value) => setState(()=> barcodeNo = value));
  }

  _createFood(String name, String imgUrl, String category, String desc, String weight, bool ownUnit, barcode) {
    Database.createFood(name, imgUrl, category, desc, weight, ownUnit, barcode);
  }

  _createPantryFood(String amount, String pantryId, String foodId) {
    Database.createPantryFood(amount, pantryId, foodId);
  }

  _getAllFoods() {
    return Database.getAllFoods();
  }

  Future<Food> _getFood(String id) {
    return Database.getFood(id);
  }
/*
  _getAllUsers() {
    Database.getAllUsers().then((users){
      setState(() {
        usersList = users;
      });
    });
  }
*/
  @override
  Widget build(BuildContext context) =>
    Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xff459657),
          title: const Text('Pocket Kitchen'),
          leading: IconButton(
            onPressed: () {
              foodEntryDialog();
            },
            icon: const Icon(Icons.edit),
            tooltip: 'Manually enter food items to your pantry',
          ),
          actions: [
            IconButton(
              onPressed: () => _scan(),
              icon: const Icon(Icons.document_scanner_outlined),
              tooltip: 'Scan food items to your pantry',
            )
          ]
        ),
      body: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
          child:
              Row(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(
                            enabled: true,
                            onChanged: (String input) {
                              searchTerm = input;
                            },
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 3, color: Color(0xff7B7777))
                                ),
                                hintText: "Search",
                              contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                              prefixIcon: Icon(Icons.search)
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
                            child: Text(
                              "Grocery List",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 17,
                                color: Color(0xff7B7777),
                                fontWeight: FontWeight.w600
                              )
                            ),
                          ),
                          Expanded(
                            child:
                            GroceryList(groceryList: groceryList),
                          ),
                        ],
                      )
                    )
                  ]
              )
      ),
    );

  Future foodEntryDialog() => showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) =>
          AlertDialog(
            title:
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                    "Food Entry",
                    style: TextStyle(
                        fontSize: 32,
                        color: Color(0xff7B7777),
                        fontWeight: FontWeight.w400
                    )
                ),
              ],
            ),
            content:
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  enabled: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 3, color: Color(0xff7B7777))
                    ),
                    hintText: "Food Name",
                    contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                  ),
                ),
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text (
                    'Doesn\'t require units (ex. apples)',
                    style: TextStyle(
                        color: Color(0xff7B7777),
                        fontWeight: FontWeight.w400
                    ),
                  ),
                  value: isChecked,
                  onChanged: (isChecked) =>
                      setState(() => this.isChecked = isChecked!),
                ),
                TextField(
                  enabled: true,
                  controller: amountController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(width: 3, color: Color(0xff7B7777))
                    ),
                    hintText: isChecked ? 'Food Amount' : 'Food Weight(lbs.)',
                    contentPadding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                  ),
                ),
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      _createFood(nameController.text, "", "", "", amountController.text, isChecked, "");
                      //_createPantryFood(amountController.text, /*pantryId,*/ foodId);
                      Navigator.pop(context);
                    },
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Color(0xff459657)),
                    ),
                    child:
                    const Text(
                      "Add",
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