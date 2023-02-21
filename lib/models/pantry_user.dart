import 'dart:ffi';
import 'package:mysql1/mysql1.dart';

class PantryUser {
  int? id;
  int? pantryId;
  int? userId;

  PantryUser({
    this.id,
    this.pantryId,
    this.userId
  });
}