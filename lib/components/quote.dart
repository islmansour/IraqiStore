import 'package:flutter/material.dart';
import 'package:hardwarestore/models/quote.dart';

import '../services/django_services.dart';
import '../widgets/quote_mini_admin.dart';

class QuotesList extends StatefulWidget {
  QuotesList({Key? key}) : super(key: key);

  @override
  State<QuotesList> createState() => _QuotesListState();
}

class _QuotesListState extends State<QuotesList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Quote>?>(
        future: DjangoServices().getQuotes(),
        builder: (context, AsyncSnapshot<List<Quote>?> orderSnap) {
          if (orderSnap.connectionState == ConnectionState.none &&
              orderSnap.hasData == null) {
            return Container();
          }
          int len = orderSnap.data?.length ?? 0;

          return ExpansionTile(
              title: Text('הצעות ' + len.toString(),
                  style: Theme.of(context).textTheme.headline1),
              children: [
                ListTile(
                    title: SizedBox(
                        height: MediaQuery.of(context).size.height / 2,
                        child: Scrollbar(
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: orderSnap.data?.length ?? 0,
                                itemBuilder: (context, index) {
                                  return QuoteMiniAdmin(
                                      item: orderSnap.data![index]);
                                }))))
              ]);
        });
  }
}

class CurrentQuotesUpdate extends ChangeNotifier {
  List<Quote> quotes = [];
  void updateQuote(Quote quote) {
    quotes.add((quote));
    notifyListeners();
  }
}
