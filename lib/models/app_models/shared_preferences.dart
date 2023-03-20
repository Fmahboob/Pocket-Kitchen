import 'package:pocket_kitchen/models/app_models/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data_models/pantry.dart';

class SharedPrefs {
  static SharedPreferences? _sharedPrefs;

  init() async {
    if (_sharedPrefs == null) {
      _sharedPrefs = await SharedPreferences.getInstance();
    }
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
      _sharedPrefs!.setString("pantries"[1], currentPantry);
      _sharedPrefs!.setString("pantries"[0], pantry2);
    } else if (value == 3) {
      _sharedPrefs!.setString("pantries"[2], currentPantry);
      _sharedPrefs!.setString("pantries"[0], pantry3);
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
  bool ownsCurrentPantry (String ownerId) {
    if (ownerId == currentPantry) {
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