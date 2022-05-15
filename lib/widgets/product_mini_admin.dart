import 'package:flutter/material.dart';
import 'package:hardwarestore/models/products.dart';

class ProductMiniAdmin extends StatelessWidget {
  final Product item;

  const ProductMiniAdmin({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /*
    1 columns that has
    3 rows
      1st row: has one ListTile with one text: Product Number + Product Date
      2nd row: has 3 columns each as a container with a text.
        first column is the account name
        second column is the contact name
        third column : if contact exists, displays contact phone. otherwise display account phone
      3rd row: has 2 columns: First colum is Product Status , second is dlivery status



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
                    item.name.toString(),
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ],
              ),
            ]),
            Row(
              children: [
                Column(
                  children: [
                    Text(item.price.toString(),
                        style: Theme.of(context).textTheme.headline3),
                  ],
                ),
                Column(
                  children: [
                    Text(item.desc.toString(),
                        style: Theme.of(context).textTheme.headline3),
                  ],
                ),
                Column(
                  children: [
                    Text(item.active.toString(),
                        style: Theme.of(context).textTheme.headline3),
                  ],
                )
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    Text(''),
                  ],
                )
              ],
            ),
          ],
        ));
  }
}
