import 'package:flutter/material.dart';

import '../../components/order.dart';
import '../../models/orders.dart';
import '../../services/search.dart';
import '../../widgets/order_mini_admin.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AllOrdersScreen extends StatefulWidget {
  const AllOrdersScreen({Key? key}) : super(key: key);

  @override
  State<AllOrdersScreen> createState() => _AllOrdersScreenState();
}

class _AllOrdersScreenState extends State<AllOrdersScreen> {
  bool _searching = false;
  String _newSearch = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 30.0, right: 30, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 300,
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            if (value.isEmpty) {
                              _searching = false;
                            } else {
                              _searching = true;
                            }
                            _newSearch = value;
                          });
                        },
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 200, 200, 200)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 200, 200, 200)),
                          ),
                          hintText: AppLocalizations.of(context)!.search,
                          hintStyle: TextStyle(
                            color: Color.fromARGB(255, 191, 190, 190),
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                          ),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              if (_searching == false) OrdersList(),
              if (_searching == true && _newSearch.length >= 3)
                FutureBuilder<List<SearchItem>?>(
                    future: ApplySearch().SearchOrder(context, _newSearch),
                    builder:
                        (context, AsyncSnapshot<List<SearchItem>?> searchSnap) {
                      if (searchSnap.connectionState == ConnectionState.none &&
                          searchSnap.hasData == null) {
                        return Container();
                      }
                      if (searchSnap.data?.length == null) return Container();
                      return SizedBox(
                          child: Padding(
                        padding: const EdgeInsets.only(right: 8.0, left: 8),
                        child: Scrollbar(
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: searchSnap.data?.length,
                                itemBuilder: (context, index) {
                                  String type = "";
                                  Widget output = Text('');
                                  if (searchSnap.data != null) {
                                    type =
                                        searchSnap.data![index].type.toString();

                                    switch (type) {
                                      case "Order":
                                        output = OrderMiniAdmin(
                                            item: searchSnap.data![index].item
                                                as Order);
                                        break;
                                    }
                                  }
                                  return output;
                                })),
                      ));
                    }),
            ],
          ),
        ));
  }
}
