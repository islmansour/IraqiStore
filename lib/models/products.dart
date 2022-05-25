import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'products.g.dart';

@JsonSerializable()
class Product {
  int? id;
  String? name;
  String? desc;
  String? alias;
  // ignore: non_constant_identifier_names
  int? created_by;
  static toNull(_) => null;
  @JsonKey(toJson: toNull, includeIfNull: false)
  String? product_number;

  String? img;
  String? category;
  String? subCategory;
  double? price;
  double? discount;
  //DateTime created;
  bool? active;

  Product(
      {this.active,
      this.alias,
      this.category,
      // ignore: non_constant_identifier_names
      this.product_number,
      // ignore: non_constant_identifier_names
      this.created_by,
      this.desc,
      this.discount,
      this.id,
      this.img,
      this.name,
      this.price,
      this.subCategory});

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}

List<Product> productFromJson(String str) {
  return List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));
}

String productToJson(List<Product> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
