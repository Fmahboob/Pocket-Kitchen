import 'dart:ffi';
import 'package:mysql1/mysql1.dart';

class Food {
  String? id;
  String? name;
  String? imgUrl;
  String? category;
  String? desc;
  String? weight;
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

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
        id: json['user_id'] as String,
        name: json['name'] as String,
        imgUrl: json['img_url'] as String,
        category: json['category'] as String,
        desc: json['description'] as String,
        weight: json['weight'] as String,
        ownUnit: json['own_unit'] as bool,
        barcode: json['barcode'] as String
    );
  }
}