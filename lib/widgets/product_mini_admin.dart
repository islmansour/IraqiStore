import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hardwarestore/components/admin/product_admin_list_component.dart';
import 'package:hardwarestore/models/products.dart';
import 'package:hardwarestore/services/django_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:io';
import '../models/imgbb_model.dart';
import '../screens/admin/new_product.dart';

final imgBBkey = '77620f6bc5c71d69dc61e7460ff94a0f';
final imageString = 'https://imgur.com/4NH3806.png';

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
    /*
    1 columns that has
    3 rows
      1st row: has one ListTile with one text: Product Number + Product Date
      2nd row: has 3 columns each as a container with a text.
        first column is the account name
        second column is the contact name
        third column : if contact exists, displays contact phone. otherwise display account phone
      3rd row: has 2 columns: First colum is Product Status , second is dlivery status



    */
    String? currentImg =
        Provider.of<CurrentProductsUpdate>(context, listen: false)
            .products
            ?.where((element) => element.id == widget.item.id)
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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            decoration: BoxDecoration(
                border:
                    Border.all(width: 0.5, color: Colors.lightGreen.shade400),
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20))),
            height: 76,
            width: double.infinity,
            child: Column(
              children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Flexible(
                      flex: 30, // 15%
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.lightGreen.shade400,
                            borderRadius: const BorderRadius.only(
                                //      bottomRight: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        height: 75,
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            if (currentImg == 'http://localhost.com' ||
                                currentImg == "" ||
                                currentImg == null)
                              const Padding(
                                padding: EdgeInsets.only(top: 6.0),
                                child: Icon(Icons.image_not_supported,
                                    size: 65, color: Colors.white),
                              )
                            else
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: SizedBox(
                                  height: 65,
                                  width: 65,
                                  child: Image.network(
                                    currentImg,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      )),
                  Flexible(
                      flex: 70, // 60%
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.lightGreen.shade400,
                                      borderRadius: const BorderRadius.only(
                                          // bottomLeft: Radius.circular(10),
                                          topLeft: Radius.circular(10))),
                                  height: 30,
                                  alignment: Alignment.centerRight,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 4.0, top: 8),
                                        child: Text(
                                            widget.item.product_number
                                                    .toString() +
                                                ": " +
                                                widget.item.name.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayMedium),
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
                                flex: 70,
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
                                                right: 4.0, top: 2),
                                            child: Text(
                                                "מחיר (ש״ח):" +
                                                    widget.item.price
                                                        .toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayMedium),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 4.0, top: 4),
                                            child: Text(
                                                "הנחה (%):" +
                                                    widget.item.discount
                                                        .toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayMedium),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                flex: 30,
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
                //   Column(

                //     children: [
                //       TextButton(
                //         onPressed: () async {
                //           await getImage();
                //           if (_image != null) uploadImageFile(_image!, widget.item);
                //         },
                //         child:
                //             currentImg == 'http://localhost.com' || currentImg == ""
                //                 ? Icon(Icons.image_not_supported,
                //                     size: 75, color: Colors.grey.shade400)
                //                 : SizedBox(
                //                     height: 75,
                //                     width: 75,
                //                     child: Image.network(currentImg!)),
                //       )
                //     ],
                //   ),
                //   Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text(
                //         widget.item.name.toString(),
                //         style: Theme.of(context).textTheme.displayMedium,
                //       ),
                //     ],
                //   ),
                // ]),
                // Row(
                //   children: [
                //     Column(
                //       children: [
                //         Text(widget.item.price.toString(),
                //             style: Theme.of(context).textTheme.displayMedium),
                //       ],
                //     ),
                //     Column(
                //       children: [
                //         Text(widget.item.desc.toString(),
                //             style: Theme.of(context).textTheme.displayMedium),
                //       ],
                //     ),
                //     Column(
                //       children: [
                //         Text(widget.item.active.toString(),
                //             style: Theme.of(context).textTheme.displayMedium),
                //       ],
                //     )
                //   ],
                // ),
              ],
            )),
      ),
    );
  }
}
