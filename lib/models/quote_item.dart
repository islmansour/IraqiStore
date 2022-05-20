import 'package:hardwarestore/models/quote_item.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'quote_item.g.dart';

@JsonSerializable()
class QuoteItem {
  int? id;
  int? productId;
  double? price;
  double? quantity;
  int? created_by;
  String? notes;

  QuoteItem({
    this.created_by,
    this.id,
    this.notes,
    this.price,
    this.productId,
    this.quantity,
  });

  factory QuoteItem.fromJson(Map<String, dynamic> json) =>
      _$QuoteItemFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$QuoteItemToJson(this);
}

List<QuoteItem> quoteItemFromJson(String str) {
  return List<QuoteItem>.from(
      json.decode(str).map((x) => QuoteItem.fromJson(x)));
}

String quoteItemToJson(List<QuoteItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
