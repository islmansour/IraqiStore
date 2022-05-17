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
    /*
    1 columns that has
    3 rows
      1st row: has one ListTile with one text: Quote Number + Quote Date
      2nd row: has 3 columns each as a container with a text.
        first column is the account name
        second column is the contact name
        third column : if contact exists, displays contact phone. otherwise display account phone
      3rd row: has 2 columns: First colum is Quote Status , second is dlivery status
    */
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
                      style: Theme.of(context).textTheme.headline2,
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
                          style: Theme.of(context).textTheme.headline3),
                    ],
                  ),
                  Column(
                    children: [
                      Text('contact name',
                          style: Theme.of(context).textTheme.headline3),
                    ],
                  ),
                  Column(
                    children: [
                      Text(currentAccount?.phone ?? "no phone",
                          style: Theme.of(context).textTheme.headline3),
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
