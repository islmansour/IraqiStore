import 'package:flutter/material.dart';
import 'package:hardwarestore/services/django_services.dart';
import 'package:provider/provider.dart';

import '../models/quote.dart';
import '../services/tools.dart';
import '../widgets/quote_mini_admin.dart';

class QuotesList extends StatefulWidget {
  const QuotesList({Key? key}) : super(key: key);

  @override
  State<QuotesList> createState() => _QuotesListState();
}

class _QuotesListState extends State<QuotesList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EntityModification>(builder: (context, repo, _) {
      if (repo.quotes
          .where((element) => element.status != 'closed')
          .isNotEmpty) {
        return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Scrollbar(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: repo.quotes
                        .where((element) => element.status != 'closed')
                        .length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: QuoteMiniAdmin(
                                item: repo.quotes
                                    .where(
                                        (element) => element.status != 'closed')
                                    .toList()[index]),
                          ),
                        ],
                      );
                    })));
      } else {
        return (Container());
      }
    });
  }
}

class QuotesListHome extends StatefulWidget {
  const QuotesListHome({Key? key}) : super(key: key);

  @override
  State<QuotesListHome> createState() => _QuotesListHomeState();
}

class _QuotesListHomeState extends State<QuotesListHome> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EntityModification>(builder: (context, repo, _) {
      if (repo.quotes
          .where((element) => element.status != 'closed')
          .isNotEmpty) {
        return ExpansionTile(
            initiallyExpanded: false,
            title: const Text('הצעות מחיר'),
            leading: const Icon(Icons.shopping_cart),
            subtitle: Text(
              repo.quotes
                      .where((element) => element.status != 'closed')
                      .length
                      .toString() +
                  ' ' +
                  'פתוחות',
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
                              itemCount: repo.quotes
                                  .where(
                                      (element) => element.status != 'closed')
                                  .length,
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: QuoteMiniAdmin(
                                          item: repo.quotes
                                              .where((element) =>
                                                  element.status != 'closed')
                                              .toList()[index]),
                                    ),
                                  ],
                                );
                              }))))
            ]);
      } else {
        return (Container());
      }
    });
    //   });
  }
}
