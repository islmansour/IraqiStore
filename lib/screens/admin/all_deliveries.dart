import 'package:flutter/material.dart';

import '../../components/delivery.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AllDeliveriesScreen extends StatefulWidget {
  const AllDeliveriesScreen({Key? key}) : super(key: key);

  @override
  State<AllDeliveriesScreen> createState() => _AllDeliveriesScreenState();
}

class _AllDeliveriesScreenState extends State<AllDeliveriesScreen> {
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
              if (_searching == false) DeliverysList(),
              if (_searching == true && _newSearch.length >= 3) Container()
              // FutureBuilder<List<SearchItem>?>(
              //     future: ApplySearch().SearchDelivery(context, _newSearch),
              //     builder:
              //         (context, AsyncSnapshot<List<SearchItem>?> searchSnap) {
              //       if (searchSnap.connectionState == ConnectionState.none &&
              //           searchSnap.hasData == null) {
              //         return Container();
              //       }
              //       if (searchSnap.data?.length == null) return Container();
              //       return SizedBox(
              //           child: Padding(
              //         padding: const EdgeInsets.only(right: 8.0, left: 8),
              //         child: Scrollbar(
              //             child: ListView.builder(
              //                 scrollDirection: Axis.vertical,
              //                 shrinkWrap: true,
              //                 itemCount: searchSnap.data?.length,
              //                 itemBuilder: (context, index) {
              //                   String type = "";
              //                   Widget output = Text('');
              //                   if (searchSnap.data != null) {
              //                     type =
              //                         searchSnap.data![index].type.toString();

              //                     switch (type) {
              //                       case "Delivery":
              //                         output = DeliveryMiniAdmin(
              //                             item: searchSnap.data![index].item
              //                                 as Delivery);
              //                         break;
              //                     }
              //                   }
              //                   return output;
              //                 })),
              //       ));
              //     }),
            ],
          ),
        ));
  }
}
