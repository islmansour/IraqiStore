import 'package:flutter/material.dart';
import '../models/news.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class xNewsList extends StatefulWidget {
  xNewsList({Key? key}) : super(key: key);

  @override
  State<xNewsList> createState() => _xNewsListState();
}

class _xNewsListState extends State<xNewsList> {
  @override
  Widget build(BuildContext context) {
    return Provider.of<CurrentNewsUpdates>(context).activexNews.isNotEmpty
        ? ListView.builder(
            itemCount:
                Provider.of<CurrentNewsUpdates>(context).activexNews.length,
            itemBuilder: (context, index) {
              return ListTile(
                subtitle: Text(Provider.of<CurrentNewsUpdates>(context)
                    .activexNews[index]
                    .desc!),
                title: Text(DateFormat.MEd().format(
                    Provider.of<CurrentNewsUpdates>(context)
                        .activexNews[index]
                        .date!)),
              );
            })
        : const Text('אין חדשות');
  }
}

class CurrentNewsUpdates extends ChangeNotifier {
  List<News> activexNews = [];
  void changexNews(News newxNews) {
    newxNews.desc = newxNews.desc! + " " + activexNews.length.toString();
    activexNews.add((newxNews));
    notifyListeners();
  }
}
