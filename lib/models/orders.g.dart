// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      accountId: json['accountId'] as int? ?? 0,
      order_number: json['order_number'] as String?,
      contactId: json['contactId'] as int? ?? 0,
      created_by: json['created_by'] as int?,
      id: json['id'] as int? ?? 0,
      notes: json['notes'] as String? ?? "",
      quoteId: json['quoteId'] as int? ?? 0,
      status: json['status'] as String? ?? "",
      street: json['street'] as String? ?? "",
      street2: json['street2'] as String? ?? "",
      town: json['town'] as String? ?? "",
      wazeLink: json['wazeLink'] as String? ?? "",
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
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
    };
