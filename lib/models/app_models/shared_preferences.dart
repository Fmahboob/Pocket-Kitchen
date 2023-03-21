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

  //currentPantry getter
  String get currentPantry => _sharedPrefs!.getStringList("pantries")?[0] ?? "4";

  //all pantries getter
  List<String> get pantries => _sharedPrefs!.getStringList("pantries") ?? [];
  //new pantry setter
  addNewPantry(String value) {
    String pantry1 = _sharedPrefs!.getStringList("pantries")?[0] ?? "";
    String pantry2 = _sharedPrefs!.getStringList("pantries")?[1] ?? "";

    _sharedPrefs!.setString("pantries"[0], value);
    _sharedPrefs!.setString("pantries"[1], pantry1);
    _sharedPrefs!.setString("pantries"[2], pantry2);
  }

  //getter for if user is signed in
  bool get signedIn {
    if (userId == "") {
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
}

//singleton
final sharedPrefs = SharedPrefs();