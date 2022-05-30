import 'package:flutter/material.dart';
import 'package:hardwarestore/services/django_services.dart';
import 'package:provider/provider.dart';

import '../models/quote.dart';
import '../services/tools.dart';
import '../widgets/quote_mini_admin.dart';

class QuotesList extends StatelessWidget {
  const QuotesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Quote>?>(
        future: DjangoServices().getQuotes(),
        builder: (context, AsyncSnapshot<List<Quote>?> quoteSnap) {
          if (quoteSnap.connectionState == ConnectionState.none &&
              quoteSnap.hasData == null) {
            return Container();
          }
          int len = quoteSnap.data?.length ?? 0;
          // Provider.of<CurrentQuotesUpdate>(context).setQuotes(quoteSnap.data);
          if (quoteSnap.data != null) {
            Provider.of<EntityModification>(context, listen: false).quotes =
                quoteSnap.data!;
          }

          return ExpansionTile(
              initiallyExpanded: false,
              title: const Text('הצעות מחיר'),
              leading: const Icon(Icons.shopping_basket),
              subtitle: Text(
                len.toString() + ' ' + 'פתוחות',
              ),
              iconColor: Colors.green,
              textColor: Colors.green,
              collapsedIconColor: Colors.green.shade300,
              collapsedTextColor: Colors.green.shade300,
              children: [
                ListTile(
                    title: SizedBox(
                        height: MediaQuery.of(context).size.height / 2,
                        child: Scrollbar(
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: quoteSnap.data?.length ?? 0,
                                itemBuilder: (context, index) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: QuoteMiniAdmin(
                                            item: quoteSnap.data![index]),
                                      ),
                                    ],
                                  );
                                }))))
              ]);
        });
  }
}
