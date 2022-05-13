// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Delivery _$DeliveryFromJson(Map<String, dynamic> json) => Delivery(
      id: json['id'] as String? ?? "",
      orderId: json['orderId'] as String? ?? "",
      accountId: json['accountId'] as String? ?? "",
      contactId: json['contactId'] as String? ?? "",
      approvalLink: json['approvalLink'] as String? ?? "",
      date: json['date'] as String? ?? "",
      status: json['status'] as String? ?? "",
      wazeLink: json['wazeLink'] as String? ?? "",
    );

Map<String, dynamic> _$DeliveryToJson(Delivery instance) => <String, dynamic>{
      'id': instance.id,
      'accountId': instance.accountId,
      'contactId': instance.contactId,
      'status': instance.status,
      'wazeLink': instance.wazeLink,
      'approvalLink': instance.approvalLink,
      'date': instance.date,
      'orderId': instance.orderId,
    };
