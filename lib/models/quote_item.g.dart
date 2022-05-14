// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuoteItem _$QuoteItemFromJson(Map<String, dynamic> json) => QuoteItem(
      createdBy: json['createdBy'] as int?,
      id: json['id'] as int?,
      notes: json['notes'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      productId: json['productId'] as int?,
      quantity: (json['quantity'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$QuoteItemToJson(QuoteItem instance) => <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'price': instance.price,
      'quantity': instance.quantity,
      'createdBy': instance.createdBy,
      'notes': instance.notes,
    };
