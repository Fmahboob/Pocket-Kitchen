class GoUPCProduct {
  String? name;
  String? description;
  String? imageUrl;
  String? brand;
  Map<String, String>? specs;
  String? category;

  GoUPCProduct({
    this.name,
    this.description,
    this.imageUrl,
    this.brand,
    this.specs,
    this.category
  });

  factory GoUPCProduct.fromJson(Map<String, dynamic> json) {
    return GoUPCProduct(
        name: json['name'] as String,
        description: json['description'] as String,
        imageUrl: json['imageUrl'] as String,
        brand: json['brand'] as String,
        specs: json['specs'] as Map<String, String>,
        category: json['category'] as String
    );
  }
}