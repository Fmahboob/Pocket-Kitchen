import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pocket_kitchen/models/recipe_model/recipe_detail.dart';
import 'package:pocket_kitchen/models/recipe_model/recipe_list.dart';
import 'api.dart';

class RecipeData {
  API apiKey = API();
  final String _baseUrl = 'https://api.spoonacular.com/recipes/complexSearch';

  Future<List<RecipeList>> recipesByCuisine(String cuisine) async {
    final url = '$_baseUrl?cuisine=$cuisine&apiKey=${apiKey.apiKey}';


    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print(response.body);

      final List<dynamic> results = jsonData['results'];

      return results.map((json) => RecipeList.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch recipes');
    }
  }
  Future<RecipeDetail> fetchRecipeDetail(int id) async {

    final response = await http.get(Uri.parse(
        'https://api.spoonacular.com/recipes/$id/information?apiKey=${apiKey.apiKey}'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json != null) {
        return RecipeDetail.fromJson(json);
      }
      else{
        throw Exception('Failed to load recipe detail');
      }
    }
    else {
      throw Exception('Failed to load recipe detail');
    }
  }

}