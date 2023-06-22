import 'package:flutter/material.dart';
import 'package:hardwarestore/components/chatController.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.clientMessages),
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [ChatList()],
          ),
        ));
  }
}
