import 'dart:convert';

String pantryFoodToJson(PantryFood data) => json.encode(data.toJson());

class PantryFood {
  String? id;
  String? amount;
  String? pantryId;
  String? foodId;

  PantryFood({
    this.id,
    this.amount,
    this.pantryId,
    this.foodId
  });

  factory PantryFood.fromJson(Map<String, dynamic> json) {
    return PantryFood(
        id: json['pantry_food_id'] as String,
        amount: json['amount'] as String,
        pantryId: json['pantry_id'] as String,
        foodId: json['food_id'] as String
    );
  }

  factory PantryFood.fromJsonLocal(Map<String, dynamic> json) {
    return PantryFood(
        id: json['id'] as String,
        amount: json['amount'] as String,
        pantryId: json['pantryId'] as String,
        foodId: json['foodId'] as String
    );
  }

  Map<String, dynamic> toJson() => {
    "id" : id,
    "amount" : amount,
    "pantryId" : pantryId,
    "foodId" : foodId
  };
}