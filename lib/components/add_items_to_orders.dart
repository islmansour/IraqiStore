import 'package:flutter/material.dart';
import 'package:hardwarestore/models/orders.dart';
import 'package:hardwarestore/models/products.dart';
import 'package:hardwarestore/services/api.dart';
import 'package:hardwarestore/services/tools.dart';
import 'package:provider/provider.dart';

import '../../widgets/product_pick.dart';
import '../services/search.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddItemToOrder extends StatefulWidget {
  final Order? order;
  const AddItemToOrder({Key? key, required this.order}) : super(key: key);

  @override
  State<AddItemToOrder> createState() => _AddItemToOrderState();
}

class _AddItemToOrderState extends State<AddItemToOrder> {
  bool _searching = false;
  String _newSearch = "";
  List<Product>? myProducts;
  var isLoaded = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Order? _order = Order();
    try {
// prepare tmpItems for modifications. This variable will allow user cancel the operation and not have it confirmed when working with widget ProductPick.
// In this file, right at the end, there is a confirm button. This buttom will take the tmpItems , merge them with the current orderitems then updade the db.
      // Provider.of<ClientEnvironment>(context, listen: false)
      //     .currentOrder!
      //     .initOrderItems();
      _order =
          Provider.of<ClientEnvironment>(context, listen: false).currentOrder;
      _order!.initOrderItems();
    } catch (e) {}
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
            //  title: Text('הזמנה מס '),
            ),
        body: SingleChildScrollView(
          child: FutureBuilder<List<Product>?>(
              future: Repository().getProducts(),
              builder: (context, AsyncSnapshot<List<Product>?> productSnap) {
                if (productSnap.connectionState == ConnectionState.none &&
                    productSnap.hasData == null) {
                  return Container();
                }

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0, right: 30),
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
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 200, 200, 200)),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 200, 200, 200)),
                                ),
                                hintText: AppLocalizations.of(context)!.search,
                                hintStyle: const TextStyle(
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
                    if (_searching == true && _newSearch.length >= 3)
                      FutureBuilder<List<SearchItem>?>(
                          future: ApplySearch().SearchProducts(_newSearch),
                          builder: (context,
                              AsyncSnapshot<List<SearchItem>?> searchSnap) {
                            if (searchSnap.connectionState ==
                                    ConnectionState.none &&
                                searchSnap.hasData == null) {
                              return Container();
                            }

                            return SizedBox(
                                height: MediaQuery.of(context).size.height / 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 8.0, left: 8),
                                  child: Scrollbar(
                                      child: ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount: searchSnap.data?.length,
                                          itemBuilder: (context, index) {
                                            String type = "";
                                            Widget output = Text('');
                                            if (searchSnap.data != null) {
                                              type = searchSnap
                                                  .data![index].type
                                                  .toString();

                                              switch (type) {
                                                case "Product":
                                                  output = ProductPick(
                                                    item: searchSnap
                                                        .data![index]
                                                        .item as Product,
                                                    // orderId: widget.order!.id,
                                                  );
                                                  break;
                                              }
                                            }
                                            return output;
                                          })),
                                ));
                          }),
                    if (_searching == false)
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.70,
                          child: Scrollbar(
                              child: ListView.builder(
                                  physics: const ScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: productSnap.data?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    return ProductPick(
                                      item: productSnap.data![index],
                                      //  orderId: widget.order!.id
                                    );
                                  }))),
                    TextButton(
                        onPressed: () {
                          try {
                            if (_order!.isReadOnly) return null;

                            _order.confirmOrder();
                            Provider.of<ClientEnvironment>(context,
                                    listen: false)
                                .currentOrder = _order;

                            if (_order.id > 0) {
                              Repository().upsertOrderV2(_order);
                            }
                            Provider.of<ClientEnvironment>(context,
                                    listen: false)
                                .updateScreens();

                            // Provider.of<EntityModification>(context,
                            //         listen: false)
                            //     .order
                            //     .where(
                            //         (element) => element.id == widget.order!.id)
                            //     .first
                            //     .confirmOrder();

                            // Provider.of<EntityModification>(context,
                            //         listen: false)
                            //     .order
                            //     .where(
                            //         (element) => element.id == widget.order!.id)
                            //     .first
                            //     .orderItems
                            //     ?.forEach((item) {
                            //   Order? x = Provider.of<EntityModification>(
                            //           context,
                            //           listen: false)
                            //       .order
                            //       .where((element) =>
                            //           element.id == widget.order!.id)
                            //       .first;
                            //   // DjangoServices()
                            //   Repository().upsertOrderItem(item)?.then((value) {
                            //     item.id = value;
                            //     Provider.of<EntityModification>(context,
                            //             listen: false)
                            //         .update(x);
                            //   });

                            //   Provider.of<EntityModification>(context,
                            //           listen: false)
                            //       .update(x);
                            // });
                          } catch (e) {}
                          Navigator.pop(context);
                        },
                        child: Text(AppLocalizations.of(context)!.confirm))
                  ],
                );
              }),
        ),
      ),
    );
  }
}
