import 'package:flutter/material.dart';
import 'package:hardwarestore/models/orders.dart';
import 'package:hardwarestore/services/django_services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../widgets/order_mini_admin.dart';

class OrdersList extends StatefulWidget {
  OrdersList({Key? key}) : super(key: key);

  @override
  State<OrdersList> createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  List<Order>? myOrders;
  var isLoaded = false;
  @override
  void initState() {
    super.initState();
    //  getOrders();
  }

/*   getOrders() async {
    myOrders = await DjangoServices().getOrders();
    if (myOrders != null) {
      setState(() {
        isLoaded = true;
        Provider.of<CurrentOrdersUpdate>(context, listen: false).orders =
            myOrders!;
      });
    }
  } */

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

          return ExpansionTile(
              title: Text('הזמנות ' + len.toString(),
                  style: Theme.of(context).textTheme.headline1),
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
                                  return OrderMiniAdmin(
                                      item: orderSnap.data![index]);
                                }))))
              ]);
        });
  }
}

class CurrentOrdersUpdate extends ChangeNotifier {
  List<Order> orders = [];
  void updateOrder(Order order) {
    orders.add((order));
    notifyListeners();
  }
}
