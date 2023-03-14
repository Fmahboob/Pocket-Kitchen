import 'dart:ffi';
import 'package:mysql1/mysql1.dart';

class PantryUser {
  String? id;
  String? pantryId;
  String? userId;

  PantryUser({
    this.id,
    this.pantryId,
    this.userId
  });

  factory PantryUser.fromJson(Map<String, dynamic> json) {
    return PantryUser(
        id: json['pantry_user_id'] as String,
        pantryId: json['pantry_id'] as String,
        userId: json['user_id'] as String
    );
  }
}