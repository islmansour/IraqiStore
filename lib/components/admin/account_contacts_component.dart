import 'package:flutter/material.dart';
import 'package:hardwarestore/services/api.dart';
import 'package:hardwarestore/widgets/account_contact_admin.dart';
import 'package:provider/provider.dart';

import '../../models/contact.dart';
import '../../services/tools.dart';

class AccountContactsList extends StatefulWidget {
  AccountContactsList({Key? key}) : super(key: key);

  @override
  State<AccountContactsList> createState() => _AccountContactsListState();
}

class _AccountContactsListState extends State<AccountContactsList> {
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
                        return AccountContactFrom(
                            item: contactSnap.data![index]);
                      })));
        });
  }
}
