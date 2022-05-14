import 'package:flutter/material.dart';
import 'package:hardwarestore/models/account.dart';

class AccountMiniAdmin extends StatelessWidget {
  final Account item;

  const AccountMiniAdmin({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /*
    1 columns that has
    3 rows
      1st row: has one ListTile with one text: Account Number + Account Date
      2nd row: has 3 columns each as a container with a text.
        first column is the account name
        second column is the contact name
        third column : if contact exists, displays contact phone. otherwise display account phone
      3rd row: has 2 columns: First colum is Account Status , second is dlivery status



    */
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
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  Text('date', style: Theme.of(context).textTheme.subtitle1),
                ],
              ),
            ]),
            Row(
              children: [
                Column(
                  children: [
                    Text('account name',
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
                    Text(' phone',
                        style: Theme.of(context).textTheme.headline3),
                  ],
                )
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    Text(item.active.toString()),
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
