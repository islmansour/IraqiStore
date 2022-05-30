import 'package:flutter/material.dart';
import 'package:hardwarestore/models/orders.dart';
import 'package:hardwarestore/services/django_services.dart';
import 'package:provider/provider.dart';

import '../services/tools.dart';
import '../widgets/order_mini_admin.dart';

class OrdersList extends StatelessWidget {
  const OrdersList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Order>?>(
        future: DjangoServices().getOrders(),
        builder: (context, AsyncSnapshot<List<Order>?> orderSnap) {
          if (orderSnap.connectionState == ConnectionState.none &&
              orderSnap.hasData == null) {
            return Container();
          }
          int len = orderSnap.data?.length ?? 0;
          // Provider.of<CurrentOrdersUpdate>(context).setOrders(orderSnap.data);
          if (orderSnap.data != null) {
            Provider.of<EntityModification>(context, listen: false).orders =
                orderSnap.data!;
          }

          return ExpansionTile(
              initiallyExpanded: false,
              title: const Text('הזמנות '),
              leading: const Icon(Icons.shopping_cart),
              subtitle: Text(
                len.toString() + ' ' + 'פתוחות',
              ),
              iconColor: Colors.blue,
              textColor: Colors.blue,
              collapsedIconColor: Colors.blue.shade300,
              collapsedTextColor: Colors.blue.shade300,
              children: [
                ListTile(
                    title: SizedBox(
                        height: MediaQuery.of(context).size.height / 2,
                        child: Scrollbar(
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: orderSnap.data?.length ?? 0,
                                itemBuilder: (context, index) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: OrderMiniAdmin(
                                            item: orderSnap.data![index]),
                                      ),
                                    ],
                                  );
                                }))))
              ]);
        });
  }
}
