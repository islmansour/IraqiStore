import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'products.g.dart';

@JsonSerializable()
class Product {
  String id;
  String name;
  String desc;
  String alias;
  String createdBy;
  String img;
  String category;
  String subCategory;
  double price;
  double discount;
  DateTime created;
  bool active;

  Product(
      {required this.id,
      required this.name,
      required this.desc,
      required this.alias,
      required this.category,
      required this.subCategory,
      required this.img,
      required this.createdBy,
      required this.active,
      required this.price,
      required this.discount,
      required this.created});

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
