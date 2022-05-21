import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable()
class Account {
  int? id;
  String? name;
  int? contactId;
  String? street;
  String? street2;
  int? pobox;
  int? zip;
  String? town;
  String? email;
  String? phone;
  bool? active;

  // ignore: non_constant_identifier_names
  String? account_number;
  // ignore: non_constant_identifier_names
  int? created_by;

  Account(
      {this.active,
      this.contactId,
      // ignore: non_constant_identifier_names
      this.created_by,
      // ignore: non_constant_identifier_names
      this.account_number,
      this.email,
      this.id,
      this.name,
      this.phone,
      this.pobox,
      this.street,
      this.street2,
      this.town,
      this.zip});

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);
}

List<Account> accountFromJson(String str) {
  return List<Account>.from(json.decode(str).map((x) => Account.fromJson(x)));
}

String accountToJson(List<Account> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
