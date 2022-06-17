import 'package:flutter/material.dart';
import 'package:hardwarestore/models/account.dart';

class AccountDetailedAdmin extends StatelessWidget {
  final Account item;

  const AccountDetailedAdmin({Key? key, required this.item}) : super(key: key);

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
    return SizedBox(
        // padding: const EdgeInsets.all(5),
        height: 120,
        width: double.infinity,
        child: Column(
          children: [
            Row(children: [
              Flexible(
                  flex: 30, // 15%
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue.shade400,
                        borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    height: 20,
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Text(
                          item.account_number.toString(),
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                      ],
                    ),
                  )),
              Flexible(
                  flex: 70, // 60%
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue.shade400,
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            topLeft: Radius.circular(10))),
                    height: 20,
                    alignment: Alignment.centerRight,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Text(item.name.toString(),
                              style: Theme.of(context).textTheme.displayMedium),
                        ),
                      ],
                    ),
                  )),
            ]),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, right: 12),
              child: Row(
                children: [
                  Flexible(
                      flex: 30, // 15%
                      child: Container(
                        alignment: Alignment.topRight,
                        child: Column(
                          children: [
                            Text(
                              item.phone.toString(),
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                          ],
                        ),
                      )),
                  Flexible(
                      flex: 70, // 60%
                      child: Container(
                        alignment: Alignment.topRight,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: Text(item.email.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium),
                            ),
                          ],
                        ),
                      )),
                  Column(
                    children: [],
                  )
                ],
              ),
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
