import 'package:flutter/material.dart';
import 'package:hardwarestore/services/tools.dart';
import 'package:hardwarestore/widgets/news_mini_admi.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewssList extends StatefulWidget {
  const NewssList({Key? key}) : super(key: key);

  @override
  State<NewssList> createState() => _NewssListState();
}

class _NewssListState extends State<NewssList> {
  @override
  Widget build(BuildContext context) {
    var translation = AppLocalizations.of(context);

    return Consumer<EntityModification>(builder: (context, repo, _) {
      if (repo.activeNews.isNotEmpty) {
        return ExpansionTile(
            initiallyExpanded: false,
            title: Text(translation!.news),
            leading: const Icon(Icons.shopping_cart),
            subtitle: Text(repo.activeNews.length.toString()),
            iconColor: Colors.green,
            textColor: Colors.green,
            collapsedIconColor: Colors.green.shade300,
            collapsedTextColor: Colors.green.shade300,
            children: [
              ListTile(
                title: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Scrollbar(
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: repo.activeNews.length,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: NewsMiniAdmin(
                                        item: repo.activeNews.toList()[index]),
                                  ),
                                ],
                              );
                            }))),
              )
            ]);
      } else {
        return (Container());
      }
    });
  }
}
