import 'package:flutter/material.dart';
import 'package:hardwarestore/services/django_services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

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
    return FutureBuilder<List<Account>?>(
        future: DjangoServices().getAccounts(),
        builder: (context, AsyncSnapshot<List<Account>?> accountSnap) {
          if (accountSnap.connectionState == ConnectionState.none &&
              accountSnap.hasData == null) {
            return Container();
          }
          int len = accountSnap.data?.length ?? 0;

          return ExpansionTile(
              title: Text('הזמנות ' + len.toString(),
                  style: Theme.of(context).textTheme.headline1),
              children: [
                ListTile(
                    title: SizedBox(
                        height: MediaQuery.of(context).size.height / 2,
                        child: Scrollbar(
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: accountSnap.data?.length ?? 0,
                                itemBuilder: (context, index) {
                                  Provider.of<CurrentAccountsUpdate>(context)
                                      .accounts = accountSnap.data;
                                  print(accountSnap.data.toString());
                                  return AccountMiniAdmin(
                                      item: accountSnap.data![index]);
                                }))))
              ]);
        });
  }
}

class CurrentAccountsUpdate extends ChangeNotifier {
  List<Account>? accounts;
  void updateAccount(Account account) {
    accounts?.add((account));
    notifyListeners();
  }

  void accountsLoaded() {
    notifyListeners();
  }
}
