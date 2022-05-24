// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
    accountId: json['accountId'] as int? ?? 0,
    order_number: json['order_number'] as String?,
    contactId: json['contactId'] as int? ?? 0,
    created: json['created'] == null
        ? null
        : DateTime.parse(json['created'] as String),
    created_by: json['created_by'] as int?,
    id: json['id'] as int? ?? 0,
    notes: json['notes'] as String? ?? "",
    orderDate: json['orderDate'] == null
        ? null
        : DateTime.parse(json['orderDate'] as String),
    quoteId: json['quoteId'] as int? ?? 0,
    status: json['status'] as String? ?? "",
    street: json['street'] as String? ?? "",
    street2: json['street2'] as String? ?? "",
    town: json['town'] as String? ?? "",
    wazeLink: json['wazeLink'] as String? ?? "",
    orderItems: (json['items'] as List<dynamic>?)
        ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
        .toList());

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'orderDate': instance.orderDate?.toIso8601String(),
      'accountId': instance.accountId,
      'contactId': instance.contactId,
      'status': instance.status,
      'street': instance.street,
      'street2': instance.street2,
      'order_number': instance.order_number,
      'town': instance.town,
      'wazeLink': instance.wazeLink,
      'notes': instance.notes,
      'quoteId': instance.quoteId,
      'created_by': instance.created_by,
      'created': instance.created?.toIso8601String(),
      'orderItems': instance.orderItems?.map((e) => e.toJson()).toList(),
    };
