import 'package:flutter/material.dart';
import 'package:hardwarestore/models/orders.dart';
import 'package:hardwarestore/services/tools.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ClientOrderItemsConfirmation extends StatefulWidget {
  Order? order;
  ClientOrderItemsConfirmation({Key? key, this.order}) : super(key: key);

  @override
  State<ClientOrderItemsConfirmation> createState() =>
      _ClientOrderItemsConfirmationState();
}

class _ClientOrderItemsConfirmationState
    extends State<ClientOrderItemsConfirmation> {
  @override
  Widget build(BuildContext context) {
    var format = NumberFormat.simpleCurrency(locale: 'he');
    var translation = AppLocalizations.of(context);

    if (widget.order == null ||
        widget.order!.orderItems == null ||
        widget.order!.orderItems!.length == 0)
      return Container(
          height: 100,
          width: 100,
          alignment: Alignment.center,
          child: Text(translation!.noRecords));

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.35,
      width: MediaQuery.of(context).size.width * 0.8,
      child: ListView.builder(
          itemCount: widget.order?.orderItems!.length,
          itemBuilder: (BuildContext context, int index) {
            String? _price = widget.order?.orderItems![index].price != null
                ? '${widget.order?.orderItems![index].price!.toStringAsFixed(2)} ${format.currencySymbol}'
                : "" + ' ' + format.currencySymbol + " ";
            String? _quantity =
                widget.order?.orderItems![index].quantity.toString();
            String? _name = Provider.of<EntityModification>(context)
                .products
                .where((element) =>
                    widget.order?.orderItems![index].productId == element.id)
                .first
                .name;

            return SizedBox(
              width: 100,
              height: 60,
              child: ListTile(
                  //  leading: const Icon(Icons.done),
                  trailing: SizedBox(
                    width: 120,
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_quantity!),
                        SizedBox(
                          width: 10,
                        ),
                        Text(_price),
                      ],
                    ),
                  ),
                  title: Text(_name!)),
            );
          }),
    );
  }
}
