import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:pocket_kitchen/models/app_models/shared_preferences.dart';
import 'package:pocket_kitchen/models/go_upc_models/go_upc_item.dart';
import '../../main.dart';
import '../../models/data_models/food.dart';
import '../../models/data_models/pantry_food.dart';
import 'grocery_list_item.dart';
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
  String searchTerm = "";
  bool isChecked = false;

  late GoUPCItem scannedItem;
  String barcodeNo = "0058891252220";

  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  List<PantryFood> unavailPantryFoods = [PantryFood(amount: "1", pantryId: "3", foodId: "4"), PantryFood(amount: "1", pantryId: "3", foodId: "4"), PantryFood(amount: "1", pantryId: "3", foodId: "4")];
  List<Food> unavailFoods = [Food(id: "3", name: "Corn", category: "Veggies", desc: "Yummy.", imgUrl: "https://s30386.pcdn.co/wp-content/uploads/2019/08/FreshCorn_HNL1309_ts135846041.jpg.optimal.jpg"), Food(id: "3", name: "Corn", category: "Veggies", desc: "Yummy.", imgUrl: "https://s30386.pcdn.co/wp-content/uploads/2019/08/FreshCorn_HNL1309_ts135846041.jpg.optimal.jpg"), Food(id: "3", name: "Corn", category: "Veggies", desc: "Yummy.", imgUrl: "https://s30386.pcdn.co/wp-content/uploads/2019/08/FreshCorn_HNL1309_ts135846041.jpg.optimal.jpg")];

  //Food CRUD methods
  _createFood(String name, String imgUrl, String category, String desc, String weight, bool ownUnit, barcode) {
    Database.createFood(name, imgUrl, category, desc, weight, ownUnit, barcode);
  }

  Future<Food> _getFood(String barcode, String name, String id, String qualifier) {
    return Database.getFood(barcode, name, id, qualifier);
  }

  //Pantry food CRUD methods
  Future<void> _createPantryFood(String amount, String pantryId, String foodId) async {
    await Database.createPantryFood(amount, pantryId, foodId);
  }

  _updatePantryFood(String id, String amount, String pantryId, String foodId) {
    Database.updatePantryFood(id, amount, pantryId, foodId);
  }

  _getPantryFood (String foodId) {
    Database.getPantryFood(foodId);
  }

  bool isNumeric(String s) {
    try {
      int.parse(s);
      return true;
    } catch(e) {
      return false;
    }
  }

  bool isPeriod(String s) {
    if (s == ".") {
      return true;
    } else {
      return false;
    }
  }

  Future _scan() async {
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

      var amountStr = "";
      var amount = "";
      var amountCharLength = 0;

      //get amount out of name string
      //loop over product.name string
      for (var rune in scannedItem.product!.name!.runes) {
        //add each character to temp var amountStr
        amountStr = amountStr + String.fromCharCode(rune).toLowerCase();
        //check that amountStr ends with kg (ready to retrieve measurement)
        if (amountStr.endsWith("kg")) {
          //cut off string besides last 8 characters (8 characters is the maximum, for a 5 digit weight that has a space between kg ex. 23.45 KG)
          amountStr = amountStr.substring(amountStr.length - 8);
          //check if string has space between measurement and 'kg' or not
          if (amountStr[amountStr.length - 3] == " ") {
            //checks that the current character is a number or decimal (when it isn't, we have our string)
            if (isNumeric(amountStr[amountStr.length - 4]) || isPeriod(amountStr[amountStr.length - 4])) {
              //checks that the current character is a number or decimal (when it isn't, we have our string)
              if (isNumeric(amountStr[amountStr.length - 5]) || isPeriod(amountStr[amountStr.length - 5])) {
                //checks that the current character is a number or decimal (when it isn't, we have our string)
                if (isNumeric(amountStr[amountStr.length - 6]) || isPeriod(amountStr[amountStr.length - 6])) {
                  //checks that the current character is a number or decimal (when it isn't, we have our string)
                  if (isNumeric(amountStr[amountStr.length - 7]) || isPeriod(amountStr[amountStr.length - 7])) {
                    //checks that the current character is a number or decimal (when it isn't, we have our string)
                    if (isNumeric(amountStr[amountStr.length - 8])) {
                      //cuts off 'kg'
                      amountStr = amountStr.substring(0, 5);
                      //sets expected length of amount for substring
                      amountCharLength = 5;
                    } else {
                      //cuts off 'kg'
                      amountStr = amountStr.substring(1, 5);
                      //sets expected length of amount for substring
                      amountCharLength = 4;
                    }
                  } else {
                    //cuts off 'kg'
                    amountStr = amountStr.substring(2, 5);
                    //sets expected length of amount for substring
                    amountCharLength = 3;
                  }
                } else {
                  //cuts off 'kg'
                  amountStr = amountStr.substring(3, 5);
                  //sets expected length of amount for substring
                  amountCharLength = 2;
                }
              } else {
                //cuts off 'kg'
                amountStr = amountStr.substring(4, 5);
                //sets expected length of amount for substring
                amountCharLength = 1;
              }
            }
          //if there isn't a space between measurement and 'kg'
          } else {
            //checks that the current character is a number or decimal (when it isn't, we have our string)
            if (isNumeric(amountStr[amountStr.length - 3]) || isPeriod(amountStr[amountStr.length - 3])) {
              //checks that the current character is a number or decimal (when it isn't, we have our string)
              if (isNumeric(amountStr[amountStr.length - 4]) || isPeriod(amountStr[amountStr.length - 4])) {
                //checks that the current character is a number or decimal (when it isn't, we have our string)
                if (isNumeric(amountStr[amountStr.length - 5]) || isPeriod(amountStr[amountStr.length - 5])) {
                  //checks that the current character is a number or decimal (when it isn't, we have our string)
                  if (isNumeric(amountStr[amountStr.length - 6]) || isPeriod(amountStr[amountStr.length - 6])) {
                    //checks that the current character is a number or decimal (when it isn't, we have our string)
                    if (isNumeric(amountStr[amountStr.length - 7])) {
                      //cuts off 'kg'
                      amountStr = amountStr.substring(1, 6);
                      //sets expected length of amount for substring
                      amountCharLength = 5;
                    } else {
                      //cuts off 'kg'
                      amountStr = amountStr.substring(2, 6);
                      //sets expected length of amount for substring
                      amountCharLength = 4;
                    }
                  } else {
                    //cuts off 'kg'
                    amountStr = amountStr.substring(3, 6);
                    //sets expected length of amount for substring
                    amountCharLength = 3;
                  }
                } else {
                  //cuts off 'kg'
                  amountStr = amountStr.substring(4, 6);
                  //sets expected length of amount for substring
                  amountCharLength = 2;
                }
              } else {
                //cuts off 'kg'
                amountStr = amountStr.substring(5, 6);
                //sets expected length of amount for substring
                amountCharLength = 1;
              }
            }
          }
        }
      }

      //sub string the temp var from the first index to the length it should be (amountCharLength)
      amount = amountStr.substring(0, amountCharLength);

      //query for food with same barcode to check if it already exists in the food table
      Food checkFood = await _getFood(barcodeNo, "", "", Database.barcodeQual);

      //if the barcode does match and the food already exists
      if (checkFood.barcode == barcodeNo) {

        //query for pantry food with the same barcode to check if it already exists in the pantry food table
        PantryFood checkPantryFood = await _getPantryFood(checkFood.id!);

        //if the barcode matches and its pantry id is the user's current pantry id, then it exists
        if (checkPantryFood.foodId == checkFood.id && checkPantryFood.pantryId == sharedPrefs.currentPantry) {

          //Therefore, the user is refilling the item's stock. Update the amount to full (equal to it's food's weight)
          await _updatePantryFood(checkPantryFood.id!, "1", checkPantryFood.pantryId!, checkPantryFood.foodId!);

          //update pantryFood list
          await sharedPrefs.setPantryFoodIds(sharedPrefs.currentPantry);
          print(sharedPrefs.pantryFoodIds);

        //if the food doesn't exist in the user's pantry foods, create it
        } else {

          //create pantry food
          await _createPantryFood("1", sharedPrefs.currentPantry, checkFood.id!);

          //update pantryFood list
          await sharedPrefs.setPantryFoodIds(sharedPrefs.currentPantry);
          print(sharedPrefs.pantryFoodIds);
        }

      //if the barcode doesn't match and the food isn't in the food's table, create a food and pantry food of it
      } else {

        //create food
        await _createFood(scannedItem.product!.name!, scannedItem.product!.imageUrl!, scannedItem.product!.category!, scannedItem.product!.description!, amount, false, barcodeNo);

        //get food
        Food inputtedFood = await _getFood(barcodeNo, "", "", Database.barcodeQual);

        //create pantry food
        await _createPantryFood("1", sharedPrefs.currentPantry, inputtedFood.id!);

        //update pantryFood list
        await sharedPrefs.setPantryFoodIds(sharedPrefs.currentPantry);
        print(sharedPrefs.pantryFoodIds);
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
                            onChanged: (String search) {
                              setState(() {
                                sharedPrefs.getAllListsFiltered(search);
                              });
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
                            FutureBuilder(
                                future: Future.wait([
                                  sharedPrefs.getAvailablePantryFoods(),
                                  sharedPrefs.getFoodsForPantryFoods(1)
                                ]),
                                builder: (context, AsyncSnapshot<List<List<dynamic>>> snapshot) {
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: unavailPantryFoods.length,//sharedPrefs.pantryFoodIds.length,
                                      itemBuilder: (context, index) {
                                        return GroceryListItem(
                                            onLongPress: () {
                                              setState(() async {
                                                //get pantry food to update availability
                                                PantryFood pantryFood = await _getPantryFood(snapshot.data![0][index]);

                                                //update the availability to full (100%/1)
                                                await _updatePantryFood(pantryFood.id!, "1", pantryFood.pantryId!, pantryFood.foodId!);
                                              });
                                            },
                                            pantryFood: unavailPantryFoods[index],//snapshot.data![0][index],
                                            food: unavailFoods[index],//snapshot.data![1][index]
                                        );
                                      }
                                  );
                                }
                            ),
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

                      //update pantryFood list
                      await sharedPrefs.setPantryFoodIds(sharedPrefs.currentPantry);
                      print(sharedPrefs.pantryFoodIds);

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