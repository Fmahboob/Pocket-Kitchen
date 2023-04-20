import 'dart:convert';

String foodToJson(Food data) => json.encode(data.toJson());

class Food {
  String? id;
  String? name;
  String? imgUrl;
  String? category;
  String? desc;
  String? weight;
  String? ownUnit;
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
        id: json['food_id'] as String,
        name: json['name'] as String,
        imgUrl: json['img_url'] as String,
        category: json['category'] as String,
        desc: json['description'] as String,
        weight: json['weight'] as String,
        ownUnit: json['own_unit'] as String,
        barcode: json['barcode'] as String
    );
  }

  factory Food.fromJsonLocal(Map<String, dynamic> json) {
    return Food(
      id: json['id'] as String,
      name: json['name'] as String,
      imgUrl: json['imgUrl'] as String,
      category: json['category'] as String,
      desc: json["desc"] as String,
      weight: json['weight'] as String,
      ownUnit: json['ownUnit'] as String,
      barcode: json['barcode'] as String
    );

  }

  Map<String, dynamic> toJson() => {
    "id" : id,
    "name" : name,
    "imgUrl" : imgUrl,
    "category" : category,
    "desc" : desc,
    "weight" : weight,
    "ownUnit" : ownUnit,
    "barcode" : barcode
  };
}