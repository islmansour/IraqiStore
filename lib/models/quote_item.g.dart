// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuoteItem _$QuoteItemFromJson(Map<String, dynamic> json) => QuoteItem(
      quoteId: json['quoteId'] as int?,
      created_by: json['created_by'] as int?,
      discount: (json['discount'] as num?)?.toDouble(),
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
      'created_by': instance.created_by,
      'notes': instance.notes,
      'discount': instance.discount,
      'quoteId': instance.quoteId,
    };
