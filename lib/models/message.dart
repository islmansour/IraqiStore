import 'dart:convert';

import 'package:hardwarestore/models/user.dart';
import 'package:hardwarestore/services/api.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class Message {
  final int? id;
  final int? sender;
  final int? receiver;
  final DateTime? time;
  final String? text;
  bool? unread;

  Message({
    this.receiver,
    this.id,
    this.sender,
    this.time,
    this.text,
    this.unread,
  });

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}

void loadMessages(String contactId) async {
  print('---1----');
  messages = await Repository().getMessageByContact(contactId);
}

// CURRENT USER
AppUser? currentUser;

// OTHER USER
AppUser? randomChatUser;

// EXAMPLE MESSAGES IN CHAT SCREEN
List<Message>? messages = [
  // Message(
  //   sender: currentUser,
  //   time: '4:32 PM',
  //   text: "Nothing much, just trying out Ably's new Flutter plugin",
  //   unread: true,
  // ),
  // Message(
  //   sender: randomChatUser,
  //   time: '4:30 PM',
  //   text: "Hey, how's it going?",
  //   unread: true,
  // ),
];

List<Message> messageFromJson(String str) {
  return List<Message>.from(json.decode(str).map((x) => Message.fromJson(x)));
}

String messageToJson(List<Message> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
