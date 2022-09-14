import 'package:flutter/material.dart';

import '../../models/account.dart';

import '../../models/orders.dart';
import '../../widgets/order_mini_admin.dart';

class AccountOrdersList extends StatefulWidget {
  Account? account;
  AccountOrdersList({Key? key, required this.account}) : super(key: key);

  @override
  State<AccountOrdersList> createState() => _AccountOrdersListState();
}

class _AccountOrdersListState extends State<AccountOrdersList> {
  var isLoaded = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        child: FutureBuilder<void>(
            future: widget.account!.loadAccountOrders(),
            builder: (context, AsyncSnapshot<void> productSnap) {
              if (productSnap.connectionState == ConnectionState.none &&
                  productSnap.hasData == null) {
                return Container();
              }

              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: widget.account?.accountOrders == null
                      ? 0
                      : widget.account?.accountOrders!.length ?? 0,
                  itemBuilder: (context, index) {
                    Order _order = widget.account!.accountOrders![index];
                    return OrderMiniAdmin(item: _order);
                  });
            }));
    ;
  }
}
