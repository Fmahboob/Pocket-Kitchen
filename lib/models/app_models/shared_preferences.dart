import 'dart:convert';

import 'package:pocket_kitchen/models/app_models/database.dart';
import 'package:pocket_kitchen/models/data_models/pantry_food.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data_models/food.dart';
import '../data_models/pantry.dart';

class SharedPrefs {
  static SharedPreferences? _sharedPrefs;

  init() async {
    if (_sharedPrefs == null) {
      _sharedPrefs = await SharedPreferences.getInstance();
    }
  }


  //sets food list
  set foodList (List<Food> foods) {
    List<String> foodsStrList = [];
    for (Food food in foods) {
      Map<String, dynamic> foodMap = jsonDecode(foodToJson(food));
      foodsStrList.add(jsonEncode(foodMap));
    }
    _sharedPrefs!.setStringList("foodsList", foodsStrList);
  }

  //gets food list
  List<Food> get foodList {
    List<Food> foodsList = [];

    List<String> foodsStrList = _sharedPrefs!.getStringList("foodsList") ?? [];

    for (String food in foodsStrList) {
      foodsList.add(Food.fromJsonLocal(jsonDecode(food)));
    }

    return foodsList;
  }

  //sets pantry food list
  set pantryFoodList (List<PantryFood> pantryFoods) {
    List<String> pantryFoodsStrList = [];
    for (PantryFood pantryFood in pantryFoods) {
      Map<String, dynamic> pantryFoodMap = jsonDecode(pantryFoodToJson(pantryFood));
      pantryFoodsStrList.add(jsonEncode(pantryFoodMap));
    }
    _sharedPrefs!.setStringList("pantryFoodsList", pantryFoodsStrList);
  }

  //gets pantry food list
  List<PantryFood> get pantryFoodList {
    List<PantryFood> pantryFoodsList = [];

    List<String> pantryFoodsStrList = _sharedPrefs!.getStringList("pantryFoodsList") ?? [];
    for (String pantryFood in pantryFoodsStrList) {
      pantryFoodsList.add(PantryFood.fromJsonLocal(jsonDecode(pantryFood)));
    }
    return pantryFoodsList;
  }

  //gets available foods
  List<Food> get availableFoodList {
    List<Food> availFoodsList = [];

    List<Food> foodList = sharedPrefs.foodList;
    List<PantryFood> pantryFoodList = sharedPrefs.pantryFoodList;

    for (PantryFood pantryFood in pantryFoodList) {
      if (pantryFood.amount != "0") {
        for (Food food in foodList) {
          if (food.id == pantryFood.foodId) {
            availFoodsList.add(food);
          }
        }
      }
    }
    availFoodsList.sort((a, b) {
      return a.name!.toLowerCase().compareTo(b.name!.toLowerCase());
    });
    return availFoodsList;
  }

  //gets unavailable foods
  List<Food> get unavailableFoodList {
    List<Food> unavailFoodsList = [];

    List<Food> foodList = sharedPrefs.foodList;
    List<PantryFood> pantryFoodList = sharedPrefs.pantryFoodList;

    for (PantryFood pantryFood in pantryFoodList) {
      if (pantryFood.amount == "0") {
        for (Food food in foodList) {
          if (food.id == pantryFood.foodId) {
            unavailFoodsList.add(food);
          }
        }
      }
    }
    unavailFoodsList.sort((a, b) {
      return a.name!.toLowerCase().compareTo(b.name!.toLowerCase());
    });
    return unavailFoodsList;
  }

  //gets available pantry foods
  List<PantryFood> get availablePantryFoodList {
    List<PantryFood> availPantryFoods = [];

    List<PantryFood> pantryFoodsList = sharedPrefs.pantryFoodList;
    List<Food> availFoodsList = sharedPrefs.availableFoodList;

    for (Food food in availFoodsList) {
      for (PantryFood pantryFood in pantryFoodsList) {
        if (pantryFood.foodId == food.id) {
          availPantryFoods.add(pantryFood);
        }
      }
    }
    return availPantryFoods;
  }

  //gets unavailable pantry foods
  List<PantryFood> get unavailablePantryFoodList {
    List<PantryFood> unavailPantryFoods = [];

    List<PantryFood> pantryFoodsList = sharedPrefs.pantryFoodList;
    List<Food> unavailFoodsList = sharedPrefs.unavailableFoodList;

    for (Food food in unavailFoodsList) {
      for (PantryFood pantryFood in pantryFoodsList) {
        if (pantryFood.foodId == food.id) {
          unavailPantryFoods.add(pantryFood);
        }
      }
    }
    return unavailPantryFoods;
  }

