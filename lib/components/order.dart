import 'package:flutter/material.dart';
import 'package:hardwarestore/models/orders.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../widgets/order_mini_admin.dart';

class OrdersList extends StatefulWidget {
  OrdersList({Key? key}) : super(key: key);

  @override
  State<OrdersList> createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  @override
  Widget build(BuildContext context) {
    return Provider.of<CurrentOrdersUpdate>(context).orders.isNotEmpty
        ? ExpansionTile(
            title: Text(
                'הזמנות ' +
                    Provider.of<CurrentOrdersUpdate>(context)
                        .orders
                        .length
                        .toString(),
                style: Theme.of(context).textTheme.headline1),
            children: [
                ListTile(
                    title: SizedBox(
                        height: MediaQuery.of(context).size.height / 2,
                        child: Scrollbar(
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount:
                                    Provider.of<CurrentOrdersUpdate>(context)
                                        .orders
                                        .length,
                                itemBuilder: (context, index) {
                                  return OrderMiniAdmin();
                                }))))
              ])
        : const Text('אין הזמנות');
  }
}

class CurrentOrdersUpdate extends ChangeNotifier {
  List<Order> orders = [];
  void updateOrder(Order order) {
    orders.add((order));
    notifyListeners();
  }
}
