import 'dart:convert';
import 'package:http/http.dart';
import 'models/user.dart';

class Database {
  //Database interface API url
  static Uri root = Uri.parse('http://24.57.171.252/pkCrudOps.php');

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

  //USER CRUD Methods
  //Create user
  static Future<void> createUser(String email, String password) async {
    try {
      var bodyMap = <String, dynamic>{};
      bodyMap["action"] = "$createAction";
      bodyMap["table"] = "$userTable";
      bodyMap["user_id"] = "1";
      bodyMap["email"] = "$email";
      bodyMap["password"] = "$password";

      final response = await post(root, body: bodyMap);

      if (200 == response.statusCode) {
        print("Response 200 = Good");
      } else {
        print("Not a 200 response, but a response.");
      }
    } catch (e) {
      print("Post failed.");
    }
  }

  //Get all users
  static Future<List<User>> getAllUsers() async {
    List<User> userList;
    try {
      var bodyMap = <String, dynamic>{};
      bodyMap["action"] = "$readAllAction";
      bodyMap["table"] = "$userTable";
      bodyMap["user_id"] = "0";
      bodyMap["email"] = "";
      bodyMap["password"] = "";

      final response = await post(root, body: bodyMap);
      if (response.statusCode == 200) {
        print(response.body);
        userList = parseResponseToList(response.body);
        print("Successful");
        print(userList.length);
        return userList;
      }
    } catch (e) {
      print("Unsuccessful");
      return [];
    }
    return [];
  }

  //Get one user
  static Future<User> getUser(String id) async {
    var user = User();
    //try {
    var bodyMap = <String, dynamic>{};
    bodyMap["action"] = "$readOneAction";
    bodyMap["table"] = "$userTable";
    bodyMap["user_id"] = "$id";
    bodyMap["email"] = "";
    bodyMap["password"] = "";

    final response = await post(root, body: bodyMap);
    if (response.statusCode == 200) {
      print(response.body);
      user = parseResponse(response.body);
      print("Successful");
      print(user.email);
      return user;
    }
    //} catch (e) {
    // print("Unsuccessful");
    // return user;
    //}
    return user;
  }

  //Update user
  static Future<void> updateUser(String id, String email, String password) async {
    try {
      var bodyMap = <String, dynamic>{};
      bodyMap["action"] = "$updateAction";
      bodyMap["table"] = "$userTable";
      bodyMap["user_id"] = "$id";
      bodyMap["email"] = "$email";
      bodyMap["password"] = "$password";

      final response = await post(root, body: bodyMap);

      if (200 == response.statusCode) {
        print("Response 200 = Good");
      } else {
        print("Not a 200 response, but a response.");
      }
    } catch (e) {
      print("Post failed.");
    }
  }
  //Delete user
  static Future<void> deleteUser(String id) async {
    try {
      var bodyMap = <String, dynamic>{};
      bodyMap["action"] = "$deleteAction";
      bodyMap["table"] = "$userTable";
      bodyMap["user_id"] = "$id";
      bodyMap["email"] = "";
      bodyMap["password"] = "";

      final response = await post(root, body: bodyMap);

      if (200 == response.statusCode) {
        print("Response 200 = Good");
      } else {
        print("Not a 200 response, but a response.");
      }
    } catch (e) {
      print("Post failed.");
    }
  }

  //PANTRY CRUD Methods
  //Create pantry
  static Future<void> createPantry(String name, String ownerID) async {
    try {
      var bodyMap = <String, dynamic>{};
      bodyMap["action"] = "$createAction";
      bodyMap["table"] = "$pantryTable";
      bodyMap["pantry_id"] = "";
      bodyMap["name"] = "$name";
      bodyMap["user_count"] = "1";
      bodyMap["owner_id"] = "$ownerID";

      final response = await post(root, body: bodyMap);

      if (200 == response.statusCode) {
        print("Response 200 = Good");
      } else {
        print("Not a 200 response, but a response.");
      }
    } catch (e) {
      print("Post failed.");
    }
  }

  //Get all users
  static Future<List<User>> getAllUsers() async {
    List<User> userList;
    try {
      var bodyMap = <String, dynamic>{};
      bodyMap["action"] = "$readAllAction";
      bodyMap["table"] = "$userTable";
      bodyMap["user_id"] = "0";
      bodyMap["email"] = "";
      bodyMap["password"] = "";

      final response = await post(root, body: bodyMap);
      if (response.statusCode == 200) {
        print(response.body);
        userList = parseResponseToList(response.body);
        print("Successful");
        print(userList.length);
        return userList;
      }
    } catch (e) {
      print("Unsuccessful");
      return [];
    }
    return [];
  }

  //Get one user
  static Future<User> getUser(String id) async {
    var user = User();
    //try {
    var bodyMap = <String, dynamic>{};
    bodyMap["action"] = "$readOneAction";
    bodyMap["table"] = "$userTable";
    bodyMap["user_id"] = "$id";
    bodyMap["email"] = "";
    bodyMap["password"] = "";

    final response = await post(root, body: bodyMap);
    if (response.statusCode == 200) {
      print(response.body);
      user = parseResponse(response.body);
      print("Successful");
      print(user.email);
      return user;
    }
    //} catch (e) {
    // print("Unsuccessful");
    // return user;
    //}
    return user;
  }

  //Update user
  static Future<void> updateUser(String id, String email, String password) async {
    try {
      var bodyMap = <String, dynamic>{};
      bodyMap["action"] = "$updateAction";
      bodyMap["table"] = "$userTable";
      bodyMap["user_id"] = "$id";
      bodyMap["email"] = "$email";
      bodyMap["password"] = "$password";

      final response = await post(root, body: bodyMap);

      if (200 == response.statusCode) {
        print("Response 200 = Good");
      } else {
        print("Not a 200 response, but a response.");
      }
    } catch (e) {
      print("Post failed.");
    }
  }
  //Delete user
  static Future<void> deleteUser(String id) async {
    try {
      var bodyMap = <String, dynamic>{};
      bodyMap["action"] = "$deleteAction";
      bodyMap["table"] = "$userTable";
      bodyMap["user_id"] = "$id";
      bodyMap["email"] = "";
      bodyMap["password"] = "";

      final response = await post(root, body: bodyMap);

      if (200 == response.statusCode) {
        print("Response 200 = Good");
      } else {
        print("Not a 200 response, but a response.");
      }
    } catch (e) {
      print("Post failed.");
    }
  }

  //JSON Conversion Methods
  //Converts returned json to list of Users
  static List<User> parseResponseToList (String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }

  //Converts returned json to list of Users
  static User parseResponse (String responseBody) {
    return User.fromJson(json.decode(responseBody));
  }
}
