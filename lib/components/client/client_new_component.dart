import 'package:flutter/material.dart';
import 'package:hardwarestore/components/admin/lov.dart';
import 'package:hardwarestore/models/lov.dart';
import 'package:hardwarestore/models/news.dart';
import 'package:hardwarestore/services/api.dart';
import 'package:hardwarestore/widgets/client/client_news_card.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ClientNewsComponent extends StatefulWidget {
  ClientNewsComponent({Key? key}) : super(key: key);

  @override
  State<ClientNewsComponent> createState() => _categoriesFilterState();
}

class _categoriesFilterState extends State<ClientNewsComponent> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<News>?>(
        future: Repository().getActiveNews(),
        builder: (context, AsyncSnapshot<List<News>?> newsSnap) {
          if (newsSnap.connectionState == ConnectionState.none &&
              newsSnap.hasData == null) {
            return Container();
          }

          List<Widget> newsCards = <Widget>[];

          newsSnap.data!.forEach(
            (element) {
              newsCards.add(ClientNewsCard(
                news: element,
              ));
            },
          );

          return Container();
        });
  }
}
