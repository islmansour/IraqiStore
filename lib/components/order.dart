import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../services/tools.dart';
import '../widgets/order_mini_admin.dart';

class OrdersList extends StatefulWidget {
  const OrdersList({Key? key}) : super(key: key);

  @override
  State<OrdersList> createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EntityModification>(builder: (context, repo, _) {
      if (repo.order
          .where((element) => element.status != 'closed')
          .isNotEmpty) {
        return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Scrollbar(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: repo.order
                        .where((element) => element.status != 'closed')
                        .length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: OrderMiniAdmin(
                                item: repo.order
                                    .where(
                                        (element) => element.status != 'closed')
                                    .toList()[index]),
                          ),
                        ],
                      );
                    })));
      } else {
        return (Container());
      }
    });
  }
}

class OrdersListHome extends StatefulWidget {
  const OrdersListHome({Key? key}) : super(key: key);

  @override
  State<OrdersListHome> createState() => _OrdersListHomeState();
}

class _OrdersListHomeState extends State<OrdersListHome> {
  @override
  Widget build(BuildContext context) {
    var translation = AppLocalizations.of(context);
    return Consumer<EntityModification>(builder: (context, repo, _) {
      if (repo.order
          .where((element) => element.status != 'closed')
          .isNotEmpty) {
        return ExpansionTile(
            initiallyExpanded: false,
            title: Text(translation!.orders),
            leading: const Icon(Icons.shopping_cart),
            subtitle: Text(repo.order
                .where((element) => element.status != 'closed')
                .length
                .toString()),
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
                              itemCount: repo.order
                                  .where(
                                      (element) => element.status != 'closed')
                                  .length,
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: OrderMiniAdmin(
                                          item: repo.order
                                              .where((element) =>
                                                  element.status != 'closed')
                                              .toList()[index]),
                                    ),
                                  ],
                                );
                              }))))
            ]);
      } else {
        return (Container());
      }
    });
    //   });
  }
}
