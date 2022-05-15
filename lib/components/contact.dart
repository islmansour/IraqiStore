import 'package:flutter/material.dart';
import 'package:hardwarestore/services/django_services.dart';
import 'package:provider/provider.dart';

import '../models/contact.dart';
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
        future: DjangoServices().getContacts(),
        builder: (context, AsyncSnapshot<List<Contact>?> contactSnap) {
          if (contactSnap.connectionState == ConnectionState.none &&
              contactSnap.hasData == null) {
            return Container();
          }
          int len = contactSnap.data?.length ?? 0;

          return ExpansionTile(
              title: Text('אנשי קשר ' + len.toString(),
                  style: Theme.of(context).textTheme.headline1),
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
                                  Provider.of<CurrentContactsUpdate>(context)
                                      .contacts = contactSnap.data;
                                  return ContactMiniAdmin(
                                      item: contactSnap.data![index]);
                                }))))
              ]);
        });
  }
}

class CurrentContactsUpdate extends ChangeNotifier {
  List<Contact>? contacts;
  void updateContact(Contact contact) {
    contacts?.add((contact));
    notifyListeners();
  }

  void contactsLoaded() {
    notifyListeners();
  }
}
