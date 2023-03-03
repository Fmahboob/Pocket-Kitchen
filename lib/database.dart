import 'dart:convert';
import 'package:http/http.dart';
import 'models/user.dart';

class Database {
  //Database interface API url
  static const String root = 'http://25.57.171.252/pkCrudOps.php';

  //Action constants
  static const createAction = 'CREATE';
  static const readOneAction = 'READ_ONE';
  static const readAllAction = 'READ_ALL';
  static const updateAction = 'UPDATE';
  static const deleteAction = 'DELETE';

  //Data table constants
  static const foodTable = 'FOODS';
  static const userTable = 'USERS';
  static const pantryTable = 'PANTRIES';
  static const pantryFoodTable = 'PANTRY_FOODS';
  static const pantryUserTable = 'PANTRY_USERS';

  //User methods
  //converts returned json to list of Users
  static List<User> parseResponse (String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }

  //create user
  static Future<String> addUser(String email, String password) async {
    try {
      var bodyMap = <String, dynamic>{};
      bodyMap['action'] = '$createAction';
      bodyMap['table'] = '$userTable';
      bodyMap['user_id'] = 1;
      bodyMap['email'] = '$email';
      bodyMap['password'] = '$password';

      var headerMap = <String, String>{};
      headerMap['Content-Type'] = 'application/x-www-form-urlencoded';
      headerMap['Accept'] = '*/*';
      headerMap['Accept-Encoding'] = 'gzip, deflate, br';
      headerMap['Connection'] = 'keep-alive';

      final response = await post(root as Uri, headers: headerMap, body: bodyMap);

      if (200 == response.statusCode) {
        print("Successful user creation");
        return response.body;
      } else {
        print("return error");
        return "Return error";
      }
    } catch (e) {
      print("http error");
      return "Http error";
    }
  }

  //get all users
  static Future<List<User>> getUsers() async {
    List<User> userList;
    try {
      var map = <String, dynamic>{};
      map['action'] = readAllAction;
      map['table'] = userTable;
      final response = await post(root as Uri, body: map);
      if (response.statusCode == 200) {
        userList = parseResponse(response.body);
        print("Successful user reading");
        return userList;
      }
    } catch (e) {
      print("error return");
      return [];
    }
    return [];
  }
}
