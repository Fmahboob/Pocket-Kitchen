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


  //set current pantry food ids
  setPantryFoodIds(String pantryId) async {
    //get all pantry foods for the user's current pantry
    List<PantryFood> pantryFoods = await Database.getAllPantryFoods(sharedPrefs.currentPantry);
    List<String> pantryFoodIds = [];
    //loop through the pantry foods to extract ids
    pantryFoods.forEach((PantryFood pantryFood) {
      pantryFoodIds.add(pantryFood.id!);
    });
    //save the ids to local storage
    _sharedPrefs!.setStringList("pantryFoods", pantryFoodIds);
  }

  //get current pantry food ids
  List<String> get pantryFoodIds => _sharedPrefs!.getStringList("pantryFoods") ?? [];

  //get all current pantry foods
  Future<List<PantryFood>> getPantryFoods() async {
    List<PantryFood> pantryFoods = [];
    for (var element in pantryFoodIds) {
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

  //get unavailable and available lists filtered by the search query
  Future<List<List<PantryFood>>> getAllListsFiltered(String search) async {
    //all pantry foods
    List<PantryFood> pantryFoods = await getPantryFoods();
    //all pantry food's foods
    List<Food> foods = await getFoodsForPantryFoods(2);
    //final available searched list
    List<PantryFood> availPantryFoods = [];
    //final unavailable searched list
    List<PantryFood> unavailPantryFoods = [];

    //loop over all pantryfoods
    for (var pantryFood in pantryFoods) {
      //available list
      if (pantryFood.amount != "0") {
        //get index to check if search matches PantryFood's food details
        int index = foods.indexWhere((element) => element.id == pantryFood.foodId);
        //check if search is contained in the food's name, category, and description
        if (foods[index].name!.contains(search) || foods[index].category!.contains(search) || foods[index].desc!.contains(search)) {
          availPantryFoods.add(pantryFood);
        }
      //unavailable list
      } else {
        //get index to check if search matches PantryFood's food details
        int index = foods.indexWhere((element) => element.id == pantryFood.foodId);
        //check if search is contained in the food's name, category, and description
        if (foods[index].name!.contains(search) || foods[index].category!.contains(search) || foods[index].desc!.contains(search)) {
          unavailPantryFoods.add(pantryFood);
        }
      }
    }
    return [availPantryFoods, unavailPantryFoods];
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