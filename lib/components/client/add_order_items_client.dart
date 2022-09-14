import 'package:flutter/material.dart';
import 'package:hardwarestore/components/client/categories_filter.dart';
import 'package:hardwarestore/models/orders.dart';
import 'package:hardwarestore/models/products.dart';
import 'package:hardwarestore/services/api.dart';
import 'package:hardwarestore/services/search.dart';
import 'package:hardwarestore/services/tools.dart';
import 'package:hardwarestore/widgets/client/client_product_pick.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddItemToOrderClient extends StatefulWidget {
  final Order? clientOrder;
  const AddItemToOrderClient({Key? key, required this.clientOrder})
      : super(key: key);

  @override
  State<AddItemToOrderClient> createState() => _AddItemToOrderState();
}

class _AddItemToOrderState extends State<AddItemToOrderClient> {
  bool _searching = false;
  bool searchButtonPressed = false;
  String _category = "";
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
      _order = Provider.of<EntityModification>(context)
          .order
          .where(
            (order) => order.id == widget.clientOrder!.id,
          )
          .first;

// prepare tmpItems for modifications. This variable will allow user cancel the operation and not have it confirmed when working with widget ProductPick.
// In this file, right at the end, there is a confirm button. This buttom will take the tmpItems , merge them with the current orderitems then updade the db.
      Provider.of<EntityModification>(context)
          .order
          .where(
            (order) => order.id == widget.clientOrder!.id,
          )
          .first
          .initOrderItems();
    } catch (e) {}
    // if (widget.clientOrder!.id == 0) return Container();

    if (Provider.of<CategoryFilterNotifier>(context).searchCategory != null)
      _category = Provider.of<CategoryFilterNotifier>(context).searchCategory!;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SingleChildScrollView(
        child: FutureBuilder<List<Product>?>(
            future: Repository().getVisibleProducts(),
            builder: (context, AsyncSnapshot<List<Product>?> productSnap) {
              if (productSnap.connectionState == ConnectionState.none &&
                  productSnap.hasData == null) {
                return Container();
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.redAccent,
                            border: Border.all(
                              color: Colors.redAccent,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: IconButton(
                          icon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                      ),
                      CategoriesFilter()
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (searchButtonPressed)
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15),
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
                                color: Colors.redAccent,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  if (_category != "" ||
                      (_searching == true && _newSearch.length >= 3))
                    FutureBuilder<List<SearchItem>?>(
                        future: _category != ""
                            ? ApplySearch().SearchProductsByCategory(_category)
                            : ApplySearch().SearchProducts(_newSearch),
                        builder: (context,
                            AsyncSnapshot<List<SearchItem>?> searchSnap) {
                          if (searchSnap.connectionState ==
                                  ConnectionState.none &&
                              searchSnap.hasData == null) {
                            return Container();
                          }

                          if (searchSnap.data == null ||
                              searchSnap.data?.length == null)
                            return Container();
                          return SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 400,
                            child: Scrollbar(
                                child: Container(
                              child: ListView.builder(
                                  physics: const ScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: searchSnap.data?.length,
                                  itemBuilder: (context, index) {
                                    String type = "";
                                    Widget output = Text('');
                                    if (searchSnap.data != null) {
                                      type = searchSnap.data![index].type
                                          .toString();

                                      switch (type) {
                                        case "Product":
                                          output = Card(
                                            elevation: 0,
                                            child: Container(
                                              height: 140,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: ClientProductPick(
                                                item: searchSnap.data![index]
                                                    .item as Product,
                                                stepperOrder:
                                                    widget.clientOrder!,
                                              ),
                                            ),
                                          );

                                          break;
                                      }
                                    }
                                    return output;
                                  }),
                            )),
                          );
                        }),
                  if (_searching == false && _category == "")
                    if (productSnap.data != null &&
                        productSnap.data!.isNotEmpty)
                      SizedBox(
                          width: MediaQuery.of(context).size.width,
                          //  height: MediaQuery.of(context).size.height * 0.48,
                          child: Scrollbar(
                              child: Container(
                            color: Colors.white,
                            child: ListView.builder(
                                physics: const ScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: productSnap.data?.length ?? 0,
                                itemBuilder: (context, index) {
                                  return Card(
                                    elevation: 0,
                                    child: Container(
                                      height: 140,
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: ClientProductPick(
                                                item: productSnap.data![index],
                                                stepperOrder:
                                                    widget.clientOrder!),
                                          ),
                                          Divider(
                                            color: Colors.black54,
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ))),
                  // TextButton(
                  //     onPressed: () {
                  //       try {
                  //         if (_order!.isReadOnly) return null;
                  //         Provider.of<EntityModification>(context,
                  //                 listen: false)
                  //             .order
                  //             .where((element) =>
                  //                 element.id == widget.clientOrder!.id)
                  //             .first
                  //             .confirmOrder();

                  //         Provider.of<EntityModification>(context,
                  //                 listen: false)
                  //             .order
                  //             .where((element) =>
                  //                 element.id == widget.clientOrder!.id)
                  //             .first
                  //             .orderItems
                  //             ?.forEach((item) {
                  //           Order? x = Provider.of<EntityModification>(context,
                  //                   listen: false)
                  //               .order
                  //               .where((element) =>
                  //                   element.id == widget.clientOrder!.id)
                  //               .first;
                  //           // DjangoServices()
                  //           Repository().upsertOrderItem(item)?.then((value) {
                  //             item.id = value;
                  //             Provider.of<EntityModification>(context,
                  //                     listen: false)
                  //                 .update(x);
                  //           });

                  //           Provider.of<EntityModification>(context,
                  //                   listen: false)
                  //               .update(x);
                  //         });
                  //       } catch (e) {}
                  //       Navigator.pop(context);
                  //     },
                  //     child: Text(AppLocalizations.of(context)!.confirm))
                ],
              );
            }),
      ),
    );
  }
}
