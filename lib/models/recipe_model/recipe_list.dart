class RecipeList {
  final int id;
  final String title;
  final String imageUrl;

  RecipeList({
    required this.id,
    required this.title,
    required this.imageUrl,
  });

  factory RecipeList.fromJson(Map<String, dynamic> json) {
    return RecipeList(
      id: json['id'],
      title: json['title'],
      imageUrl: json['image'],
    );
  }
}