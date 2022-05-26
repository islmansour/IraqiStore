import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:hardwarestore/components/account.dart';
import 'package:hardwarestore/components/contact.dart';
import 'package:hardwarestore/models/contact.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/account.dart';
import '../models/quote.dart';
import '../screens/admin/Quote_details_admin.dart';

class QuoteMiniAdmin extends StatelessWidget {
  final Quote item;

  const QuoteMiniAdmin({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var format = NumberFormat.simpleCurrency(locale: 'he');

    // ignore: non_constant_identifier_names
    Account? QuoteAccount;
    // ignore: non_constant_identifier_names
    Contact? QuoteContact;

    QuoteAccount = Provider.of<CurrentAccountsUpdate>(context)
        .accounts
        ?.where((f) => f.id == item.accountId)
        .first;

    item.contactId != null && item.contactId != 0
        ? QuoteContact = Provider.of<CurrentContactsUpdate>(context)
            .contacts
            ?.where((f) => f.id == item.contactId)
            .first
        : null;

    double sum = 0;
    // print(' item.QuoteItems' + item.QuoteItems!.length.toString());
    item.quoteItems?.forEach(
      (element) {
        sum = sum + element.price!;
      },
    );

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => QuoteDetailAdmin(
                    item: item,
                  )),
        );
        // Goto a single Quote screen with we display Quote details and bellow that the Quote Items.
      },
      child: SizedBox(
          height: 100,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(right: 4, top: 3),
                height: 20,
                width: double.infinity,
                color: Colors.grey.shade300,
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        item.quote_number.toString(),
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.lightGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Text(
                        item.status!,
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.lightGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: const Text(
                        'delivery',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.lightGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: item == null || item.created == null
                    ? const Text('')
                    : Text(DateFormat('dd/MM/yy hh:mm').format(item.created!),
                        style: Theme.of(context).textTheme.labelSmall),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 4.0, top: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 35,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(QuoteAccount?.name ?? "",
                              style: Theme.of(context).textTheme.displayMedium,
                              overflow: TextOverflow.ellipsis),
                          Text(
                              QuoteContact != null
                                  ? QuoteContact.first_name! +
                                      " " +
                                      QuoteContact.last_name!
                                  : "",
                              style: Theme.of(context).textTheme.displayMedium,
                              overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: Column(
                        children: [
                          Text(QuoteAccount?.phone ?? "",
                              style: Theme.of(context).textTheme.displayMedium),
                          Text(
                              QuoteContact != null && QuoteContact.phone != null
                                  ? QuoteContact.phone!
                                  : "",
                              style: Theme.of(context).textTheme.displayMedium),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: Column(
                        children: [
                          Text(
                              format.currencySymbol +
                                  ' ' +
                                  sum.toString(), //  .data.toString(),
                              style: Theme.of(context).textTheme.displayMedium)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                        decoration: DottedDecoration(
                            shape: Shape.line,
                            linePosition: LinePosition.bottom,
                            color: Colors.black),
                        child: Text('')),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
