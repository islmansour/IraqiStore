import 'package:flutter/material.dart';
import 'package:hardwarestore/models/contact.dart';
import 'package:hardwarestore/screens/chat.dart';
import 'package:hardwarestore/services/tools.dart';
import 'package:intl/intl.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hardwarestore/models/message.dart';
import 'package:provider/provider.dart';

class ChatContactAdmin extends StatefulWidget {
  final Contact contact;
  final Message message;

  const ChatContactAdmin(
      {Key? key, required this.contact, required this.message})
      : super(key: key);

  @override
  State<ChatContactAdmin> createState() => _ChatContactAdminState();
}

class _ChatContactAdminState extends State<ChatContactAdmin> {
  @override
  Widget build(BuildContext context) {
    var translation = AppLocalizations.of(context);
    var format = NumberFormat.simpleCurrency(locale: 'he');

    return InkWell(
      onTap: () {
        Provider.of<ChatListenerNotifier>(context, listen: false)
            .insureChatReload();

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatScreen(
                    contact: widget.contact,
                  )),
        );
      },
      child: Card(
          child: SizedBox(
              height: 110,
              width: double.infinity,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [Icon(Icons.mail_rounded)],
                    ),
                    Flexible(
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: widget.message.time == null
                                ? Text(translation!.now,
                                    style:
                                        Theme.of(context).textTheme.labelSmall)
                                : Text(
                                    DateFormat('dd/MM/yy hh:mm')
                                        .format(widget.message.time!),
                                    style:
                                        Theme.of(context).textTheme.labelSmall),
                          ),
                          Flexible(
                            child: Container(
                              // padding: const EdgeInsets.only(right: 4, top: 3),
                              height: 20,
                              width: double.infinity,
                              // color: Colors.lightGreen,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(widget.contact.first_name! +
                                        " " +
                                        widget.contact.last_name.toString())
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ]))),
    );
  }
}
