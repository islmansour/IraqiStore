import 'dart:convert';
//flutter packages pub run build_runner build

import 'package:flutter/material.dart';
import 'package:hardwarestore/models/contact.dart';
import 'package:hardwarestore/services/api.dart';
import 'package:hardwarestore/services/tools.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:provider/provider.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  int? id;
  String? uid;
  String? token;
  bool? active;
  int? contactId;
  int? created_by;

  @JsonKey(ignore: true)
  Contact? contact;

  User({
    this.active,
    //  this.contact,
    this.token,
    this.contactId,
    this.created_by,
    this.uid,
    this.id,
  }) {
    if (contactId != null) {
      Repository().getSingleContact(contactId.toString()).then((value) {
        if (value != null) {
          contact = value;
        }
      });
    }
  }

  Contact userContactDetails(BuildContext context) {
    return Provider.of<EntityModification>(context)
        .contacts
        .where((element) => element.id == contactId)
        .first;
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

List<User> userFromJson(String str) {
  return List<User>.from(json.decode(str).map((x) => User.fromJson(x)));
}

String userToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
