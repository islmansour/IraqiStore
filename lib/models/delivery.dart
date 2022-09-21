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
  DateTime? date;
  int? orderId;
  String? qrData;

  Delivery(
      {this.id,
      this.qrData,
      this.accountId,
      this.orderId,
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
