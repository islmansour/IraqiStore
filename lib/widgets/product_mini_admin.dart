import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.price_change_rounded,
                                                  size: 20,
                                                  color: Colors.amber.shade500,
                                                ),
                                                Text(
                                                    widget.item.price
                                                            .toString() +
                                                        " " +
                                                        format.currencySymbol +
                                                        " ",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0, top: 4),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.discount_rounded,
                                                  size: 20,
                                                  color: Colors.amber.shade500,
                                                ),
                                                Text(
                                                    ' ' +
                                                        widget.item.discount
                                                            .toString() +
                                                        ' %',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                flex: 60,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.description_rounded,
                                            size: 14,
                                            color: Colors.amber.shade500,
                                          ),
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
                                          // if (widget.item.active != null &&
                                          //     widget.item.active == true)
                                          SizedBox(
                                              width: 30,
                                              //  height: 30,
                                              child: FittedBox(
                                                fit: BoxFit.fill,
                                                child: Switch(
                                                  onChanged: null,
                                                  value: (widget.item.active !=
                                                              null &&
                                                          widget.item.active ==
                                                              true)
                                                      ? true
                                                      : false,
                                                  inactiveTrackColor: (widget
                                                                  .item
                                                                  .active !=
                                                              null &&
                                                          widget.item.active ==
                                                              true)
                                                      ? Colors.green
                                                      : Colors.redAccent,
                                                  inactiveThumbColor: (widget
                                                                  .item
                                                                  .active !=
                                                              null &&
                                                          widget.item.active ==
                                                              true)
                                                      ? Colors.lightGreenAccent
                                                      : Colors.red,
                                                ),
                                              )),
                                          //   Text(
                                          //       AppLocalizations.of(context)!
                                          //           .active,
                                          //       style: Theme.of(context)
                                          //           .textTheme
                                          //           .bodySmall)
                                          // else
                                          //   Text(
                                          //     AppLocalizations.of(context)!
                                          //         .inactive,
                                          //     style: Theme.of(context)
                                          //         .textTheme
                                          //         .bodySmall,
                                          //   )
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
