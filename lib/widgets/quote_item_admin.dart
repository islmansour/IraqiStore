import 'package:flutter/material.dart';
import 'package:hardwarestore/components/admin/product_admin_list_component.dart';
import 'package:hardwarestore/models/quote_item.dart';
import 'package:hardwarestore/models/products.dart';
import 'package:provider/provider.dart';

class QuoteItemAdmin extends StatelessWidget {
  final QuoteItem item;

  const QuoteItemAdmin({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Product? itemProduct;

    itemProduct = Provider.of<CurrentProductsUpdate>(context)
        .products
        ?.where((f) => f.id == item.productId)
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
                    Text(itemProduct?.name ?? "",
                        style: Theme.of(context).textTheme.displayMedium),
                  ],
                ),
                Column(
                  children: [
                    Text(item.quantity.toString(),
                        style: Theme.of(context).textTheme.displayMedium),
                  ],
                ),
                Column(
                  children: [
                    Text(item.price.toString(),
                        style: Theme.of(context).textTheme.displayMedium),
                  ],
                )
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    Text(item.notes.toString()),
                  ],
                ),
              ],
            ),
          ],
        ));
  }
}
