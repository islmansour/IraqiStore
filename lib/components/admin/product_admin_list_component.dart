import 'package:flutter/material.dart';
import 'package:hardwarestore/models/products.dart';
import 'package:hardwarestore/services/django_services.dart';
import 'package:provider/provider.dart';

import '../../widgets/product_mini_admin.dart';

class ProductsList extends StatefulWidget {
  ProductsList({Key? key}) : super(key: key);

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  List<Product>? myProducts;
  var isLoaded = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>?>(
        future: DjangoServices().getProducts(),
        builder: (context, AsyncSnapshot<List<Product>?> productSnap) {
          if (productSnap.connectionState == ConnectionState.none &&
              productSnap.hasData == null) {
            return Container();
          }
          int len = productSnap.data?.length ?? 0;

          return SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: Scrollbar(
                  child: ListView.builder(
                      physics: ScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: productSnap.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        if (Provider.of<CurrentProductsUpdate>(context)
                                .products
                                ?.length !=
                            productSnap.data?.length) {
                          Provider.of<CurrentProductsUpdate>(context).products =
                              productSnap.data;
                        }
                        return ProductMiniAdmin(item: productSnap.data![index]);
                      })));
        });
  }
}

class CurrentProductsUpdate extends ChangeNotifier {
  List<Product>? products;
  void updateProduct(Product product) {
    products?.add((product));
    notifyListeners();
  }
}
