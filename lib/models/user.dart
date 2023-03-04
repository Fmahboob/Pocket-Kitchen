import 'dart:ffi';

class User {
  String? id;
  String? email;
  String? password;

  User({
    this.id,
    this.email,
    this.password
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user_id'] as String,
      email: json['email'] as String,
      password: json['password'] as String
    );
  }
}