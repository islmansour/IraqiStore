import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'orders.g.dart';

@JsonSerializable()
class Order {
  int id;
  String orderDate;
  int accountId;
  int contactId;
  String status;
  String street;
  String street2;
  String town;
  String wazeLink;
  String notes;
  int quoteId;
  String createdBy;
//  String created;

  Order(
      {this.accountId = 0,
      this.contactId = 0,
      //     this.created = "",
      this.createdBy = "",
      this.id = 0,
      this.notes = "",
      this.orderDate = "",
      this.quoteId = 0,
      this.status = "",
      this.street = "",
      this.street2 = "",
      this.town = "",
      this.wazeLink = ""});

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$OrderToJson(this);
}

List<Order> orderFromJson(String str) {
  return List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));
}

String orderToJson(List<Order> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
