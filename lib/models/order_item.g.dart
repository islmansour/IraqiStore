// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => OrderItem(
      createdBy: json['createdBy'] as int?,
      id: json['id'] as int?,
      notes: json['notes'] as String?,
      orderId: json['orderId'] as int?,
      price: (json['price'] as num?)?.toDouble(),
      productId: json['productId'] as int?,
      quantity: (json['quantity'] as num?)?.toDouble(),
      quoteId: json['quoteId'] as int?,
    );

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'orderId': instance.orderId,
      'price': instance.price,
      'quantity': instance.quantity,
      'createdBy': instance.createdBy,
      'notes': instance.notes,
      'quoteId': instance.quoteId,
    };