class RecipeDetail {
  final int id;
  final String title;
  final String imageUrl;
  final String cookTime;
  final String instructions;

  RecipeDetail({required this.id, required this.title, required this.imageUrl, required this.cookTime, required this.instructions});

  factory RecipeDetail.fromJson(Map<String, dynamic> json) {
    return RecipeDetail(
        id: json['id'],
        title: json['title'],
        imageUrl: json['image'],
        cookTime: json['readyInMinutes'],
        instructions: json['instructions']);
  }

}