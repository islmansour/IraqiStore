import 'package:flutter/material.dart';
import 'package:hardwarestore/services/api.dart';
import 'package:hardwarestore/services/django_services.dart';
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

          return ExpansionTile(
              initiallyExpanded: false,
              leading: const Icon(Icons.people),
              title: const Text('אנשי קשר '),
              iconColor: Colors.orange,
              textColor: Colors.orange,
              collapsedIconColor: Colors.orange.shade300,
              collapsedTextColor: Colors.orange.shade300,
              children: [
                ListTile(
                    title: SizedBox(
                        height: MediaQuery.of(context).size.height / 2,
                        child: Scrollbar(
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: contactSnap.data?.length ?? 0,
                                itemBuilder: (context, index) {
                                  Provider.of<EntityModification>(context)
                                      .contacts = contactSnap.data!;
                                  return ContactMiniAdmin(
                                      item: contactSnap.data![index]);
                                }))))
              ]);
        });
  }
}
