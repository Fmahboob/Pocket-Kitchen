import 'dart:ffi';
import 'package:mysql1/mysql1.dart';

class User {
  int? id;
  int? pantryId;
  int? userId;

  User({
    this.id,
    this.pantryId,
    this.userId
  });
}