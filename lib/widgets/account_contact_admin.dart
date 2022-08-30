import 'package:flutter/material.dart';
import 'package:hardwarestore/models/account_contact.dart';
import 'package:hardwarestore/models/contact.dart';
import 'package:hardwarestore/services/api.dart';
import 'package:hardwarestore/services/tools.dart';
import 'package:provider/provider.dart';

import '../models/account.dart';
import '../screens/admin/new_contact.dart';

class AccountContactFrom extends StatefulWidget {
  final Contact item;
  final Account? account;

  const AccountContactFrom({
    Key? key,
    required this.item,
    this.account,
  }) : super(key: key);

  @override
  State<AccountContactFrom> createState() => _AccountContactFromState();
}

class _AccountContactFromState extends State<AccountContactFrom> {
  Contact? contactContact = Contact();
  bool isRelated = false;

  @override
  Widget build(BuildContext context) {
    if (widget.account != null) {
      if (widget.account?.accountContacts != null &&
          widget.account?.accountContacts?.isNotEmpty == true &&
          widget.account?.accountContacts
                  ?.where((element) => element.id == widget.item.id)
                  .isNotEmpty ==
              true) isRelated = true;
    }
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CreateNewContactForm(
                    item: widget.item,
                  )),
        );
      },
      child: Card(
        child: SizedBox(
            // padding: const EdgeInsets.all(5),
            height: 80,
            width: double.infinity,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        height: 24,
                        alignment: Alignment.centerRight,
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(right: 12),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Text(
                                  widget.item.first_name.toString() +
                                      ' ' +
                                      widget.item.last_name.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: isRelated ? Colors.red : Colors.teal),
                            onPressed: () {
                              if (isRelated) {
                                widget.account!.accountContacts!.removeWhere(
                                    (element) => element.id == widget.item.id);
                                Provider.of<EntityModification>(context,
                                        listen: false)
                                    .updateAccount(widget.account!);
                                Repository().deleteAccountContact(
                                    widget.account?.id, widget.item.id!);
                                isRelated = false;
                              } else {
                                widget.account?.accountContacts!
                                    .add(widget.item);
                                AccountContact ac = AccountContact(
                                    active: true,
                                    id: -1,
                                    accountId: widget.account?.id,
                                    contactId: widget.item.id);
                                Repository().insertAccountContact(ac);
                                isRelated = true;
                              }
                              Provider.of<EntityModification>(context,
                                      listen: false)
                                  .updateAccount(widget.account!);
                            },
                            child: isRelated
                                ? Icon(Icons.remove)
                                : Icon(Icons.add)),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            if (widget.item != null &&
                                widget.item.phone != null &&
                                widget.item.phone.toString() != "")
                              const Icon(
                                Icons.phone,
                                color: Colors.teal,
                              ),
                            if (widget.item != null &&
                                widget.item.phone != null &&
                                widget.item.phone.toString() != "")
                              Text(
                                widget.item.phone.toString(),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                          ],
                        ),
                      ],
                    )
                  ],
                )
              ],
            )),
      ),
    );
  }
}
