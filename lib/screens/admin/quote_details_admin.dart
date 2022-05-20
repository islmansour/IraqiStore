import 'package:flutter/material.dart';
import 'package:hardwarestore/components/admin/quote_item_list_component.dart';
import 'package:hardwarestore/widgets/quote_mini_admin.dart';
import '../../models/quote.dart';

class QuoteDetailAdmin extends StatelessWidget {
  final Quote item;
  const QuoteDetailAdmin({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.max, children: [
        QuoteMiniAdmin(
          item: item,
        ),
        QuoteItemList(
          quoteId: item.id.toString(),
        )
      ])),
      appBar: AppBar(
        title: Text(''), //Text(AppLocalizations.of(context)!.helloWorld),
      ),
      // bottomNavigationBar: const AdminBottomNav(1),
    );
  }
}
