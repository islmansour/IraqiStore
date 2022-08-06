import 'package:flutter/material.dart';
import '../models/news.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class NewsList extends StatefulWidget {
  NewsList({Key? key}) : super(key: key);

  @override
  State<NewsList> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  @override
  Widget build(BuildContext context) {
    return Provider.of<CurrentNewsUpdates>(context).activeNews.isNotEmpty
        ? ListView.builder(
            itemCount:
                Provider.of<CurrentNewsUpdates>(context).activeNews.length,
            itemBuilder: (context, index) {
              return ListTile(
                subtitle: Text(Provider.of<CurrentNewsUpdates>(context)
                    .activeNews[index]
                    .desc!),
                title: Text(DateFormat.MEd().format(
                    Provider.of<CurrentNewsUpdates>(context)
                        .activeNews[index]
                        .date!)),
              );
            })
        : const Text('אין חדשות');
  }
}

class CurrentNewsUpdates extends ChangeNotifier {
  List<News> activeNews = [];
  void changeNews(News newNews) {
    newNews.desc = newNews.desc! + " " + activeNews.length.toString();
    activeNews.add((newNews));
    notifyListeners();
  }
}