  //get available and unavailable pantry foods/ foods filtered by search
  List<List<dynamic>> getAllListsFiltered(String search) {
    List<PantryFood> availPantryFoodsList = sharedPrefs.availablePantryFoodList;
    List<PantryFood> unavailPantryFoodsList = sharedPrefs.unavailablePantryFoodList;
    List<Food> availFoodsList = sharedPrefs.availableFoodList;
    List<Food> unavailFoodsList = sharedPrefs.unavailableFoodList;

    List<PantryFood> filteredAvailPantryFoodList = [];
    List<PantryFood> filteredUnavailPantryFoodList = [];
    List<Food> filteredAvailFoodList = [];
    List<Food> filteredUnavailFoodList = [];

    for (Food food in availFoodsList) {
      if (food.name!.contains(search) || food.category!.contains(search) || food.desc!.contains(search)) {
        filteredAvailFoodList.add(food);
      }
    }

    for (Food food in unavailFoodsList) {
      if (food.name!.contains(search) || food.category!.contains(search) || food.desc!.contains(search)) {
        filteredUnavailFoodList.add(food);
      }
    }

    filteredAvailFoodList.sort((a, b) {
      return a.name!.toLowerCase().compareTo(b.name!.toLowerCase());
    });

    filteredUnavailFoodList.sort((a, b) {
      return a.name!.toLowerCase().compareTo(b.name!.toLowerCase());
    });

    for (Food food in filteredAvailFoodList) {
      for (PantryFood pantryFood in availPantryFoodsList) {
        if (food.id == pantryFood.foodId) {
          filteredAvailPantryFoodList.add(pantryFood);
        }
      }
    }

    for (Food food in filteredUnavailFoodList) {
      for (PantryFood pantryFood in unavailPantryFoodsList) {
        if (food.id == pantryFood.foodId) {
          filteredUnavailPantryFoodList.add(pantryFood);
        }
      }
    }

    return [filteredAvailPantryFoodList, filteredUnavailPantryFoodList, filteredAvailFoodList, filteredUnavailFoodList];
  }

/*
  //set current pantry food ids
  setPantryFoodIds(String pantryId) async {
    //get all pantry foods for the user's current pantry
    List<PantryFood> pantryFoods = await Database.getAllPantryFoods(sharedPrefs.currentPantry);

    List<String> availPantryFoodIds = [];
    List<String> unavailPantryFoodIds = [];
    List<String> allPantryFoodIds = [];
    //loop through the pantry foods to extract ids
    pantryFoods.forEach((PantryFood pantryFood) {
      if (pantryFood.amount == 0) {
        unavailPantryFoodIds.add(pantryFood.id!);
      } else {
        availPantryFoodIds.add(pantryFood.id!);
      }
      allPantryFoodIds.add(pantryFood.id!);
    });
    //save the ids to local storage
    _sharedPrefs!.setStringList("availPantryFoods", availPantryFoodIds);
    _sharedPrefs!.setStringList("unavailPantryFoods", unavailPantryFoodIds);
    _sharedPrefs!.setStringList("allPantryFoods", allPantryFoodIds);
  }

  //get current pantry food ids
  List<String> get availPantryFoodIds => _sharedPrefs!.getStringList("availPantryFoods") ?? [];
  List<String> get unavailPantryFoodIds => _sharedPrefs!.getStringList("unavailPantryFoods") ?? [];
  List<String> get allPantryFoodIds => _sharedPrefs!.getStringList("allPantryFoods") ?? [];

  //get all current pantry foods
  Future<List<PantryFood>> getPantryFoods() async {
    List<PantryFood> pantryFoods = [];
    for (var element in allPantryFoodIds) {
      print("in get pf");
      pantryFoods.add(await Database.getPantryFood(element));
    }
    print("$pantryFoods foods");
    return pantryFoods;
  }

  //get all available pantry foods
  Future<List<PantryFood>> getAvailablePantryFoods() async {
    List<PantryFood> availablePantryFoods = [];
    print("in avail");
    List<PantryFood> pantryFoods = await getPantryFoods();
    for (var element in pantryFoods) {
      if (element.amount != "0") {
        availablePantryFoods.add(element);
      }
    }
    print("$availablePantryFoods available");
    return availablePantryFoods;
  }

  //get unavailable list of pantryFoods
  Future<List<PantryFood>> getUnavailablePantryFoods() async {
    List<PantryFood> unavailablePantryFoods = [];
    List<PantryFood> pantryFoods = await getPantryFoods();
    for (var element in pantryFoods) {
      if (element.amount == "0") {
        unavailablePantryFoods.add(element);
      }
    }
    print("$unavailablePantryFoods unavailable");
    return unavailablePantryFoods;
  }

  //get associated foods list to specified pantry foods list (available, unavailable, all)
  Future<List<Food>> getFoodsForPantryFoods (int flag) async {
    List<PantryFood> pantryFoods = [];
    List<Food> foods = [];

    if (flag == 0) {
      pantryFoods = await getAvailablePantryFoods();
    } else if (flag == 1) {
      pantryFoods = await getUnavailablePantryFoods();
    } else if (flag == 2) {
      pantryFoods = await getPantryFoods();
    }

    for (var element in pantryFoods) {
      Food food = await Database.getFood("", "", element.foodId!, Database.idQual);
      foods.add(food);
    }

    return foods;
  }
*/
  //userId getter
  String get userId => _sharedPrefs!.getString("userId") ?? "";

