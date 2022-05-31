import 'package:flutter/material.dart';
import 'package:hardwarestore/components/user.dart';
import 'package:hardwarestore/models/quote_item.dart';
import 'package:hardwarestore/models/products.dart';
import 'package:hardwarestore/services/tools.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/quote.dart';

class QuoteProductPick extends StatefulWidget {
  final Product item;
  final int quoteId;

  const QuoteProductPick({Key? key, required this.item, required this.quoteId})
      : super(key: key);

  @override
  State<QuoteProductPick> createState() => _QuoteProductPickState();
}

class _QuoteProductPickState extends State<QuoteProductPick> {
  double quantity = 0;

/*
 * ones a quantity is given, add the item to the current quote (to quoteItems). From the parent widget, we can then confirm and call django to add to db. 29.5
*/
  void addToQuoteItem(Quote quote, QuoteItem? quoteItem) {
    // need to add error handling, can not be on this widget with no quotes in the system.
    if (Provider.of<EntityModification>(context, listen: false).quotes ==
        null) {
      print('error while adding items to an quote, quote is null');
      return;
    }

    setState(() {
      bool newItem = true;
      if (quantity < 0) return;

      // need to add error handling, can not be on this widget with no quote in hand.
      if (quote == null) {
        print('Error receiving quote.');
        return;
      }

      // if product was already added to the quote, simply update the quantity for this item.
      quote.tmpItems?.forEach((element) {
        if (element.productId == widget.item.id) {
          newItem = false;
          element.quantity = double.parse(quantity.toString());
          Provider.of<EntityModification>(context, listen: false)
              .quotes
              .where((element) => element.id == quote.id)
              .first
              .tmpItems
              ?.forEach((i) {
            if (i.productId == element.productId) {
              i.quantity = double.parse(quantity.toString());
              i.price = (widget.item.price! -
                      (widget.item.price! * widget.item.discount! / 100)) *
                  quantity.toDouble();
            }
          });
        }
      });

      // adding a new product to the quote items of the quote.
      if (newItem) {
        if (quantity == 0) return;

        quoteItem = QuoteItem();
        quoteItem?.id = 0;
        quoteItem?.productId = widget.item.id;
        quoteItem?.quantity = quantity.toDouble();
        quoteItem?.price = (widget.item.price! -
                (widget.item.price! * widget.item.discount! / 100)) *
            quantity.toDouble();
        quoteItem?.created_by =
            Provider.of<GetCurrentUser>(context, listen: false).currentUser?.id;
        quoteItem?.quoteId = quote.id;

        // if Quote has a null quoteItems, initiate it.
        Provider.of<EntityModification>(context, listen: false)
            .quotes
            .where((element) => element.id == quote.id)
            .first
            .tmpItems ??= <QuoteItem>[];

        // once the new item is ready, add it to the quote we are working on.
        Provider.of<EntityModification>(context, listen: false)
            .quotes
            .where((element) => element.id == quote.id)
            .first
            .tmpItems
            ?.add(quoteItem!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // this is used to determine the currency
    var format = NumberFormat.simpleCurrency(locale: 'he');
    QuoteItem? quoteItem;
    Quote? quote = Provider.of<EntityModification>(context)
        .quotes
        .where((element) => element.id == widget.quoteId)
        .first;

    // if product is already in quote, take it's data and put then in the instance of the quoteItem in this widget.
    // This will allow showing the quantity that is already been added to the item.
    quote.quoteItems?.forEach(
      (item) {
        if (item.productId == widget.item.id) quoteItem = item;
      },
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: Colors.lightBlue.shade400),
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  topLeft: Radius.circular(20))),
          height: 90,
          width: double.infinity,
          child: Row(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [],
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text(
                                  widget.item.name.toString(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.0,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                        widget.item.price.toString() +
                                            " " +
                                            format.currencySymbol +
                                            " ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                    Text(
                                        "הנחה:" +
                                            ' ' +
                                            widget.item.discount.toString() +
                                            ' %',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                  ],
                                ),
                                Text(widget.item.desc.toString(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
                              ],
                            ),
                          ),
                          Container(
                              alignment: Alignment.center,
                              width: 40,
                              child: TextFormField(
                                enabled:
                                    quoteItem?.id != null && quoteItem?.id != 0
                                        ? false
                                        : true,
                                initialValue: quoteItem?.quantity.toString(),
                                onChanged: (value) {
                                  setState(() {
                                    if (value == "" ||
                                        double.parse(value) == 0) {
                                      value = "0";
                                      //this will make item disappear from UI , and if calling django to delete - it will be deleted from DB.
                                      //after that we need to notify listeners that this quote was modified, so we call the Provider update.
                                      // int? quoteItemId = quote.quoteItems
                                      //     ?.where((element) =>
                                      //         element.productId ==
                                      //         widget.item.id)
                                      //     .first
                                      //     .id;
                                      // DjangoServices()
                                      //     .deleteQuoteItem(quoteItemId!);

                                      quote.quoteItems?.removeWhere((element) =>
                                          element.productId == widget.item.id);
                                      //   // Informing listeners of the change made to the quote.
                                      //   Provider.of<EntityModification>(context,
                                      //           listen: false)
                                      //       .updateQuote(quote);
                                    }

                                    quantity = double.parse(value);
                                  });
                                  addToQuoteItem(quote, quoteItem);
                                },
                                keyboardType:
                                    const TextInputType.numberWithOptions(),
                                decoration: const InputDecoration(
                                  labelStyle: TextStyle(fontSize: 12),
                                  // border: OutlineInputBorder(),0
                                  labelText: 'כמות',
                                ),
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: quantity == 0 ? Colors.grey : Colors.lightBlue,
                          borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      //   height: 75,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [],
                      ),
                    ),
                  )
                ],
              ),
            ],
          )),
    );
  }
}
