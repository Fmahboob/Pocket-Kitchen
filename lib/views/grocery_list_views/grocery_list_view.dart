import 'package:flutter/material.dart';
import 'package:pocket_kitchen/models/app_models/shared_preferences.dart';
import 'package:pocket_kitchen/models/go_upc_models/go_upc_item.dart';
import '../../main.dart';
import '../../models/data_models/food.dart';
import '../../models/data_models/pantry_food.dart';
import 'grocery_list_item.dart';
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
  String barcodeNo = "";

  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  List<PantryFood> unavailPantryFoods = [PantryFood(amount: "1", pantryId: "3", foodId: "4"), PantryFood(amount: "1", pantryId: "3", foodId: "4"), PantryFood(amount: "1", pantryId: "3", foodId: "4")];
  List<Food> unavailFoods = [Food(id: "3", name: "Corn", category: "Veggies", desc: "Yummy.", imgUrl: "https://s30386.pcdn.co/wp-content/uploads/2019/08/FreshCorn_HNL1309_ts135846041.jpg.optimal.jpg"), Food(id: "3", name: "Corn", category: "Veggies", desc: "Yummy.", imgUrl: "https://s30386.pcdn.co/wp-content/uploads/2019/08/FreshCorn_HNL1309_ts135846041.jpg.optimal.jpg"), Food(id: "3", name: "Corn", category: "Veggies", desc: "Yummy.", imgUrl: "https://s30386.pcdn.co/wp-content/uploads/2019/08/FreshCorn_HNL1309_ts135846041.jpg.optimal.jpg")];

  //Food CRUD methods
  Future<void> _createFood(String name, String imgUrl, String category, String desc, String weight, String ownUnit, String barcode) async {
    await Database.createFood(name, imgUrl, category, desc, weight, ownUnit, barcode);
  }

  Future<Food> _getFood(String barcode, String name, String id, String weight, String qualifier) {
    return Database.getFood(barcode, name, id, weight, qualifier);
  }

  //Pantry food CRUD methods
  Future<void> _createPantryFood(String amount, String pantryId, String foodId) async {
    await Database.createPantryFood(amount, pantryId, foodId);
  }

  Future<void> _updatePantryFood(String id, String amount, String pantryId, String foodId) async {
    await Database.updatePantryFood(id, amount, pantryId, foodId);
  }

  Future<PantryFood> _getPantryFood (String foodId, String pantryId, String qualifier) {
    return Database.getPantryFood(foodId, pantryId, qualifier);
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
      Food checkFood = await _getFood(barcodeNo, "", "", "", Database.barcodeQual);

      //if the barcode does match and the food already exists
      if (checkFood.barcode == barcodeNo) {
        print("barcode matches");
        //query for pantry food with the same food id and pantry id
        PantryFood checkPantryFood = await _getPantryFood(checkFood.id!, sharedPrefs.currentPantry, Database.bothQual);

        //check that a pantry food was returned and exists in the current pantry
        if (checkPantryFood.id != "" || checkPantryFood.id != " " || checkPantryFood.id != null) {
          print("food and pfood matches");
          //Therefore, the user is refilling the item's stock. Update the amount to full (equal to it's food's weight)
          await _updatePantryFood(checkPantryFood.id!, "1", checkPantryFood.pantryId!, checkPantryFood.foodId!);

          //update pantryFood list
          List<PantryFood> pantryFoodsList = sharedPrefs.pantryFoodList;
          for (PantryFood pantryFood in pantryFoodsList) {
            if (pantryFood.id == checkPantryFood.id) {
              pantryFood.amount = "1";
            }
          }
          sharedPrefs.pantryFoodList = pantryFoodsList;

        //if the food doesn't exist in the user's pantry foods, create it
        } else {
          print("food and pfood dont match");
          //create pantry food
          await _createPantryFood("1", sharedPrefs.currentPantry, checkFood.id!);
          PantryFood pantryFood = await _getPantryFood(checkFood.id!, sharedPrefs.currentPantry, Database.bothQual);

          List<PantryFood> pantryFoodsList = sharedPrefs.pantryFoodList;
          pantryFoodsList.add(pantryFood);
          sharedPrefs.pantryFoodList = pantryFoodsList;

          List<Food> foodList = sharedPrefs.foodList;
          foodList.add(checkFood);
          sharedPrefs.foodList = foodList;
        }

      //if the barcode doesn't match and the food isn't in the food's table, create a food and pantry food of it
      } else {
        print("barcode doesnt match");
        //create food
        await _createFood(scannedItem.product!.name!, scannedItem.product!.imageUrl ?? "", scannedItem.product!.category ?? "", scannedItem.product!.description ?? "", amount, "0", barcodeNo);

        //get food
        Food inputtedFood = await _getFood(barcodeNo, "", "", "", Database.barcodeQual);

        //create pantry food
        await _createPantryFood("1", sharedPrefs.currentPantry, inputtedFood.id!);

        PantryFood pantryFood = await _getPantryFood(inputtedFood.id!, sharedPrefs.currentPantry, Database.bothQual);

        List<PantryFood> pantryFoodsList = sharedPrefs.pantryFoodList;
        pantryFoodsList.add(pantryFood);
        sharedPrefs.pantryFoodList = pantryFoodsList;

        List<Food> foodList = sharedPrefs.foodList;
        foodList.add(inputtedFood);
        sharedPrefs.foodList = foodList;
      }
    }
    Navigator.pop(context);
    //push main app
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TabBarMain(flag: 1)),
    );
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
                                searchTerm = search;
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
                                ListView.builder(
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemCount: sharedPrefs.getAllListsFiltered(searchTerm)[1].length,
                                              itemBuilder: (context, index) {
                                                return GroceryListItem(
                                                  onLongPress: () {
                                                    manualRestockDialog(sharedPrefs.getAllListsFiltered(searchTerm)[1][index], sharedPrefs.getAllListsFiltered(searchTerm)[3][index], index);
                                                  },
                                                  pantryFood: sharedPrefs.getAllListsFiltered(searchTerm)[1][index],
                                                  food: sharedPrefs.getAllListsFiltered(searchTerm)[3][index],
                                                  index: index
                                                );
                                              }
                                          ),
                          )
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
                    hintText: isChecked ? 'Food Amount' : 'Food Weight (kg)',
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
                      //set is its own unit var
                      String ownUnit = "";
                      if (isChecked) {
                        ownUnit = "1";
                      } else {
                        ownUnit = "0";
                      }

                      String name = "";
                      if (ownUnit == "0") {
                        name = nameController.text + " " + amountController.text + "kg";
                      } else {
                        name = nameController.text;
                      }

                      //check if food already exists
                      Food checkFood = await _getFood("", name, "", amountController.text, Database.bothQual);

                      //if not, create it
                      if (checkFood.name == "" || checkFood.name == " " || checkFood.name == null) {
                        //create food
                        await _createFood(name, "", "", "", amountController.text, ownUnit, "");
                        print(name);
                        print(amountController.text);
                        //get food by name
                        checkFood = await _getFood("", name, "", "", Database.nameQual);
                      }

                      if (ownUnit == "0") {
                        //create pantry food
                        await _createPantryFood("1", sharedPrefs.currentPantry, checkFood.id!);
                      } else {
                        //create pantry food
                        await _createPantryFood(amountController.text, sharedPrefs.currentPantry, checkFood.id!);
                      }

                      PantryFood pantryFood = await _getPantryFood(checkFood.id!, sharedPrefs.currentPantry, Database.bothQual);

                      //update local lists
                      List<PantryFood> pantryFoodsList = sharedPrefs.pantryFoodList;
                      pantryFoodsList.add(pantryFood);
                      sharedPrefs.pantryFoodList = pantryFoodsList;

                      List<Food> foodList = sharedPrefs.foodList;
                      foodList.add(checkFood);
                      sharedPrefs.foodList = foodList;

                      Navigator.pop(context);
                      Navigator.pop(context);
                      //push main app
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TabBarMain(flag: 1)),
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

  Future manualRestockDialog(PantryFood pantryFood, Food food, int index) => showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (context, setState) =>
              AlertDialog(
                content:
                const Text(
                  "Are you sure you want to manually restock this item?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xff7B7777),
                      fontWeight: FontWeight.w400
                  ),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () async {

                          if (food.ownUnit == "0") {
                            //update the availability to full (100%/1)
                            await _updatePantryFood(pantryFood.id!, "1", pantryFood.pantryId!, pantryFood.foodId!);

                            List<PantryFood> pantryFoodsList = sharedPrefs.pantryFoodList;

                            for (PantryFood aPantryFood in pantryFoodsList) {
                              if (aPantryFood.id == pantryFood.id) {
                                aPantryFood.amount = "1";
                              }
                            }

                            sharedPrefs.pantryFoodList = pantryFoodsList;
                          } else {
                            //update the availability to full (100% of food weight)
                            await _updatePantryFood(pantryFood.id!, food.weight!, pantryFood.pantryId!, pantryFood.foodId!);

                            List<PantryFood> pantryFoodsList = sharedPrefs.pantryFoodList;

                            for (PantryFood aPantryFood in pantryFoodsList) {
                              if (aPantryFood.id == pantryFood.id) {
                                aPantryFood.amount = food.weight;
                              }
                            }

                            sharedPrefs.pantryFoodList = pantryFoodsList;
                          }
                          Navigator.pop(context);
                          Navigator.pop(context);
                          //push main app
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const TabBarMain(flag: 1)),
                          );
                        },
                        style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(Color(0xff459657)),
                        ),
                        child:
                        const Text(
                          "Restock",
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