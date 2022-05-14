import 'package:hardwarestore/models/quote_item.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'order_item.g.dart';

@JsonSerializable()
class OrderItem {
  int? id;
  int? productId;
  int? orderId;
  double? price;
  double? quantity;
  int? createdBy;
  String? notes;
  int? quoteId;

  OrderItem(
      {this.createdBy,
      this.id,
      this.notes,
      this.orderId,
      this.price,
      this.productId,
      this.quantity,
      this.quoteId});

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}

List<OrderItem> orderItemFromJson(String str) {
  return List<OrderItem>.from(
      json.decode(str).map((x) => OrderItem.fromJson(x)));
}

String orderItemToJson(List<OrderItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
