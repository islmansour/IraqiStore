import 'package:dio/dio.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:hardwarestore/components/admin/product_admin_list_component.dart';
import 'package:hardwarestore/models/products.dart';
import 'package:hardwarestore/services/tools.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/imgbb_model.dart';
import '../screens/admin/new_product.dart';

class ProductMiniAdmin extends StatefulWidget {
  final Product item;

  const ProductMiniAdmin({Key? key, required this.item}) : super(key: key);

  @override
  State<ProductMiniAdmin> createState() => _ProductMiniAdminState();
}

class _ProductMiniAdminState extends State<ProductMiniAdmin> {
  bool delay = true;
  bool loading = false;
  String txt = 'Choose Image';
  Dio dio = Dio();
  late ImgbbResponseModel imgbbResponse;

  Future getImage() async {
    setState(() {
      try {} catch (e) {
        print(e.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var format = NumberFormat.simpleCurrency(locale: 'he');

    String? currentImg = Provider.of<EntityModification>(context, listen: false)
        .products
        .where((element) => element.id == widget.item.id)
        .first
        .img;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CreateNewProductForm(
                    item: widget.item,
                  )),
        );
      },
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: SizedBox(
            height: 100,
            child: Column(
              children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // Flexible(
                  //     flex: 30, // 15%
                  //     child: Container(
                  //       decoration: const BoxDecoration(
                  //           color: Colors.lightBlue,
                  //           borderRadius: BorderRadius.only(
                  //               bottomRight: Radius.circular(10),
                  //               bottomLeft: Radius.circular(10),
                  //               topLeft: Radius.circular(10),
                  //               topRight: Radius.circular(10))),
                  //       height: 75,
                  //       alignment: Alignment.center,
                  //       child: Column(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           if (currentImg == 'http://localhost.com' ||
                  //               currentImg == "" ||
                  //               currentImg == null)
                  //             const Icon(Icons.image_not_supported,
                  //                 size: 65, color: Colors.white)
                  //           else
                  //             Expanded(
                  //               child: Image.network(
                  //                 currentImg,
                  //               ),
                  //             ),
                  //         ],
                  //       ),
                  //     )),
                  Flexible(
                      flex: 70, // 60%
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.amber.shade300,
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          topLeft: Radius.circular(10))),
                                  height: 30,
                                  alignment: Alignment.centerRight,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Row(
                                          children: [
                                            Text(
                                                widget.item.product_number
                                                        .toString() +
                                                    ": ",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineMedium),
                                            Text(widget.item.name.toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                flex: 30,
                                child: Column(
                                  children: [
                                    Container(
                                      //    height: 30,
                                      alignment: Alignment.topRight,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0, top: 2),
                                            child: Text(
                                                "מחיר:" +
                                                    " " +
                                                    widget.item.price
                                                        .toString() +
                                                    " " +
                                                    format.currencySymbol +
                                                    " ",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0, top: 4),
                                            child: Text(
                                                "הנחה:" +
                                                    ' ' +
                                                    widget.item.discount
                                                        .toString() +
                                                    ' %',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                flex: 55,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Row(
                                        children: [
                                          Text(widget.item.desc!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                              maxLines: 4,
                                              overflow: TextOverflow.ellipsis)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Flexible(
                                flex: 10,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Row(
                                        children: [
                                          if (widget.item.active != null &&
                                              widget.item.active == true)
                                            Text('פעיל')
                                          else
                                            Text('לא פעיל')
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      )),
                ])
              ],
            ),
          )),
    );
  }
}