  //userId setter
  set userId(String value) {
    _sharedPrefs!.setString("userId", value);
  }


  //currentPantry name getter
  String get currentPantryName => _sharedPrefs!.getString("pantryName") ?? "";

  //currentPantry name setter
  set currentPantryName(String value) {
    _sharedPrefs!.setString("pantryName", value);
  }


  //currentPantry owner getter
  String get currentPantryOwner => _sharedPrefs!.getString("pantryOwner") ?? "";
  //currentPantry owner setter
  set currentPantryOwner(String value) {
    _sharedPrefs!.setString("pantryOwner", value);
  }

  //currentPantry getter
  String get currentPantry {
    return _sharedPrefs!.getStringList("pantries")?[0] ?? "";
  }


  //all pantries getter
  List<String> get pantries => _sharedPrefs!.getStringList("pantries") ?? [];

  //new pantry setter
  addNewPantry(String value) {
    String pantry1 = _sharedPrefs!.getStringList("pantries")?[0] ?? "";
    String pantry2 = _sharedPrefs!.getStringList("pantries")?[1] ?? "";

    List<String> pantries = [value, pantry1, pantry2];

    _sharedPrefs!.setStringList("pantries", pantries);
  }

  //pantry remover
  removeCurrentPantry() {
    String pantry2 = _sharedPrefs!.getStringList("pantries")?[1] ?? "";
    String pantry3 = _sharedPrefs!.getStringList("pantries")?[2] ?? "";

    List<String> pantries = [pantry2, pantry3, ""];

    _sharedPrefs!.setStringList("pantries", pantries);
  }

  //pantry switch
  switchCurrentPantry(int value) {
    String pantry2 = _sharedPrefs!.getStringList("pantries")?[1] ?? "";
    String pantry3 = _sharedPrefs!.getStringList("pantries")?[2] ?? "";

    if (value == 2) {
      List<String> pantries = [pantry2, currentPantry, pantry3];
      _sharedPrefs!.setStringList("pantries", pantries);
    } else if (value == 3) {
      List<String> pantries = [pantry3, currentPantry, pantry2];
      _sharedPrefs!.setStringList("pantries", pantries);
    }
  }


  //getter for if user is signed in
  bool get signedIn {
    if (userId == "") {
      return false;
    } else {
      return true;
    }
  }


  //getter for if the user has any pantries currently
  bool get hasPantries {
    if (currentPantry == "") {
      return false;
    } else {
      return true;
    }
  }


  //getter for if user owns current pantry
  bool ownsCurrentPantry () {
    if (currentPantryOwner == currentPantry) {
      return true;
    } else {
      return false;
    }
  }


  //getter for if second pantry exists
  bool get secondPantryExists {
    if (_sharedPrefs!.getStringList("pantries")?[1] != "") {
      return true;
    } else {
      return false;
    }
  }

  //getter for if third pantry exists
  bool get thirdPantryExists {
    if (_sharedPrefs!.getStringList("pantries")?[2] != "") {
      return true;
    } else {
      return false;
    }
  }
}

//singleton
final sharedPrefs = SharedPrefs();