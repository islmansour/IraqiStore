import 'package:flutter/material.dart';

import '../../models/account.dart';
import '../../models/contact.dart';

import '../../widgets/contact_mini_admin.dart';

class AccountContactsList extends StatefulWidget {
  Account? account;
  AccountContactsList({Key? key, required this.account}) : super(key: key);

  @override
  State<AccountContactsList> createState() => _AccountContactsListState();
}

class _AccountContactsListState extends State<AccountContactsList> {
  var isLoaded = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: widget.account?.accountContacts == null
                ? 0
                : widget.account?.accountContacts!.length ?? 0,
            itemBuilder: (context, index) {
              Contact _contact = widget.account!.accountContacts![index];
              return ContactMiniAdmin(item: _contact);
            }));
    ;
  }
}
