import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:pocket_kitchen/models/app_models/shared_preferences.dart';
import 'package:pocket_kitchen/models/go_upc_models/go_upc_item.dart';
import '../../main.dart';
import '../../models/data_models/food.dart';
import '../../models/data_models/pantry_food.dart';
import 'grocery_list_listview.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:pocket_kitchen/models/app_models/database.dart';
import 'package:http/http.dart';
import 'dart:convert';

class GroceryListView extends StatefulWidget {
  const GroceryListView({super.key});

  @override
  GroceryListViewState createState() => GroceryListViewState();
}
class GroceryListViewState extends State<GroceryListView> {
  List<PantryFood> groceryList = [];
  List<Food> allFoods = [];
  late GoUPCItem scannedItem;

  String searchTerm = "";
  bool isChecked = false;
  String barcodeNo = "";

  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  //Food CRUD methods
  _createFood(String name, String imgUrl, String category, String desc, String weight, bool ownUnit, barcode) {
    Database.createFood(name, imgUrl, category, desc, weight, ownUnit, barcode);
  }

  Future<Food> _getFood(String barcode, String name, String id, String qualifier) {
    return Database.getFood(barcode, name, id, qualifier);
  }

  //Pantry food CRUD methods
  _createPantryFood(String amount, String pantryId, String foodId) {
    Database.createPantryFood(amount, pantryId, foodId);
  }

  _updatePantryFood(String id, String amount, String pantryId, String foodId) {
    Database.updatePantryFood(id, amount, pantryId, foodId);
  }

  _getPantryFood (String foodId) {
    Database.getPantryFood(foodId);
  }

  Future _scan() async{
    //scans barcode and returns the barcode number
    await FlutterBarcodeScanner.scanBarcode("#000000", "Cancel", true, ScanMode.BARCODE).then((value) => setState(()=> barcodeNo = value));

    //API call to Go-UPC with barcode number
    Response response = await get(Uri.parse('https://go-upc.com/api/v1/code/$barcodeNo'), headers: {
      'Authorization': 'Bearer 24a313ffbcb68c96a4c74cd11c17aaa60fc8f2efd7f2baeb203fe3cf97e2adab',
    });

    //if response succeeds
    if (response.statusCode == 200) {

      //store returned item values
      scannedItem = GoUPCItem.fromJson(jsonDecode(response.body));

      //query for food with same barcode to check if it already exists in the food table
      Food checkFood = await _getFood(barcodeNo, "", "", Database.barcodeQual);

      //if the barcode does match and the food already exists
      if (checkFood.barcode == barcodeNo) {

        //query for pantry food with the same barcode to check if it already exists in the pantry food table
        PantryFood checkPantryFood = await _getPantryFood(checkFood.id!);

        //if the barcode matches and its pantry id is the user's current pantry id, then it exists
        if (checkPantryFood.foodId == checkFood.id && checkPantryFood.pantryId == sharedPrefs.currentPantry) {

          //Therefore, the user is refilling the item's stock. Update the amount to full (equal to it's food's weight)
          await _updatePantryFood(checkPantryFood.id!, checkFood.weight!, checkPantryFood.pantryId!, checkPantryFood.foodId!);

        //if the food doesn't exist in the user's pantry foods, create it
        } else {
          await _createPantryFood(scannedItem.product!.specs!["Liquid Volume"]!, sharedPrefs.currentPantry, checkFood.id!);
        }

      //if the barcode doesn't match and the food isn't in the food's table, create a food and pantry food of it
      } else {
        await _createFood(scannedItem.product!.name!, scannedItem.product!.imageUrl!, scannedItem.product!.category!, scannedItem.product!.description!, scannedItem.product!.specs!["Liquid Volume"]!, false, barcodeNo);
        Food inputtedFood = await _getFood(barcodeNo, "", "", Database.barcodeQual);
        await _createPantryFood(scannedItem.product!.specs!["Liquid Volume"]!, sharedPrefs.currentPantry, inputtedFood.id!);
      }
    }
  }

  @override
  Widget build(BuildContext context) =>
    Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xff459657),
          title: Text(sharedPrefs.currentPantryName),
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
                    onPressed: () async {
                      //create food
                      await _createFood(nameController.text, "", "", "", amountController.text, isChecked, "");
                      //get food for id
                      Food food = await _getFood("", nameController.text, "", Database.nameQual);
                      //create pantry food
                      await _createPantryFood(amountController.text, sharedPrefs.currentPantry, food.id!);

                      Navigator.pop(context);
                      Navigator.pop(context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TabBarMain()),
                      );
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