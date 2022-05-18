import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'contact.g.dart';

@JsonSerializable()
class Contact {
  int? id;
  String? first_name;
  String? last_name;
  String? phone;
  String? phone2;
  String? street;
  String? street2;
  int? pobox;
  int? zip;
  String? town;
  String? email;
  bool? active;
  int? createdBy;

  Contact(
      {this.active,
      this.createdBy,
      this.email,
      //this.first_name,
      this.id,
      // this.last_name,
      this.phone,
      this.phone2,
      this.pobox,
      this.street,
      this.street2,
      this.town,
      this.zip});

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);

  Map<String, dynamic> toJson() => _$ContactToJson(this);
}

List<Contact> contactFromJson(String str) {
  return List<Contact>.from(json.decode(str).map((x) => Contact.fromJson(x)));
}

String contactToJson(List<Contact> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
