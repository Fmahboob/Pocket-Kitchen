import 'dart:ffi';
import 'package:mysql1/mysql1.dart';

class Food {
  int? id;
  String? name;
  String? imgUrl;
  String? category;
  String? desc;
  double? weight;
  bool? ownUnit;
  String? barcode;

  Food({
    this.id,
    this.name,
    this.imgUrl,
    this.category,
    this.desc,
    this.weight,
    this.ownUnit,
    this.barcode
  });

  Food getFood(int id) {
    String query = "SELECT * FROM foods WHERE id=" + id;
    result = mysqli_query();
  }
}