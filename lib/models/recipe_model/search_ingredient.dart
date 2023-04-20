class SearchIngredient {
  final int id;
  final String name;

  SearchIngredient({required this.id, required this.name});

  factory SearchIngredient.fromJson(Map<String, dynamic> json) {
    return SearchIngredient(
      id: json['id'],
      name: json['name'],
    );
  }
}