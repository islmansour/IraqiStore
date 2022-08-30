import 'package:flutter/material.dart';
import 'package:hardwarestore/services/tools.dart';
import 'package:provider/provider.dart';

import '../models/account.dart';
import '../widgets/account_min_admin.dart';

class AccountsList extends StatefulWidget {
  AccountsList({Key? key}) : super(key: key);

  @override
  State<AccountsList> createState() => _AccountsListState();
}

class _AccountsListState extends State<AccountsList> {
  List<Account>? myAccounts;
  var isLoaded = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.90,
        child: Scrollbar(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount:
                    Provider.of<EntityModification>(context).accounts.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: AccountMiniAdmin(
                        item: Provider.of<EntityModification>(context)
                            .accounts[index]),
                  );
                })));
  }
}
