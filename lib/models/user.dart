import 'dart:convert';
//flutter packages pub run build_runner build

import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  int? id;
  String? login;
  String? first_name;
  String? last_name;
  bool? active;
  int? created_by;

  User({
    this.active,
    this.created_by,
    //this.first_name,
    this.id,
    // this.last_name,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

List<User> userFromJson(String str) {
  return List<User>.from(json.decode(str).map((x) => User.fromJson(x)));
}

String userToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
