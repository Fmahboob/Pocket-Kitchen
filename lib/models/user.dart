import 'dart:ffi';
import 'package:mysql1/mysql1.dart';

class User {
  int? id;
  String? email;
  String? password;

  User({
    this.id,
    this.email,
    this.password
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user_id'] as int,
      email: json['email'] as String,
      password: json['password'] as String
    );
  }
}