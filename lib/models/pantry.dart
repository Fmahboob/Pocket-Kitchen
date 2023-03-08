class Pantry {
  String? id;
  String? name;
  String? userCount;
  String? ownerId;

  Pantry({
    this.id,
    this.name,
    this.userCount,
    this.ownerId
  });

  factory Pantry.fromJson(Map<String, dynamic> json) {
    return Pantry(
        id: json['pantry_id'] as String,
        name: json['name'] as String,
        userCount: json['user_count'] as String,
        ownerId: json['owner_id'] as String
    );
  }
}