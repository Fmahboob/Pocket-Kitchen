import 'dart:ffi';
import 'package:mysql1/mysql1.dart';

class PantryFood {
  int? id;
  Float? amount;
  int? pantryId;
  int? foodId;

  PantryFood({
    this.id,
    this.amount,
    this.pantryId,
    this.foodId
  });
}