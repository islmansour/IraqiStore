import 'package:flutter/material.dart';

import '../../models/account.dart';

import '../../models/quote.dart';
import '../../widgets/quote_mini_admin.dart';

class AccountQuotesList extends StatefulWidget {
  Account? account;
  AccountQuotesList({Key? key, required this.account}) : super(key: key);

  @override
  State<AccountQuotesList> createState() => _AccountQuotesListState();
}

class _AccountQuotesListState extends State<AccountQuotesList> {
  var isLoaded = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: widget.account?.accountQuotes == null
                ? 0
                : widget.account?.accountQuotes!.length ?? 0,
            itemBuilder: (context, index) {
              Quote _quote = widget.account!.accountQuotes![index];
              return QuoteMiniAdmin(item: _quote);
            }));
    ;
  }
}
