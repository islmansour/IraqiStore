import 'package:flutter/material.dart';
import 'package:hardwarestore/models/news.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hardwarestore/models/products.dart';
import 'package:hardwarestore/screens/admin/new_news.dart';
import 'package:hardwarestore/services/tools.dart';
import 'package:provider/provider.dart';

class NewsMiniAdmin extends StatefulWidget {
  final News item;

  const NewsMiniAdmin({Key? key, required this.item}) : super(key: key);

  @override
  State<NewsMiniAdmin> createState() => _NewsMiniAdminState();
}

class _NewsMiniAdminState extends State<NewsMiniAdmin> {
  @override
  Widget build(BuildContext context) {
    Product _product = Product();
    if (widget.item.productId != null && widget.item.productId != "") {
      try {
        _product = Provider.of<EntityModification>(context, listen: false)
            .products
            .where(
              (element) => element.id == widget.item.productId,
            )
            .first;
      } catch (e) {}
    }

    //  print(widget.item.id.toString() + ":" + _product.name!);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NewNewsStepper(
                    news: widget.item,
                  )),
        );
      },
      child: Card(
        child: SizedBox(
            // padding: const EdgeInsets.all(5),
            height: 140,
            width: double.infinity,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.green.shade500,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        height: 24,
                        alignment: Alignment.centerRight,
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(right: 12),
                              //   width: 65,
                              // child: Text(
                              //   widget.item.first_name.toString(),
                              //   style:
                              //       Theme.of(context).textTheme.displayMedium,
                              // ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Text(widget.item.id.toString(),
                                  overflow: TextOverflow.ellipsis,
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
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        flex: 60,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: widget.item.desc == null ||
                                          widget.item.desc == ""
                                      ? Text(
                                          AppLocalizations.of(context)!.na,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        )
                                      : Text(
                                          widget.item.desc.toString(),
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                ),
                              ],
                            ),
                            SizedBox(
                              child: Row(children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                  child: (_product.name != "" &&
                                          _product.name != null)
                                      ? Text(_product.name!)
                                      : Container(),
                                ),
                                Switch(
                                  value: (widget.item.active!) ? true : false,
                                  onChanged: (value) {
                                    // setState(() {
                                    //   _data.active = value;
                                    // });
                                  },
                                  activeTrackColor: Colors.green.shade200,
                                  activeColor: Colors.green,
                                ),
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
