import 'package:flutter/material.dart';
import 'package:hardwarestore/components/account.dart';
import 'package:hardwarestore/models/contact.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../components/admin/lov.dart';
import '../models/account.dart';
import '../models/quote.dart';
import '../screens/admin/quote_details_admin.dart';
import '../services/tools.dart';

class QuoteMiniAdmin extends StatefulWidget {
  final Quote item;

  const QuoteMiniAdmin({Key? key, required this.item}) : super(key: key);

  @override
  State<QuoteMiniAdmin> createState() => _QuoteMiniAdminState();
}

class _QuoteMiniAdminState extends State<QuoteMiniAdmin> {
  @override
  Widget build(BuildContext context) {
    var format = NumberFormat.simpleCurrency(locale: 'he');
    String _status = "";
    try {
      _status = Provider.of<CurrentListOfValuesUpdates>(context)
          .getListOfValue('QUOTE_STATUS', format.locale)
          .where((element) => element.name == widget.item.status)
          .first
          .value!;
    } catch (e) {}

    Account? quoteAccount;
    Contact? quoteContact;

    quoteAccount = Provider.of<EntityModification>(context)
        .accounts
        .where((f) => f.id == widget.item.accountId)
        .first;

    widget.item.contactId != null && widget.item.contactId != 0
        ? quoteContact = Provider.of<EntityModification>(context)
            .contacts
            .where((f) => f.id == widget.item.contactId)
            .first
        : null;

    double sum = 0;

    widget.item.quoteItems?.forEach(
      (element) {
        if (element.price != null) sum = sum + element.price!;
      },
    );
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => QuoteDetailAdmin(
                    item: widget.item,
                  )),
        );
        // Goto a single quote screen with we display quote details and bellow that the Quote Items.
      },
      child: Card(
        child: SizedBox(
            height: 110,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // padding: const EdgeInsets.only(right: 4, top: 3),
                  height: 20,
                  width: double.infinity,
                  color: Colors.lightGreen,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          // width: MediaQuery.of(context).size.width * 0.5,
                          child: Text(
                            widget.item.quote_number.toString(),
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
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: widget.item.created == null
                      ? Text('Now',
                          style: Theme.of(context).textTheme.labelSmall)
                      : Text(
                          DateFormat('dd/MM/yy hh:mm')
                              .format(widget.item.created!),
                          style: Theme.of(context).textTheme.labelSmall),
                ),
                //  Padding(
                //     padding: const EdgeInsets.only(right: 4.0, top: 4),
                // child:
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.only(right: 4.0, top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.40,
                          // height: 35,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.business,
                                    color: Colors.green,
                                    size: 16,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.35,
                                    child: Text(quoteAccount.name ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.person,
                                      size: 16,
                                      color: Colors.green,
                                    ),
                                    Text(
                                        quoteContact != null
                                            ? quoteContact.first_name! +
                                                " " +
                                                quoteContact.last_name!
                                            : "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium,
                                        overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          // width: MediaQuery.of(context).size.width * 0.28,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.phone_iphone,
                                    //size: 20,
                                    color: Colors.green, size: 16,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    child: Text(quoteAccount.phone ?? "אין",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.phone_iphone,
                                      // size: 20,
                                      color: Colors.green, size: 16,
                                    ),
                                    Text(
                                        quoteContact != null &&
                                                quoteContact.phone != null
                                            ? quoteContact.phone!
                                            : "אין",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(flex: 7, child: Container()),
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
                                if (repo.quotes
                                    .where((element) =>
                                        element.id == widget.item.id)
                                    .isNotEmpty) {
                                  return Text(
                                      format.currencySymbol +
                                          ' ' +
                                          repo.quotes
                                              .where((element) =>
                                                  element.id == widget.item.id)
                                              .first
                                              .totalAmount
                                              .toStringAsFixed(2)
                                              .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium);
                                } else {
                                  return Text(
                                      format.currencySymbol + ' ' + '0.0',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium);
                                }
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}

class QuoteDetaulsNoInkWell extends StatefulWidget {
  final Quote item;

  QuoteDetaulsNoInkWell({Key? key, required this.item}) : super(key: key);

  @override
  State<QuoteDetaulsNoInkWell> createState() => _QuoteDetaulsNoInkWellState();
}

class _QuoteDetaulsNoInkWellState extends State<QuoteDetaulsNoInkWell> {
  @override
  Widget build(BuildContext context) {
    var format = NumberFormat.simpleCurrency(locale: 'he');
    String _status = "";
    try {
      _status = Provider.of<CurrentListOfValuesUpdates>(context)
          .getListOfValue('ORDER_STATUS', format.locale)
          .where((element) => element.name == widget.item.status)
          .first
          .value!;
    } catch (e) {}

    Account? quoteAccount;
    Contact? quoteContact;

    quoteAccount = Provider.of<EntityModification>(context)
        .accounts
        .where((f) => f.id == widget.item.accountId)
        .first;

    widget.item.contactId != null && widget.item.contactId != 0
        ? quoteContact = Provider.of<EntityModification>(context)
            .contacts
            .where((f) => f.id == widget.item.contactId)
            .first
        : null;

    double sum = 0;

    widget.item.quoteItems?.forEach(
      (element) {
        if (element.price != null) sum = sum + element.price!;
      },
    );
    return Card(
      child: SizedBox(
          height: 100,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // padding: const EdgeInsets.only(right: 4, top: 3),
                height: 20,
                width: double.infinity,
                color: Colors.lightGreen,
                child: Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        // width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(
                          widget.item.quote_number.toString(),
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
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: widget.item.created == null
                    ? Text('Now', style: Theme.of(context).textTheme.labelSmall)
                    : Text(
                        DateFormat('dd/MM/yy hh:mm')
                            .format(widget.item.created!),
                        style: Theme.of(context).textTheme.labelSmall),
              ),
              //  Padding(
              //     padding: const EdgeInsets.only(right: 4.0, top: 4),
              // child:
              Flexible(
                child: Container(
                  padding: const EdgeInsets.only(right: 4.0, top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.40,
                        // height: 35,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.business,
                                  color: Colors.green,
                                  size: 16,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  child: Text(quoteAccount.name ?? "",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.person,
                                    size: 16,
                                    color: Colors.green,
                                  ),
                                  Text(
                                      quoteContact != null
                                          ? quoteContact.first_name! +
                                              " " +
                                              quoteContact.last_name!
                                          : "",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                      overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        // width: MediaQuery.of(context).size.width * 0.28,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.phone_iphone,
                                  //size: 20,
                                  color: Colors.green, size: 16,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  child: Text(quoteAccount.phone ?? "אין",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.phone_iphone,
                                    // size: 20,
                                    color: Colors.green, size: 16,
                                  ),
                                  Text(
                                      quoteContact != null &&
                                              quoteContact.phone != null
                                          ? quoteContact.phone!
                                          : "אין",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      //  SizedBox(
                      //   width: MediaQuery.of(context).size.width * 0.10,
                      //    child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Consumer<EntityModification>(
                                builder: (context, repo, _) {
                              if (repo.quotes
                                  .where(
                                      (element) => element.id == widget.item.id)
                                  .isNotEmpty) {
                                return Text(
                                    format.currencySymbol +
                                        ' ' +
                                        repo.quotes
                                            .where((element) =>
                                                element.id == widget.item.id)
                                            .first
                                            .totalAmount
                                            .toStringAsFixed(2)
                                            .toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium);
                              } else {
                                return Text(format.currencySymbol + ' ' + '0.0',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium);
                              }
                            }),
                          ),
                        ],
                      ),
                      //   ),
                    ],
                  ),
                ),
              ),
              //  ),
            ],
          )),
    );
  }
}
