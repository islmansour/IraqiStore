import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/account.dart';
import '../../models/contact.dart';

import '../../screens/admin/new_account_contact.dart';
import '../../services/tools.dart';
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
    setState(() {
      widget.account!.loadAccountContact();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          flex: 70,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Scrollbar(
              child: Consumer<EntityModification>(builder: (context, repo, _) {
                if (repo.accounts
                    .where((element) => element.id == widget.account?.id)
                    .isNotEmpty) {
                  Account _account = repo.accounts
                      .where((element) => element.id == widget.account?.id)
                      .first;
                  return FutureBuilder<void>(
                      future: _account.loadAccountContact(),
                      builder: (context, AsyncSnapshot<void> snap) {
                        if (snap.connectionState == ConnectionState.none &&
                            snap.hasData == null) {
                          return Container();
                        }
                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: _account.accountContacts == null
                                ? 0
                                : _account.accountContacts!.length,
                            itemBuilder: (context, index) {
                              Contact _contact =
                                  _account.accountContacts![index];
                              return ContactMiniAdmin(item: _contact);
                            });
                      });
                } else {
                  return Container();
                }
              }),
            ),
          ),
        ),
        Flexible(
          flex: 10,
          child: Container(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.teal,
                    shape: const CircleBorder(), //<-- SEE HERE
                    padding: EdgeInsets.all(14),
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 35,
                  ),
                  onPressed: widget.account == null
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateAccountContactForm(
                                      // CreateNewContactForm(
                                      account: widget.account,
                                    )),
                          );
                        },
                ),
              )),
        )
      ],
    );
  }
}
