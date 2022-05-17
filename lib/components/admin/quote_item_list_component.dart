import 'package:flutter/material.dart';
import 'package:hardwarestore/models/quote_item.dart';
import 'package:hardwarestore/services/django_services.dart';
import 'package:hardwarestore/widgets/quote_item_admin.dart';
import 'package:provider/provider.dart';

class QuoteItemList extends StatefulWidget {
  final String quoteId;
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
    return FutureBuilder<List<QuoteItem>?>(
        future: DjangoServices().getQuoteItems(widget.quoteId),
        builder: (context, AsyncSnapshot<List<QuoteItem>?> quoteItemSnap) {
          if (quoteItemSnap.connectionState == ConnectionState.none &&
              quoteItemSnap.hasData == null) {
            return Container();
          }
          int len = quoteItemSnap.data?.length ?? 0;

          return SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: Scrollbar(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: quoteItemSnap.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        Provider.of<CurrentQuoteItemUpdate>(context)
                            .quoteItems = quoteItemSnap.data;
                        return QuoteItemAdmin(item: quoteItemSnap.data![index]);
                      })));
        });
  }
}

class CurrentQuoteItemUpdate extends ChangeNotifier {
  List<QuoteItem>? quoteItems;
  void updateProduct(QuoteItem item) {
    quoteItems?.add((item));
    notifyListeners();
  }
}
