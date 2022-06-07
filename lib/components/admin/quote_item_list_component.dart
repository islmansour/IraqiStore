import 'package:flutter/material.dart';
import 'package:hardwarestore/models/quote_item.dart';
import 'package:hardwarestore/models/quote.dart';
import 'package:hardwarestore/services/api.dart';
import 'package:hardwarestore/services/django_services.dart';
import 'package:hardwarestore/widgets/quote_item_admin.dart';
import 'package:provider/provider.dart';

import '../../services/tools.dart';

class QuoteItemList extends StatefulWidget {
  final int quoteId;
  QuoteItemList({Key? key, required this.quoteId}) : super(key: key);

  @override
  State<QuoteItemList> createState() => _QuoteItemListState();
}

class _QuoteItemListState extends State<QuoteItemList> {
  List<QuoteItem>? quoteItems;
  var isLoaded = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<EntityModification>(context)
        .quotes
        .where(
          (element) => element.id == widget.quoteId,
        )
        .isEmpty) {
      Provider.of<EntityModification>(context).refreshQuotesFromDB();
    }
    List<QuoteItem>? _items = Provider.of<EntityModification>(context)
        .quotes
        .where(
          (element) => element.id == widget.quoteId,
        )
        .first
        .quoteItems;

    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Scrollbar(
            child: RefreshIndicator(
          onRefresh: _pullRefresh,
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: _items?.length ?? 0,
              itemBuilder: (context, index) {
                Provider.of<CurrentQuoteItemUpdate>(context).quoteItems =
                    _items;
                return Dismissible(
                  key: Key(_items![index].id.toString()),
                  background: Container(color: Colors.red),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    QuoteItem _currentItem = _items[index];

                    Repository().deleteQuoteItem(_items[index].id!);

                    Provider.of<EntityModification>(context, listen: false)
                        .quotes
                        .where((element) => element.id == widget.quoteId)
                        .first
                        .quoteItems!
                        .forEach((item) {
                      if (item.id == _currentItem.id!) {
                        Provider.of<EntityModification>(context, listen: false)
                            .quotes
                            .where((element) => element.id == widget.quoteId)
                            .first
                            .quoteItems
                            ?.forEach(
                          (itemElement) {
                            if (itemElement.id == _currentItem.id) {
                              itemElement = QuoteItem();
                            }
                          },
                        );
                      }

                      Quote x = Provider.of<EntityModification>(context,
                              listen: false)
                          .quotes
                          .where((element) => element.id == widget.quoteId)
                          .first;

                      Provider.of<EntityModification>(context, listen: false)
                          .updateQuote(x);
                    });

                    setState(() {
                      _items.removeAt(index);
                    });
                    Scaffold.of(context).showSnackBar(
                        const SnackBar(content: Text("הוסר בהצלה")));
                  },
                  child: QuoteItemAdmin(
                    item: _items[index],
                    quoteId: widget.quoteId,
                  ),
                );
              }),
        )));
  }

  Future<void> _pullRefresh() async {
    //  List<WordPair> freshWords = await WordDataSource().getFutureWords(delay: 2);
    setState(() {
      //    words = freshWords;
    });
    // why use freshWords var? https://stackoverflow.com/a/52992836/2301224
  }
}

class CurrentQuoteItemUpdate extends ChangeNotifier {
  List<QuoteItem>? quoteItems;
  void updateProduct(QuoteItem item) {
    quoteItems?.add((item));
    notifyListeners();
  }
}
