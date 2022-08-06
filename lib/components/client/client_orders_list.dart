import 'package:flutter/material.dart';
import 'package:hardwarestore/components/user.dart';

import 'package:hardwarestore/services/api.dart';
import 'package:hardwarestore/widgets/client/client_order.dart';
import 'package:provider/provider.dart';

import '../../models/orders.dart';

class ClientOrderList extends StatefulWidget {
  ClientOrderList({
    Key? key,
  }) : super(key: key);

  @override
  State<ClientOrderList> createState() => _ClientOrderListState();
}

class _ClientOrderListState extends State<ClientOrderList> {
  var isLoaded = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Order>?>(
        future: Repository().getOrdersByUser(
            Provider.of<GetCurrentUser>(context).currentUser!.contactId),
        builder: (context, AsyncSnapshot<List<Order>?> ordersSnap) {
          if (ordersSnap.connectionState == ConnectionState.none &&
              // ignore: unnecessary_null_comparison
              ordersSnap.hasData == null) {
            return Container();
          }

          return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: ordersSnap.data == null ? 0 : ordersSnap.data!.length,
              itemBuilder: (context, index) {
                return OrderMiniClient(order: ordersSnap.data![index]);
              });
          //OrderMiniClient();
        });
  }
}
