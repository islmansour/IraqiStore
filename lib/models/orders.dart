import 'package:flutter/material.dart';
import 'package:hardwarestore/models/order_item.dart';
import 'package:hardwarestore/services/django_services.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'orders.g.dart';

@JsonSerializable()
class Order extends ChangeNotifier {
  int id;
  DateTime? orderDate;
  int? accountId;
  int? contactId;
  String status;
  String street;
  String street2;
  // ignore: non_constant_identifier_names
  String town;
  String wazeLink;
  String notes;
  int? quoteId;
  // ignore: non_constant_identifier_names
  int? created_by;
  DateTime? created;
  static toNull(_) => null;
  @JsonKey(toJson: toNull, includeIfNull: false)
  String? order_number;
  @JsonKey(toJson: toNull, includeIfNull: false)
  List<OrderItem>? orderItems;

  Order(
      {this.accountId,
      this.orderItems,
      this.order_number,
      this.contactId,
      this.created,
      this.created_by,
      this.id = 0,
      this.notes = "",
      this.orderDate,
      this.quoteId,
      this.status = "",
      this.street = "",
      this.street2 = "",
      this.town = "",
      this.wazeLink = ""});

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$OrderToJson(this);

  double get totalAmount {
    double sum = 0;
    orderItems?.forEach((element) {
      if (element.price != null) sum += element.price!;
    });
    return sum;
  }
}

List<Order> orderFromJson(String str) {
  return List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));
}

String orderToJson(List<Order> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
