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
class AppUser {
  int? id;
  String? uid;
  String? token;
  bool? active;
  int? contactId;
  int? created_by;
  String? userType;
  String? language;
  bool? admin;

  @JsonKey(ignore: true)
  Contact? contact;

  AppUser({
    this.active,
    this.admin,
    this.language,
    this.userType = "",
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

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  Map<String, dynamic> toJson() => _$AppUserToJson(this);
}

List<AppUser> userFromJson(String str) {
  return List<AppUser>.from(json.decode(str).map((x) => AppUser.fromJson(x)));
}

String userToJson(List<AppUser> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
