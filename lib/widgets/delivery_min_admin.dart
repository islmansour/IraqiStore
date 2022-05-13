import 'package:flutter/material.dart';
import 'package:hardwarestore/models/delivery.dart';

class DeliveryMiniAdmin extends StatelessWidget {
  final Delivery item;

  const DeliveryMiniAdmin({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /*
    1 columns that has
    3 rows
      1st row: has one ListTile with one text: Delivery Number + Delivery Date
      2nd row: has 3 columns each as a container with a text.
        first column is the account name
        second column is the contact name
        third column : if contact exists, displays contact phone. otherwise display account phone
      3rd row: has 2 columns: First colum is Delivery Status , second is dlivery status



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
                    item.orderId,
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ],
              ),
            ]),
            Row(
              children: [
                Column(
                  children: [
                    Text(item.accountId,
                        style: Theme.of(context).textTheme.headline3),
                  ],
                ),
                Column(
                  children: [
                    Text(item.contactId,
                        style: Theme.of(context).textTheme.headline3),
                  ],
                ),
                Column(
                  children: [
                    Text(item.status,
                        style: Theme.of(context).textTheme.headline3),
                  ],
                )
              ],
            ),
            Row(
              children: [
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
