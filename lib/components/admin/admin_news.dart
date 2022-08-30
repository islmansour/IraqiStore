import 'package:flutter/material.dart';
import 'package:hardwarestore/models/news.dart';
import 'package:hardwarestore/services/api.dart';
import 'package:hardwarestore/services/tools.dart';
import 'package:hardwarestore/widgets/news_mini_admi.dart';
import 'package:provider/provider.dart';

class NewsList extends StatefulWidget {
  NewsList({Key? key}) : super(key: key);

  @override
  State<NewsList> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  List<News>? myNewss;
  var isLoaded = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<News>?>(
        future: Repository().getNews(),
        builder: (context, AsyncSnapshot<List<News>?> newsSnap) {
          if (newsSnap.connectionState == ConnectionState.none &&
              newsSnap.hasData == null) {
            return Container();
          }
          int len = newsSnap.data?.length ?? 0;

          return SizedBox(
              height: MediaQuery.of(context).size.height * 0.80,
              child: Scrollbar(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: newsSnap.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        Provider.of<EntityModification>(context).activeNews =
                            newsSnap.data!;
                        return NewsMiniAdmin(item: newsSnap.data![index]);
                      })));
        });
  }
}
