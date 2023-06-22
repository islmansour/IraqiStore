import 'package:flutter/material.dart';
import 'package:hardwarestore/services/api.dart';
import 'package:provider/provider.dart';

import '../models/contact.dart';
import '../services/tools.dart';
import '../widgets/contact_mini_admin.dart';

class ContactsList extends StatefulWidget {
  ContactsList({Key? key}) : super(key: key);

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  List<Contact>? myContacts;
  var isLoaded = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Contact>?>(
        future: Repository().getContacts(),
        builder: (context, AsyncSnapshot<List<Contact>?> contactSnap) {
          if (contactSnap.connectionState == ConnectionState.none &&
              contactSnap.hasData == null) {
            return Container();
          }
          int len = contactSnap.data?.length ?? 0;

          return SizedBox(
              height: MediaQuery.of(context).size.height * 0.80,
              child: Scrollbar(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: contactSnap.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        Provider.of<EntityModification>(context).contacts =
                            contactSnap.data!;
                        if (contactSnap.data![index].phone != '0548004990')
                          return ContactMiniAdmin(
                              item: contactSnap.data![index]);
                        else
                          return Container();
                      })));
        });
  }
}
