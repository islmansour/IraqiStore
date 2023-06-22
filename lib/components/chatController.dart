import 'package:flutter/material.dart';
import 'package:hardwarestore/components/user.dart';
import 'package:hardwarestore/services/api.dart';
import 'package:hardwarestore/widgets/chat_contact.dart';
import 'package:provider/provider.dart';
import 'package:hardwarestore/models/message.dart';
import '../models/contact.dart';
import '../services/tools.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatList extends StatefulWidget {
  ChatList({Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  List<Contact>? myContacts;
  var isLoaded = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      Provider.of<ChatListenerNotifier>(context);
    });
    return FutureBuilder<List<Message>?>(
        future: Repository().getUnreadMessageByContact(
            Provider.of<GetCurrentUser>(context)
                .currentUser!
                .contactId
                .toString()),
        builder: (context, AsyncSnapshot<List<Message>?> contactMessageSnap) {
          if ((contactMessageSnap.connectionState == ConnectionState.none &&
                  contactMessageSnap.hasData == null) ||
              contactMessageSnap.hasData == false) {
            return Container();
          }
          int len = contactMessageSnap.data?.length ?? 0;

          return SizedBox(
              height: MediaQuery.of(context).size.height * 0.80,
              child: len == 0
                  ? Container(
                      child: Center(
                      child: Text(AppLocalizations.of(context)!.noMessages),
                    ))
                  : Scrollbar(
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: contactMessageSnap.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            Contact? _con = Provider.of<EntityModification>(
                                    context,
                                    listen: false)
                                .contacts
                                .firstWhere((element) =>
                                    element.id ==
                                    contactMessageSnap.data![index].sender);
                            if (_con != null) {
                              return Container(
                                width: 100,
                                height: 50,
                                child: ChatContactAdmin(
                                  contact: _con,
                                  message: contactMessageSnap.data![index],
                                ),
                              );
                            } else
                              return Container();
                          })));
        });
  }
}
