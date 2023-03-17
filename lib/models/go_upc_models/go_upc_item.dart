import 'package:pocket_kitchen/models/go_upc_models/go_upc_product.dart';

class GoUPCItem {
  String? code;
  String? codeType;
  GoUPCProduct? product;
  String? barcodeUrl;

  GoUPCItem({
    this.code,
    this.codeType,
    this.product,
    this.barcodeUrl,
  });

  factory GoUPCItem.fromJson(Map<String, dynamic> json) {
    return GoUPCItem(
        code: json['code'] as String,
        codeType: json['codeType'] as String,
        product: GoUPCProduct.fromJson(json['product']),
        barcodeUrl: json['barcodeUrl'] as String
    );
  }
}