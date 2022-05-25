import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'lov.g.dart';

@JsonSerializable()
class ListOfValues {
  int? id;
  String? type;
  String? name;
  String? value;
  bool? active;
  String? language;

  ListOfValues(
      {this.active, this.id, this.name, this.type, this.value, this.language});

  factory ListOfValues.fromJson(Map<String, dynamic> json) =>
      _$ListOfValuesFromJson(json);

  Map<String, dynamic> toJson() => _$ListOfValuesToJson(this);
}

List<ListOfValues> lovFromJson(String str) {
  return List<ListOfValues>.from(
      json.decode(str).map((x) => ListOfValues.fromJson(x)));
}

String lovToJson(List<ListOfValues> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
