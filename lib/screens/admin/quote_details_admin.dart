import 'package:flutter/material.dart';
import 'package:hardwarestore/components/admin/quote_item_list_component.dart';
import 'package:hardwarestore/widgets/quote_mini_admin.dart';

import '../../models/quote.dart';
import '../../widgets/admin_bubble_quote.dart';
//import '../../widgets/admin_bubble_quote.dart';

class QuoteDetailAdmin extends StatefulWidget {
  final Quote item;
  const QuoteDetailAdmin({Key? key, required this.item}) : super(key: key);

  @override
  State<QuoteDetailAdmin> createState() => _QuoteDetailAdminState();
}

class _QuoteDetailAdminState extends State<QuoteDetailAdmin> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: QuoteBubbleButtons(quoteId: widget.item.id!),
      body: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.max, children: [
        QuoteDetaulsNoInkWell(
          item: widget.item,
        ),
        QuoteItemList(
          quoteId: widget.item.id!,
        ),
      ])),
      appBar: AppBar(
        title: Text('הצעה מס ' + widget.item.quote_number.toString()),
      ),
      // bottomNavigationBar: const AdminBottomNav(1),
    );
  }
}
