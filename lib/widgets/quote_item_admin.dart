import 'package:flutter/material.dart';
import 'package:hardwarestore/models/quote_item.dart';
import 'package:hardwarestore/models/products.dart';
import 'package:hardwarestore/services/api.dart';
import 'package:hardwarestore/services/django_services.dart';
import 'package:hardwarestore/services/tools.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/quote.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QuoteItemAdmin extends StatefulWidget {
  final QuoteItem item;
  final int quoteId;

  const QuoteItemAdmin({
    Key? key,
    required this.item,
    required this.quoteId,
  }) : super(key: key);

  @override
  State<QuoteItemAdmin> createState() => _QuoteItemAdminState();
}

class _QuoteItemAdminState extends State<QuoteItemAdmin> {
  double quantity = 0;
  double discount = 0;
  bool recordChanged = false;

  @override
  void initState() {
    // TODO: implement initState
    discount = widget.item.discount ?? 0;
    quantity = widget.item.quantity ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var translation = AppLocalizations.of(context);

    var format = NumberFormat.simpleCurrency(locale: 'he');
    Product? _product;

    _product = Provider.of<EntityModification>(context)
        .products
        .where((f) => f.id == widget.item.productId)
        .first;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: Colors.lightGreen.shade400),
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  topLeft: Radius.circular(20))),
          height: 120,
          width: double.infinity,
          child: Row(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.lightGreen,
                          borderRadius: BorderRadius.only(
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
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text(
                                  _product.name.toString(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.0,
                                  ),
                                ),
                                Row(
                                  children: [
                                    // Text(
                                    //     widget.item.price!
                                    //             .toStringAsFixed(2)
                                    //             .toString() +
                                    //         " " +
                                    //         format.currencySymbol +
                                    //         " ",
                                    //     style: Theme.of(context)
                                    //         .textTheme
                                    //         .bodyMedium),
                                    Container(
                                      alignment: Alignment.center,
                                      width: 60,
                                      child: TextFormField(
                                        enabled: false,
                                        style: const TextStyle(fontSize: 12),
                                        initialValue: _product.price == null
                                            ? "0"
                                            : _product.price.toString(),
                                        onChanged: null,
                                        keyboardType: const TextInputType
                                            .numberWithOptions(),
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,

                                          labelStyle: TextStyle(fontSize: 12),
                                          // border: OutlineInputBorder(),0
                                          labelText: '₪',
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(right: 4),
                                      alignment: Alignment.center,
                                      width: 60,
                                      child: TextFormField(
                                        style: const TextStyle(fontSize: 12),
                                        initialValue: discount.toString(),
                                        onChanged: (value) {
                                          setState(() {
                                            recordChanged = true;

                                            try {
                                              discount = double.parse(value);
                                            } catch (e) {
                                              discount = 0;
                                            }
                                          });
                                        },
                                        keyboardType: const TextInputType
                                            .numberWithOptions(),
                                        decoration: const InputDecoration(
                                          labelStyle: TextStyle(fontSize: 12),
                                          border: InputBorder.none,

                                          // border: OutlineInputBorder(),0
                                          labelText: '%',
                                        ),
                                      ),
                                    )
                                    // Text(
                                    //     "הנחה:" +
                                    //         ' ' +
                                    //         _product.discount.toString() +
                                    //         ' %',
                                    //     style: Theme.of(context)
                                    //         .textTheme
                                    //         .bodyMedium),
                                  ],
                                ),
                                Text(_product.desc.toString(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                  padding: EdgeInsets.only(top: 22),
                                  alignment: Alignment.bottomCenter,
                                  width: 40,
                                  child: TextFormField(
                                    style: TextStyle(fontSize: 12),
                                    initialValue:
                                        widget.item.quantity.toString(),
                                    onChanged: (value) {
                                      setState(() {
                                        try {
                                          quantity = double.parse(value);
                                        } catch (e) {
                                          quantity = 0;
                                        }
                                        recordChanged = true;
                                      });
                                    },
                                    keyboardType:
                                        const TextInputType.numberWithOptions(),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,

                                      labelStyle: TextStyle(fontSize: 12),
                                      // border: OutlineInputBorder(),0
                                      labelText: '#',
                                    ),
                                  )),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    translation!.totalAmount + ' ',
                                    style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    (_product.price! * widget.item.quantity! -
                                            (widget.item.quantity! *
                                                (widget.item.discount! *
                                                    _product.price! /
                                                    100)))
                                        .toString(),
                                    style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                            ],
                          ),
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
                          color:
                              recordChanged ? Colors.lightGreen : Colors.grey,
                          borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      //   height: 75,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.done_rounded,
                              color: Colors.white,
                              size: 34,
                            ),
                            //       tooltip: 'עדכון',
                            onPressed: recordChanged
                                ? () {
                                    setState(() {
                                      try {
                                        QuoteItem _updatedItem = QuoteItem();
                                        Quote x = Provider.of<
                                                    EntityModification>(context,
                                                listen: false)
                                            .quotes
                                            .where((element) =>
                                                element.id == widget.quoteId)
                                            .first;

                                        x.quoteItems!
                                            .where(
                                                (it) => it.id == widget.item.id)
                                            .forEach((_item) {
                                          _item.quantity = quantity;
                                          _item.discount = discount;

                                          _item.price = (_product!.price! -
                                                  (_product.price! *
                                                      discount /
                                                      100)) *
                                              quantity;
                                          _updatedItem = _item;
                                          Repository()
                                              .upsertQuoteItem(_updatedItem)
                                              ?.then((value) {
                                            _updatedItem.id = value;
                                            _item.id = value;
                                            Provider.of<EntityModification>(
                                                    context,
                                                    listen: false)
                                                .updateQuote(x);
                                          });
                                        });
                                        Provider.of<EntityModification>(context,
                                                listen: false)
                                            .updateQuote(x);
                                      } catch (e) {
                                        print(
                                            'unable to upsert quote item, error: ' +
                                                e.toString());
                                      }
                                    });
                                  }
                                : null,
                          ),
                        ],
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
