import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hardwarestore/components/user.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hardwarestore/models/contact.dart';
import 'package:hardwarestore/models/message.dart';
import 'package:hardwarestore/services/api.dart';
import 'package:hardwarestore/services/tools.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class ClientChatScreen extends StatefulWidget {
  ClientChatScreen({
    Key? key,
  }) : super(key: key);

  @override
  _ClientChatScreenState createState() => _ClientChatScreenState();
}

class _ClientChatScreenState extends State<ClientChatScreen> {
  late Contact _con;
  late TextEditingController _controller;
  Timer? timer;

  @override
  void initState() {
    _controller = TextEditingController()..addListener(() {});
    super.initState();

    _con = Provider.of<EntityModification>(context, listen: false)
        .contacts
        .firstWhere((element) =>
            element.id ==
            Provider.of<GetCurrentUser>(context, listen: false)
                .currentUser!
                .contactId!);
    timer = Timer.periodic(Duration(seconds: 3), (Timer t) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    timer?.cancel();
    super.dispose();
  }

  _buildMessage(Message message, bool isMe) {
    Container msg = Container(
      margin: isMe
          ? EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
              left: 80.0,
            )
          : EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
            ),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        color: isMe ? Theme.of(context).accentColor : Color(0xFFFFEFEE),
        borderRadius: isMe
            ? BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
              )
            : BorderRadius.only(
                topRight: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            DateFormat('dd/MM/yy hh:mm').format(message.time!),
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            message.text!,
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
    if (isMe) {
      return msg;
    }
    return Row(
      children: <Widget>[
        msg,
      ],
    );
  }

  void publishMyMessage() {
    Message msg = Message(
        // time: DateTime.now(),
        unread: true,
        id: 0,
        receiver: 0, //_con.id,
        sender: Provider.of<GetCurrentUser>(context, listen: false)
            .currentUser!
            .contactId,
        text: _controller.text);
    Repository().upsertMessage(msg);
  }

  _buildMessageComposer() {
    //if (widget.contact == null) return Container();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          // IconButton(
          //   icon: Icon(Icons.photo),
          //   iconSize: 25.0,
          //   color: Theme.of(context).primaryColor,
          //   onPressed: () {},
          // ),
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              controller: _controller,
              onChanged: (value) {},
              decoration: InputDecoration.collapsed(
                hintText: AppLocalizations.of(context)!.sendMessage,
              ),
            ),
          ),
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(math.pi),
            child: IconButton(
              icon: Icon(Icons.play_circle_outline),
              iconSize: 40.0,
              color: Theme.of(context).primaryColor,
              onPressed: () {
                publishMyMessage();
                _controller.clear();
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(
          _con.first_name! + " " + _con.last_name!,
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_horiz),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                    child: FutureBuilder<List<Message>?>(
                        future: Repository()
                            .getMessageByContact(_con.id.toString()),
                        builder:
                            (context, AsyncSnapshot<List<Message>?> chatSnap) {
                          if (chatSnap.connectionState ==
                                  ConnectionState.none &&
                              chatSnap.hasData == null) {
                            return Container();
                          }

                          return SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.80,
                              child: Scrollbar(
                                  // In DB we return the list of messages in a reversed order then in the listview builder
                                  // we use "reverse:true" this will allow showing latest message at the end of the chat window
                                  child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      reverse: true,
                                      itemCount: chatSnap.data?.length ?? 0,
                                      itemBuilder: (context, index) {
                                        if ((chatSnap.data![index].unread ==
                                                    null ||
                                                chatSnap.data![index].unread ==
                                                    true) &&
                                            chatSnap.data![index].sender == 0) {
                                          // Using "0" for admin users, so for this we display chat for all admins as in the client
                                          // is always communicating with the store. In the store we can have multiple managers.
                                          // therefore when adding a message reset sender=0 (when client receiving)
                                          chatSnap.data![index].unread = false;
                                          Repository().upsertMessage(
                                              chatSnap.data![index]);
                                        }
                                        return chatSnap.data![index].receiver ==
                                                Provider.of<GetCurrentUser>(
                                                        context,
                                                        listen: false)
                                                    .currentUser!
                                                    .contactId
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  recipientUserMessage(
                                                    msg: chatSnap.data![index],
                                                  ),
                                                ],
                                              )
                                            : Row(
                                                children: [
                                                  currentUserMessage(
                                                    msg: chatSnap.data![index],
                                                  )
                                                ],
                                              );
                                      })));
                        })),
              ),
            ),
            _buildMessageComposer(),
          ],
        ),
      ),
    );
  }
}

class currentUserMessage extends StatelessWidget {
  final Message? msg;
  const currentUserMessage({Key? key, this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.green[50],
            border: Border.all(
              color: Colors.green,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        //width: MediaQuery.of(context).size.width,
        //  height: 50,
        child:
            // FittedBox(
            //   fit: BoxFit.fill,
            //   child:
            Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            //S

            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.8,
                    maxHeight: MediaQuery.of(context).size.height * 0.6,
                  ),
                  child: Text(
                    msg == null || msg!.text == null ? "" : msg!.text!,
                    maxLines: msg == null ||
                            msg!.text == "" ||
                            msg!.text!.length ~/ 20 == 0
                        ? 1
                        : msg!.text!.length ~/ 5,
                    overflow: TextOverflow.ellipsis,
                    style: msg!.unread == null || msg!.unread == true
                        ? TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold)
                        : TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(
                  //width: 50,
                  child: Center(
                    child: Text(
                      msg == null || msg!.time == null
                          ? ""
                          : DateFormat('dd/MM/yy hh:mm').format(msg!.time!),
                      style: TextStyle(fontSize: 8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class recipientUserMessage extends StatelessWidget {
  final Message? msg;
  const recipientUserMessage({Key? key, this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color: Colors.grey[200],
            border: Border.all(
              color: Colors.white,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        //width: MediaQuery.of(context).size.width,
        //  height: 50,
        child:
            // FittedBox(
            //   fit: BoxFit.fill,
            //   child:
            Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            //S

            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                    maxHeight: MediaQuery.of(context).size.height * 0.6,
                  ),
                  child: Text(
                      msg == null || msg!.text == null ? "" : msg!.text!,
                      maxLines: msg == null ||
                              msg!.text == "" ||
                              msg!.text!.length ~/ 20 == 0
                          ? 1
                          : msg!.text!.length ~/ 5,
                      overflow: TextOverflow.ellipsis),
                ),
                SizedBox(
                  //width: 50,
                  child: Center(
                    child: Text(
                      msg == null || msg!.time == null
                          ? ""
                          : DateFormat('dd/MM/yy hh:mm').format(msg!.time!),
                      style: TextStyle(fontSize: 8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
