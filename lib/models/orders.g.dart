// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      accountId: json['accountId'] as int?,
      orderItems: (json['orderItems'] as List<dynamic>?)
          ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      order_number: json['order_number'] as String?,
      contactId: json['contactId'] as int?,
      created: json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String),
      created_by: json['created_by'] as int?,
      id: json['id'] as int? ?? 0,
      notes: json['notes'] as String? ?? "",
      orderDate: json['orderDate'] == null
          ? null
          : DateTime.parse(json['orderDate'] as String),
      quoteId: json['quoteId'] as int?,
      status: json['status'] as String? ?? "",
      street: json['street'] as String? ?? "",
      street2: json['street2'] as String? ?? "",
      town: json['town'] as String? ?? "",
      wazeLink: json['wazeLink'] as String? ?? "",
    );

Map<String, dynamic> _$OrderToJson(Order instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'orderDate': instance.orderDate?.toIso8601String(),
    'accountId': instance.accountId,
    'contactId': instance.contactId,
    'status': instance.status,
    'street': instance.street,
    'street2': instance.street2,
    'town': instance.town,
    'wazeLink': instance.wazeLink,
    'notes': instance.notes,
    'quoteId': instance.quoteId,
    'created_by': instance.created_by,
    'created': instance.created?.toIso8601String(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('order_number', Order.toNull(instance.order_number));
  val['orderItems'] = instance.orderItems;
  return val;
}
