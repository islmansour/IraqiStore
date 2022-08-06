import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'news.g.dart';

@JsonSerializable()
class News {
  String? url;
  int? id;
  String? desc;
  DateTime? date;
  bool? active;
  int? productId;
  DateTime created;

  News(this.id, this.desc, this.active, this.date, this.url, this.productId,
      this.created);

  factory News.fromJson(Map<String, dynamic> json) => _$NewsFromJson(json);

  Map<String, dynamic> toJson() => _$NewsToJson(this);
}

List<News> newsFromJson(String str) {
  return List<News>.from(json.decode(str).map((x) => News.fromJson(x)));
}

String newsToJson(List<News> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
