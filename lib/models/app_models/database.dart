import 'dart:convert';
import 'package:http/http.dart';
import 'package:pocket_kitchen/models/data_models/pantry_food.dart';
import '../data_models/food.dart';
import '../data_models/pantry.dart';
import '../data_models/pantry_user.dart';
import '../data_models/user.dart';

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

  //Qualifier options
  static const barcodeQual = "BARCODE";
  static const nameQual = "NAME";
  static const idQual = "ID";
  static const emailQual = "EMAIL";
  static const bothQual = "BOTH";

  //USER CRUD Methods
  //Create user
  static Future<void> createUser(String email) async {
    try {
      var bodyMap = <String, dynamic>{};
      bodyMap["action"] = "$createAction";
      bodyMap["table"] = "$userTable";
      bodyMap["qualifier"] = "";
      bodyMap["user_id"] = "";
      bodyMap["email"] = "$email";

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
      bodyMap["qualifier"] = "";
      bodyMap["user_id"] = "";
      bodyMap["email"] = "";

      final response = await post(root, body: bodyMap);
      if (response.statusCode == 200) {
        print(response.body);
        userList = parseUsersToList(response.body);
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
  static Future<User> getUser(String id, String email, String qualifier) async {
    var user = User();
    try {
      var bodyMap = <String, dynamic>{};
      bodyMap["action"] = "$readOneAction";
      bodyMap["table"] = "$userTable";
      bodyMap["qualifier"] = "$qualifier";
      bodyMap["user_id"] = "$id";
      bodyMap["email"] = "$email";

      final response = await post(root, body: bodyMap);
      if (response.statusCode == 200) {
        user = parseUsersToList(response.body)[0];
        print("Successful");
        return user;
      }
    } catch (e) {
     print("Unsuccessful");
     return user;
    }
    return user;
  }

  //Update user
  static Future<void> updateUser(String id, String email) async {
    try {
      var bodyMap = <String, dynamic>{};
      bodyMap["action"] = "$updateAction";
      bodyMap["table"] = "$userTable";
      bodyMap["qualifier"] = "";
      bodyMap["user_id"] = "$id";
      bodyMap["email"] = "$email";

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
      bodyMap["qualifier"] = "";
      bodyMap["user_id"] = "$id";
      bodyMap["email"] = "";

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
      bodyMap["qualifier"] = "";
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

  //Get all pantries
  static Future<List<Pantry>> getAllPantries() async {
    List<Pantry> pantryList;
    try {
      var bodyMap = <String, dynamic>{};
      bodyMap["action"] = "$readAllAction";
      bodyMap["table"] = "$pantryTable";
      bodyMap["qualifier"] = "";
      bodyMap["pantry_id"] = "";
      bodyMap["name"] = "";
      bodyMap["user_count"] = "";
      bodyMap["owner_id"] = "";

      final response = await post(root, body: bodyMap);
      if (response.statusCode == 200) {
        print(response.body);
        pantryList = parsePantriesToList(response.body);
        print("Successful");
        print(pantryList.length);
        return pantryList;
      }
    } catch (e) {
      print("Unsuccessful");
      return [];
    }
    return [];
  }

  //Get one pantry
  static Future<Pantry> getPantry(String id, String name, String ownerId, String qualifier) async {
    var pantry = Pantry();
    try {
      var bodyMap = <String, dynamic>{};
      bodyMap["action"] = "$readOneAction";
      bodyMap["table"] = "$pantryTable";
      bodyMap["qualifier"] = "$qualifier";
      bodyMap["pantry_id"] = "$id";
      bodyMap["name"] = "$name";
      bodyMap["user_count"] = "";
      bodyMap["owner_id"] = "$ownerId";

      final response = await post(root, body: bodyMap);
      if (response.statusCode == 200) {
        pantry = parsePantriesToList(response.body)[0];
        print("Successful");
        return pantry;
      }
    } catch (e) {
     print("Unsuccessful");
     return pantry;
    }
    return pantry;
  }

  //Update pantry
  static Future<void> updatePantry(String id, String name, String userCount, String ownerId) async {
    try {
      var bodyMap = <String, dynamic>{};
      bodyMap["action"] = "$updateAction";
      bodyMap["table"] = "$pantryTable";
      bodyMap["qualifier"] = "";
      bodyMap["pantry_id"] = "$id";
      bodyMap["name"] = "$name";
      bodyMap["user_count"] = "$userCount";
      bodyMap["owner_id"] = "$ownerId";

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
  //Delete pantry
  static Future<void> deletePantry(String id) async {
    try {
      var bodyMap = <String, dynamic>{};
      bodyMap["action"] = "$deleteAction";
      bodyMap["table"] = "$pantryTable";
      bodyMap["qualifier"] = "";
      bodyMap["pantry_id"] = "$id";
      bodyMap["name"] = "";
      bodyMap["user_count"] = "";
      bodyMap["owner_id"] = "";

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

  //FOOD CRUD Methods
  //Create food
  static Future<void> createFood(String name, String imgUrl, String category, String desc, String weight, bool ownUnit, String barcode) async {
    try {
      var bodyMap = <String, dynamic>{};
      bodyMap["action"] = "$createAction";
      bodyMap["table"] = "$foodTable";
      bodyMap["qualifier"] = "";
      bodyMap["food_id"] = "";
      bodyMap["name"] = "$name";
      bodyMap["img_url"] = "$imgUrl";
      bodyMap["category"] = "$category";
      bodyMap["description"] = "$desc";
      bodyMap["weight"] = "$weight";
      bodyMap["own_unit"] = "$ownUnit";
      bodyMap["barcode"] = "$barcode";

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

  //Get all foods
  static Future<List<Food>> getAllFoods() async {
    List<Food> foodList;
    try {
      var bodyMap = <String, dynamic>{};
      bodyMap["action"] = "$readAllAction";
      bodyMap["table"] = "$foodTable";
      bodyMap["qualifier"] = "";
      bodyMap["food_id"] = "";
      bodyMap["name"] = "";
      bodyMap["img_url"] = "";
      bodyMap["category"] = "";
      bodyMap["description"] = "";
      bodyMap["weight"] = "";
      bodyMap["own_unit"] = "";
      bodyMap["barcode"] = "";

      final response = await post(root, body: bodyMap);
      if (response.statusCode == 200) {
        print(response.body);
        foodList = parseFoodsToList(response.body);
        print("Successful");
        print(foodList.length);
        return foodList;
      }
    } catch (e) {
      print("Unsuccessful");
      return [];
    }
    return [];
  }

  //Get one food
  static Future<Food> getFood(String barcode, String name, String id, String qualifier) async {
    var food = Food();
    try {
      var bodyMap = <String, dynamic>{};
      bodyMap["action"] = "$readOneAction";
      bodyMap["table"] = "$pantryTable";
      bodyMap["qualifier"] = "$qualifier";
      bodyMap["food_id"] = "$id";
      bodyMap["name"] = "$name";
      bodyMap["img_url"] = "";
      bodyMap["category"] = "";
      bodyMap["description"] = "";
      bodyMap["weight"] = "";
      bodyMap["own_unit"] = "";
      bodyMap["barcode"] = "$barcode";

      final response = await post(root, body: bodyMap);
      if (response.statusCode == 200) {
        food = parseFoodsToList(response.body)[0];
        print("Successful");
        return food;
      }
    } catch (e) {
     print("Unsuccessful");
     return food;
    }
    return food;
  }

  //Update food
  static Future<void> updateFood(String id, String name, String imgUrl, String category, String desc, String weight, bool ownUnit, String barcode) async {
    try {
      var bodyMap = <String, dynamic>{};
      bodyMap["action"] = "$updateAction";
      bodyMap["table"] = "$foodTable";
      bodyMap["qualifier"] = "";
      bodyMap["food_id"] = "$id";
      bodyMap["name"] = "$name";
      bodyMap["img_url"] = "$imgUrl";
      bodyMap["category"] = "$category";
      bodyMap["description"] = "$desc";
      bodyMap["weight"] = "$weight";
      bodyMap["own_unit"] = "$ownUnit";
      bodyMap["barcode"] = "$barcode";

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

  //Delete food
  static Future<void> deleteFood(String id) async {
    try {
      var bodyMap = <String, dynamic>{};
      bodyMap["action"] = "$deleteAction";
      bodyMap["table"] = "$foodTable";
      bodyMap["qualifier"] = "";
      bodyMap["food_id"] = "$id";
      bodyMap["name"] = "";
      bodyMap["img_url"] = "";
      bodyMap["category"] = "";
      bodyMap["description"] = "";
      bodyMap["weight"] = "";
      bodyMap["own_unit"] = "";
      bodyMap["barcode"] = "";

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

  //PANTRY_USER CRUD Methods
  //Create pantry_user
  static Future<void> createPantryUser(String pantryId, String userId) async {
    try {
      var bodyMap = <String, dynamic>{};
      bodyMap["action"] = "$createAction";
      bodyMap["table"] = "$pantryUserTable";
      bodyMap["qualifier"] = "";
      bodyMap["pantry_user_id"] = "";
      bodyMap["pantry_id"] = "$pantryId";
      bodyMap["user_id"] = "$userId";

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

  //Get all pantry_users
  static Future<List<PantryUser>> getAllPantryUsers() async {
    List<PantryUser> pantryUserList;
    try {
      var bodyMap = <String, dynamic>{};
      bodyMap["action"] = "$readAllAction";
      bodyMap["table"] = "$pantryUserTable";
      bodyMap["qualifier"] = "";
      bodyMap["pantry_user_id"] = "";
      bodyMap["pantry_id"] = "";
      bodyMap["user_id"] = "";

      final response = await post(root, body: bodyMap);
      if (response.statusCode == 200) {
        print(response.body);
        pantryUserList = parsePantryUsersToList(response.body);
        print("Successful");
        print(pantryUserList.length);
        return pantryUserList;
      }
    } catch (e) {
      print("Unsuccessful");
      return [];
    }
      return [];
  }

  //Get one pantry_user
  static Future<PantryUser> getPantryUser(String id) async {
    var pantryUser = PantryUser();
    try {
      var bodyMap = <String, dynamic>{};
      bodyMap["action"] = "$readOneAction";
      bodyMap["table"] = "$pantryUserTable";
      bodyMap["qualifier"] = "";
      bodyMap["pantry_user_id"] = "$id";
      bodyMap["pantry_id"] = "";
      bodyMap["user_id"] = "";

      final response = await post(root, body: bodyMap);
      if (response.statusCode == 200) {
        pantryUser = parsePantryUsersToList(response.body)[0];
        print("Successful");
        return pantryUser;
      }
    } catch (e) {
      print("Unsuccessful");
     return pantryUser;
    }
    return pantryUser;
  }

  //Update pantry_user
  static Future<void> updatePantryUser(String id, String pantryId, String userId) async {
    try {
      var bodyMap = <String, dynamic>{};
      bodyMap["action"] = "$updateAction";
      bodyMap["table"] = "$pantryUserTable";
      bodyMap["qualifier"] = "";
      bodyMap["pantry_user_id"] = "$id";
      bodyMap["pantry_id"] = "$pantryId";
      bodyMap["user_id"] = "$userId";

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
  //Delete pantry_user
  static Future<void> deletePantryUser(String userId, String pantryId) async {
    try {
      var bodyMap = <String, dynamic>{};
      bodyMap["action"] = "$deleteAction";
      bodyMap["table"] = "$userTable";
      bodyMap["qualifier"] = "";
      bodyMap["pantry_user_id"] = "";
      bodyMap["pantry_id"] = "$pantryId";
      bodyMap["user_id"] = "$userId";

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

  //PANTRY_FOOD CRUD Methods
  //Create pantry_food
  static Future<void> createPantryFood(String amount, String pantryId, String foodId) async {
    try {
      var bodyMap = <String, dynamic>{};
      bodyMap["action"] = "$createAction";
      bodyMap["table"] = "$pantryFoodTable";
      bodyMap["qualifier"] = "";
      bodyMap["pantry_food_id"] = "";
      bodyMap["amount"] = "$amount";
      bodyMap["pantry_id"] = "$pantryId";
      bodyMap["food_id"] = "$foodId";

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

  //Get all pantry_foods
  static Future<List<PantryFood>> getAllPantryFoods() async {
    List<PantryFood> pantryFoodList;
    try {
      var bodyMap = <String, dynamic>{};
      bodyMap["action"] = "$readAllAction";
      bodyMap["table"] = "$pantryFoodTable";
      bodyMap["qualifier"] = "";
      bodyMap["pantry_food_id"] = "";
      bodyMap["amount"] = "";
      bodyMap["pantry_id"] = "";
      bodyMap["food_id"] = "";

      final response = await post(root, body: bodyMap);
      if (response.statusCode == 200) {
        print(response.body);
        pantryFoodList = parsePantryFoodsToList(response.body);
        print("Successful");
        print(pantryFoodList.length);
        return pantryFoodList;
      }
    } catch (e) {
      print("Unsuccessful");
    return [];
    }
    return [];
  }

  //Get one pantry_food
  static Future<PantryFood> getPantryFood(String foodId) async {
    var pantryFood = PantryFood();
    try {
      var bodyMap = <String, dynamic>{};
      bodyMap["action"] = "$readOneAction";
      bodyMap["table"] = "$pantryFoodTable";
      bodyMap["qualifier"] = "";
      bodyMap["pantry_food_id"] = "";
      bodyMap["amount"] = "";
      bodyMap["pantry_id"] = "";
      bodyMap["food_id"] = "$foodId";

      final response = await post(root, body: bodyMap);
      if (response.statusCode == 200) {
        pantryFood = parsePantryFoodsToList(response.body)[0];
        print("Successful");
        return pantryFood;
      }
    } catch (e) {
      print("Unsuccessful");
    return pantryFood;
    }
    return pantryFood;
  }

  //Update pantry_food
  static Future<void> updatePantryFood(String id, String amount, String pantryId, String foodId) async {
    try {
      var bodyMap = <String, dynamic>{};
      bodyMap["action"] = "$updateAction";
      bodyMap["table"] = "$pantryFoodTable";
      bodyMap["qualifier"] = "";
      bodyMap["pantry_food_id"] = "$id";
      bodyMap["amount"] = "$amount";
      bodyMap["pantry_id"] = "$pantryId";
      bodyMap["food_id"] = "$foodId";

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
  //Delete pantry_food
  static Future<void> deletePantryFood(String id) async {
    try {
      var bodyMap = <String, dynamic>{};
      bodyMap["action"] = "$deleteAction";
      bodyMap["table"] = "$pantryFoodTable";
      bodyMap["qualifier"] = "";
      bodyMap["pantry_food_id"] = "$id";
      bodyMap["amount"] = "";
      bodyMap["pantry_id"] = "";
      bodyMap["food_id"] = "";

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
  static List<User> parseUsersToList (String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }

  static List<Pantry> parsePantriesToList (String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Pantry>((json) => Pantry.fromJson(json)).toList();
  }

  static List<Food> parseFoodsToList (String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Food>((json) => Food.fromJson(json)).toList();
  }

  static List<PantryUser> parsePantryUsersToList (String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<PantryUser>((json) => PantryUser.fromJson(json)).toList();
  }

  static List<PantryFood> parsePantryFoodsToList (String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<PantryFood>((json) => PantryFood.fromJson(json)).toList();
  }
}
