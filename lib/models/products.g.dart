// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      active: json['active'] as bool?,
      alias: json['alias'] as String?,
      category: json['category'] as String?,
      product_number: json['product_number'] as String?,
      created_by: json['created_by'] as int?,
      desc: json['desc'] as String?,
      discount: (json['discount'] as num?)?.toDouble(),
      id: json['id'] as int?,
      img: json['img'] as String?,
      name: json['name'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      subCategory: json['subCategory'] as String?,
    );

Map<String, dynamic> _$ProductToJson(Product instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'name': instance.name,
    'desc': instance.desc,
    'alias': instance.alias,
    'created_by': instance.created_by,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('product_number', Product.toNull(instance.product_number));
  val['img'] = instance.img;
  val['category'] = instance.category;
  val['subCategory'] = instance.subCategory;
  val['price'] = instance.price;
  val['discount'] = instance.discount;
  val['active'] = instance.active;
  return val;
}
