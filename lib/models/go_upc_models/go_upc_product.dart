class GoUPCProduct {
  String? name;
  String? description;
  String? region;
  String? imageUrl;
  String? brand;
  List<dynamic>? specs;
  String? category;
  int? upc;
  int? ean;

  GoUPCProduct({
    this.name,
    this.description,
    this.region,
    this.imageUrl,
    this.brand,
    this.specs,
    this.category,
    this.upc,
    this.ean
  });

  factory GoUPCProduct.fromJson(Map<String, dynamic> json) {
    return GoUPCProduct(
        name: json['name'] as String,
        description: json['description'] as String,
        region: json['region'] as String,
        imageUrl: json['imageUrl'] as String,
        brand: json['brand'] as String,
        specs: json['specs'] as List<dynamic>,
        category: json['category'] as String,
        upc: json['upc'] as int,
        ean: json['ean'] as int
    );
  }
}