import 'dart:ffi';

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
}