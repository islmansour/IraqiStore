import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/account.dart';
import '../models/account.dart';
import '../models/orders.dart';

class SingleOrderAdmin extends StatelessWidget {
  final Order item;
  const SingleOrderAdmin({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Account? currentAccount;

    currentAccount = Provider.of<CurrentAccountsUpdate>(context)
        .accounts
        ?.where((f) => f.id == item.accountId)
        .first;
    return Container(
        padding: const EdgeInsets.all(15),
        height: 120,
        width: double.infinity,
        child: Column(
          children: [
            Row(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.id.toString(),
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  Text('date', style: Theme.of(context).textTheme.subtitle1),
                ],
              ),
            ]),
            Row(
              children: [
                Column(
                  children: [
                    Text(currentAccount?.name ?? "",
                        style: Theme.of(context).textTheme.displayMedium),
                  ],
                ),
                Column(
                  children: [
                    Text('contact name',
                        style: Theme.of(context).textTheme.displayMedium),
                  ],
                ),
                Column(
                  children: [
                    Text(currentAccount?.phone ?? "",
                        style: Theme.of(context).textTheme.displayMedium),
                  ],
                )
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    Text(item.status),
                  ],
                ),
                Column(
                  children: [
                    Text('delivery status'),
                  ],
                )
              ],
            ),
          ],
        ));
  }
}
