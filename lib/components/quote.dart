import 'package:flutter/material.dart';
import 'package:hardwarestore/models/quote.dart';
import 'package:provider/provider.dart';

import '../widgets/quote_mini_admin.dart';

class QuotesList extends StatefulWidget {
  QuotesList({Key? key}) : super(key: key);

  @override
  State<QuotesList> createState() => _QuotesListState();
}

class _QuotesListState extends State<QuotesList> {
  @override
  Widget build(BuildContext context) {
    return Provider.of<CurrentQuotesUpdate>(context).quotes.isNotEmpty
        ? ExpansionTile(
            title: Text(
                'הצעות ' +
                    Provider.of<CurrentQuotesUpdate>(context)
                        .quotes
                        .length
                        .toString(),
                style: Theme.of(context).textTheme.headline1),
            children: [
                ListTile(
                    title: SizedBox(
                        height: MediaQuery.of(context).size.height / 2,
                        child: Scrollbar(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount:
                                    Provider.of<CurrentQuotesUpdate>(context)
                                        .quotes
                                        .length,
                                itemBuilder: (context, index) {
                                  return QuoteMiniAdmin();
                                }))))
              ])
        : const Text('אין הצעות');
  }
}

class CurrentQuotesUpdate extends ChangeNotifier {
  List<Quote> quotes = [];
  void updateQuote(Quote quote) {
    quotes.add((quote));
    notifyListeners();
  }
}
