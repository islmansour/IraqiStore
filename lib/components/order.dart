import 'package:flutter/material.dart';
import 'package:hardwarestore/models/orders.dart';
import 'package:hardwarestore/services/django_services.dart';
import 'package:provider/provider.dart';

import '../services/tools.dart';
import '../widgets/order_mini_admin.dart';

// class OrdersList extends StatefulWidget {
//   const OrdersList({Key? key}) : super(key: key);
//   @override
//   State<OrdersList> createState() => _OrdersListState();
// }

// class _OrdersListState extends State<OrdersList> {
//   List<Order>? myOrders;
//   var isLoaded = false;
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<Order>?>(
//         future: DjangoServices().getOrders(),
//         builder: (context, AsyncSnapshot<List<Order>?> orderSnap) {
//           if (orderSnap.connectionState == ConnectionState.none &&
//               orderSnap.hasData == null) {
//             return Container();
//           }
//           int len = orderSnap.data?.length ?? 0;
//           Provider.of<CurrentOrdersUpdate>(context).setOrders(orderSnap.data);

//           return ExpansionTile(
//               title: Text(
//                 'הזמנות ' + len.toString() + ' ' + 'פתוחות',
//                 style: const TextStyle(
//                   fontSize: 16.0,
//                   color: Colors.lightBlue,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               children: [
//                 ListTile(
//                     title: SizedBox(
//                         height: MediaQuery.of(context).size.height / 2,
//                         child: Scrollbar(
//                             child: ListView.builder(
//                                 scrollDirection: Axis.vertical,
//                                 shrinkWrap: true,
//                                 itemCount: orderSnap.data?.length ?? 0,
//                                 itemBuilder: (context, index) {
//                                   Provider.of<OrderModification>(context,
//                                           listen: false)
//                                       .update(orderSnap.data![index]);

//                                   return Column(
//                                     children: [
//                                       OrderMiniAdmin(
//                                           item: orderSnap.data![index]),
//                                     ],
//                                   );
//                                 }))))
//               ]);
//         });
//   }
// }

class CurrentOrdersUpdate extends ChangeNotifier {
  List<Order>? orders;

  void updateOrder(Order order) {
    orders?.add((order));
    notifyListeners();
  }

  void setOrders(List<Order>? newOrdersSet) {
    orders = newOrdersSet;
    //notifyListeners();
  }
}

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
          Provider.of<CurrentOrdersUpdate>(context).setOrders(orderSnap.data);
          if (orderSnap.data != null) {
            Provider.of<OrderModification>(context, listen: false).orders =
                orderSnap.data!;
          }

          return ExpansionTile(
              title: Text(
                'הזמנות ' + len.toString() + ' ' + 'פתוחות',
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.lightBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                                    children: [
                                      OrderMiniAdmin(
                                          item: orderSnap.data![index]),
                                    ],
                                  );
                                }))))
              ]);
        });
  }
}
