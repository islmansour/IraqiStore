import 'package:json_annotation/json_annotation.dart';

part 'delivery.g.dart';

@JsonSerializable()
class Delivery {
  String id;
  String accountId;
  String contactId;
  String status;
  String wazeLink;
  String approvalLink;
  String date;
  String orderId;

  Delivery(
      {this.id = "",
      this.orderId = "",
      this.accountId = "",
      this.contactId = "",
      this.approvalLink = "",
      this.date = "",
      this.status = "",
      this.wazeLink = ""});

  factory Delivery.fromJson(Map<String, dynamic> json) =>
      _$DeliveryFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryToJson(this);
}
