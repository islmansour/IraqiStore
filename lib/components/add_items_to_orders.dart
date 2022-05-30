import 'package:flutter/material.dart';
import 'package:hardwarestore/models/orders.dart';
import 'package:hardwarestore/models/products.dart';
import 'package:hardwarestore/services/django_services.dart';
import 'package:hardwarestore/services/tools.dart';
import 'package:provider/provider.dart';

import '../../widgets/product_pick.dart';
import '../services/search.dart';

class AddItemToOrder extends StatefulWidget {
  final int? orderId;
  const AddItemToOrder({Key? key, required this.orderId}) : super(key: key);

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
    Order? _order = Provider.of<EntityModification>(context)
        .order
        .where(
          (order) => order.id == widget.orderId,
        )
        .first;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
            //  title: Text('הזמנה מס '),
            ),
        body: SingleChildScrollView(
          child: FutureBuilder<List<Product>?>(
              future: DjangoServices().getProducts(),
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
                              decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 200, 200, 200)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 200, 200, 200)),
                                ),
                                hintText: "חפש...",
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
                                                    orderId: widget.orderId!,
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
                                        orderId: widget.orderId!);
                                  }))),
                    ElevatedButton(
                      onPressed: () {
                        Provider.of<EntityModification>(context, listen: false)
                            .order
                            .where((element) => element.id == widget.orderId)
                            .first
                            .orderItems
                            ?.forEach((item) {
                          Order? x = Provider.of<EntityModification>(context,
                                  listen: false)
                              .order
                              .where((element) => element.id == widget.orderId)
                              .first;
                          DjangoServices().upsertOrderItem(item)?.then((value) {
                            item.id = value;
                            Provider.of<EntityModification>(context,
                                    listen: false)
                                .update(x);
                          });

                          Provider.of<EntityModification>(context,
                                  listen: false)
                              .update(x);
                        });
                      },
                      child: Text('Confirm'),
                    )
                  ],
                );
              }),
        ),
      ),
    );
  }
}
