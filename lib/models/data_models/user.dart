import 'dart:ffi';

class User {
  String? id;
  String? email;

  User({
    this.id,
    this.email
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user_id'] as String,
      email: json['email'] as String
    );
  }
}