import 'package:flutter/material.dart';
import 'package:hardwarestore/models/orders.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ClientOrderItemsTotal extends StatefulWidget {
  Order? order;
  ClientOrderItemsTotal({Key? key, this.order}) : super(key: key);

  @override
  State<ClientOrderItemsTotal> createState() => _ClientOrderItemsTotalState();
}

class _ClientOrderItemsTotalState extends State<ClientOrderItemsTotal> {
  @override
  Widget build(BuildContext context) {
    var format = NumberFormat.simpleCurrency(locale: 'he');
    var translation = AppLocalizations.of(context);

    if (widget.order == null ||
        widget.order!.orderItems == null ||
        widget.order!.orderItems!.length == 0) return Container();

    double _total = 0;

    widget.order?.orderItems!.forEach(
      (element) {
        _total += element.price == null ? 0 : element.price!;
      },
    );

    return Container(
      // width: MediaQuery.of(context).size.width * 0.8,
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 4.0, color: Colors.lightBlue.shade600),
        ),
        //color: Colors.white,
      ),
      child: ListTile(
        // leading: Text(translation!.totalAmount),
        trailing: Container(
            alignment: Alignment.topCenter,
            width: 290,
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  translation!.totalAmount,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(
                  width: 0,
                ),
                Text(
                  '${_total.toStringAsFixed(2)} ${format.currencySymbol}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            )),

        // title: Text(_name!)),
      ),
    );
  }
}
