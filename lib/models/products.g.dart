// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      id: json['id'] as String,
      name: json['name'] as String,
      desc: json['desc'] as String,
      alias: json['alias'] as String,
      category: json['category'] as String,
      subCategory: json['subCategory'] as String,
      img: json['img'] as String,
      createdBy: json['createdBy'] as String,
      active: json['active'] as bool,
      price: (json['price'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      created: DateTime.parse(json['created'] as String),
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'desc': instance.desc,
      'alias': instance.alias,
      'createdBy': instance.createdBy,
      'img': instance.img,
      'category': instance.category,
      'subCategory': instance.subCategory,
      'price': instance.price,
      'discount': instance.discount,
      'created': instance.created.toIso8601String(),
      'active': instance.active,
    };
