import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? _sharedPrefs;

  init() async {
    if (_sharedPrefs == null) {
      _sharedPrefs = await SharedPreferences.getInstance();
    }
  }

  String get userId => _sharedPrefs!.getString("userId") ?? "";

  set userId(String value) {
    _sharedPrefs!.setString("userId", value);
  }

  bool get signedIn {
    if (userId == "") {
      return false;
    } else {
      return true;
    }
  }
}

final sharedPrefs = SharedPrefs();