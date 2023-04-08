class RecipeDetail {
  final int id;
  final String title;
  final String imageUrl;
  final String cookTime;
  final String instructions;

  final List<ExtendedIngredients> extendedIngredients;

  RecipeDetail({required this.id, required this.title, required this.imageUrl, required this.cookTime, required this.extendedIngredients, required this.instructions});

  factory RecipeDetail.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> ingredientList = json['extendedIngredients'].cast<Map<String, dynamic>>();
    List<ExtendedIngredients> ingredients = ingredientList.map((json) => ExtendedIngredients.fromJson(json)).toList();

    return RecipeDetail(
        id: json['id'],
        title: json['title'],
        imageUrl: json['image'],
        cookTime: json['readyInMinutes'].toString(),

        extendedIngredients: ingredients,
        instructions: json['instructions']);
  }

}

class ExtendedIngredients {
  final String name;
  final double amount;
  final String unit;

  ExtendedIngredients({
    required this.name,
    required this.amount,
    required this.unit});

  factory ExtendedIngredients.fromJson(Map<String, dynamic> json) {
    return ExtendedIngredients(
      name: json['name'],
      amount: json['amount'].toDouble(),
      unit: json['unit'],
    );
  }
}
