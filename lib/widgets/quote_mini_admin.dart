import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/account.dart';
import '../models/account.dart';
import '../models/quote.dart';
import '../screens/admin/quote_details_admin.dart';

class QuoteMiniAdmin extends StatelessWidget {
  final Quote item;
  const QuoteMiniAdmin({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Account? currentAccount;

    currentAccount = Provider.of<CurrentAccountsUpdate>(context, listen: false)
        .accounts
        ?.where((f) => f.id == item.accountId)
        .first;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => QuoteDetailAdmin(
                    item: item,
                  )),
        );
      },
      child: Container(
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
                    Text(item.accountId.toString(),
                        style: Theme.of(context).textTheme.subtitle1),
                  ],
                ),
              ]),
              Row(
                children: [
                  Column(
                    children: [
                      Text(currentAccount?.name ?? "no name",
                          style: Theme.of(context).textTheme.displayMedium),
                    ],
                  ),
                  Column(
                    children: [
                      Text('contact 1111name',
                          style: Theme.of(context).textTheme.displayMedium),
                    ],
                  ),
                  Column(
                    children: [
                      Text(currentAccount?.phone ?? "no phone",
                          style: Theme.of(context).textTheme.displayMedium),
                    ],
                  )
                ],
              ),
              Row(
                children: [
                  Column(
                    children: [
                      Text('quote status'),
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
          )),
    );
  }
}
