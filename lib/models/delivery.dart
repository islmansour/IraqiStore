import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'delivery.g.dart';

@JsonSerializable()
class Delivery {
  int? id;
  int? accountId;
  int? contactId;
  String? status;
  String? wazeLink;
  String? approvalLink;
  String? date;
  int? orderId;

  Delivery(
      {this.id,
      this.orderId,
      this.accountId,
      this.contactId,
      this.approvalLink,
      this.date,
      this.status,
      this.wazeLink});

  factory Delivery.fromJson(Map<String, dynamic> json) =>
      _$DeliveryFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryToJson(this);
}

List<Delivery> deliveryFromJson(String str) {
  return List<Delivery>.from(json.decode(str).map((x) => Delivery.fromJson(x)));
}

String deliveryToJson(List<Delivery> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
