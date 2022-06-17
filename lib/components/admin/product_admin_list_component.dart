import 'package:flutter/material.dart';
import 'package:hardwarestore/models/products.dart';
import 'package:hardwarestore/services/api.dart';
import 'package:hardwarestore/services/search.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../services/tools.dart';
import '../../widgets/product_mini_admin.dart';

class ProductsList extends StatefulWidget {
  const ProductsList({Key? key}) : super(key: key);

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  bool _searching = false;
  String _newSearch = "";
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>?>(
        future: Repository().getProducts(),
        builder: (context, AsyncSnapshot<List<Product>?> productSnap) {
          if (productSnap.connectionState == ConnectionState.none &&
              productSnap.hasData == null) {
            return Container();
          }
          int len = productSnap.data?.length ?? 0;
          // Provider.of<CurrentProductsUpdate>(context).setProducts(productSnap.data);
          if (productSnap.data != null) {
            Provider.of<EntityModification>(context, listen: false).products =
                productSnap.data!;
          }

          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 30.0, right: 30, bottom: 30),
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
              if (_searching == true && _newSearch.length >= 3)
                FutureBuilder<List<SearchItem>?>(
                    future: ApplySearch().SearchProducts(_newSearch),
                    builder:
                        (context, AsyncSnapshot<List<SearchItem>?> searchSnap) {
                      if (searchSnap.connectionState == ConnectionState.none &&
                          searchSnap.hasData == null) {
                        return Container();
                      }

                      return SizedBox(
                          height: MediaQuery.of(context).size.height / 2,
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
                                        type = searchSnap.data![index].type
                                            .toString();

                                        switch (type) {
                                          case "Product":
                                            output = ProductMiniAdmin(
                                              item: searchSnap.data![index].item
                                                  as Product,
                                            );
                                            break;
                                        }
                                      }
                                      return output;
                                    })),
                          ));
                    }),
              if (_searching == false)
                Container(
                  padding: EdgeInsets.only(left: 4, right: 4),
                  height: MediaQuery.of(context).size.height * 0.70,
                  child: Scrollbar(
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: productSnap.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: ProductMiniAdmin(
                                      item: productSnap.data![index]),
                                ),
                              ],
                            );
                          })),
                ),
            ],
          );
        });
  }
}
