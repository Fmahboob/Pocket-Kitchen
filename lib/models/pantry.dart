import 'dart:ffi';
import 'package:mysql1/mysql1.dart';

class Pantry {
  int? id;
  String? name;
  int? userCount;
  int? ownerId;

  Pantry({
    this.id,
    this.name,
    this.userCount,
    this.ownerId
  });
}