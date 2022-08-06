import 'package:flutter/material.dart';
import 'package:hardwarestore/components/admin/lov.dart';
import 'package:hardwarestore/components/client/client_order_item_total.dart';
import 'package:hardwarestore/components/client/order_items_confirmation.dart';
import 'package:hardwarestore/models/orders.dart';
import 'package:hardwarestore/services/tools.dart';
import 'package:hardwarestore/widgets/popup_dialog.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderMiniClient extends StatefulWidget {
  final Order order;

  const OrderMiniClient({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderMiniClient> createState() => _OrderMiniClientState();
}

class _OrderMiniClientState extends State<OrderMiniClient> {
  @override
  Widget build(BuildContext context) {
    var format = NumberFormat.simpleCurrency(locale: 'he');
    var translation = AppLocalizations.of(context);

    String _status = "";
    String _accName = "";

    try {
      _status = Provider.of<CurrentListOfValuesUpdates>(context)
          .getListOfValue(
              'ORDER_STATUS', AppLocalizations.of(context)!.localeName)
          .where((element) => element.name == widget.order.status)
          .first
          .value!;
    } catch (e) {}

    try {
      _accName = Provider.of<EntityModification>(context)
          .accounts
          .where((element) => element.id == widget.order.accountId)
          .first
          .name!;
    } catch (e) {}
    double sum = 0;

    widget.order.orderItems?.forEach(
      (element) {
        if (element.price != null) sum = sum + element.price!;
      },
    );
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return ShowDiaglog(
              actions: [
                ClientOrderItemsConfirmation(
                  order: widget.order,
                ),
              ],
              title: translation!.orderNum + ': ' + widget.order.order_number!,
              content: translation.status + ': ' + _status,
            );
          },
        );
      },
      child: Card(
        child: SizedBox(
            height: 70,
            width: double.infinity,
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // padding: const EdgeInsets.only(right: 4, top: 3),
                    height: 20,
                    width: double.infinity,
                    color: Colors.redAccent,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            // width: MediaQuery.of(context).size.width * 0.5,
                            child: Text(
                              widget.order.order_number.toString(),
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: Text(
                              _status,
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: widget.order.created == null
                            ? Text(AppLocalizations.of(context)!.na,
                                style: Theme.of(context).textTheme.labelSmall)
                            : Text(
                                DateFormat('dd/MM/yy hh:mm')
                                    .format(widget.order.created!),
                                style: Theme.of(context).textTheme.labelSmall),
                      ),
                      Flexible(
                        flex: 3,
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Consumer<EntityModification>(
                                    builder: (context, repo, _) {
                                  if (repo.order
                                      .where((element) =>
                                          element.id == widget.order.id)
                                      .isNotEmpty) {
                                    return Text(
                                        format.currencySymbol +
                                            ' ' +
                                            repo.order
                                                .where((element) =>
                                                    element.id ==
                                                    widget.order.id)
                                                .first
                                                .totalAmount
                                                .toStringAsFixed(2)
                                                .toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge);
                                  } else {
                                    return Text(
                                        format.currencySymbol + ' ' + '0.0',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge);
                                  }
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 4.0, left: 4),
                    child: Text(_accName,
                        style: Theme.of(context).textTheme.headlineMedium),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
