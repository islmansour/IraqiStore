// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      accountId: json['accountId'] as String? ?? "",
      contactId: json['contactId'] as String? ?? "",
      created: json['created'] as String? ?? "",
      createdBy: json['createdBy'] as String? ?? "",
      id: json['id'] as String? ?? "",
      notes: json['notes'] as String? ?? "",
      orderDate: json['orderDate'] as String? ?? "",
      quoteId: json['quoteId'] as String? ?? "",
      status: json['status'] as String? ?? "",
      street: json['street'] as String? ?? "",
      street2: json['street2'] as String? ?? "",
      town: json['town'] as String? ?? "",
      wazeLink: json['wazeLink'] as String? ?? "",
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'orderDate': instance.orderDate,
      'accountId': instance.accountId,
      'contactId': instance.contactId,
      'status': instance.status,
      'street': instance.street,
      'street2': instance.street2,
      'town': instance.town,
      'wazeLink': instance.wazeLink,
      'notes': instance.notes,
      'quoteId': instance.quoteId,
      'createdBy': instance.createdBy,
      'created': instance.created,
    };
