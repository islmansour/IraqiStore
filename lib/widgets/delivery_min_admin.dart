import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:hardwarestore/models/account.dart';
import 'package:hardwarestore/models/contact.dart';
import 'package:hardwarestore/models/delivery.dart';
import 'package:hardwarestore/models/orders.dart';
import 'package:hardwarestore/services/tools.dart';
import 'package:hardwarestore/widgets/popup_dialog.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeliveryMiniAdmin extends StatelessWidget {
  final Delivery item;

  const DeliveryMiniAdmin({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Contact? contact;
    Account? account;
    Order? order;

    try {
      if (item.contactId != null)
        contact = Provider.of<EntityModification>(context)
            .contacts
            .where(
              (element) => element.id == item.contactId,
            )
            .first;

      account = Provider.of<EntityModification>(context)
          .accounts
          .where(
            (element) => element.id == item.accountId,
          )
          .first;

      order = Provider.of<EntityModification>(context)
          .order
          .where(
            (element) => element.id == item.orderId,
          )
          .first;
    } catch (e) {
      print('Error in DeliveryMiniAdmin $e');
    }

    print(order!.status);
    return InkWell(
      onTap: () {
        if (order!.status == 'loading') {
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return ShowDiaglog(
                actions: [
                  Center(
                    child: BarcodeWidget(
                      barcode: Barcode.qrCode(
                        errorCorrectLevel: BarcodeQRCorrectionLevel.high,
                      ),
                      data: '${order!.order_number}#${DateTime.now()}',
                      width: 200,
                      height: 200,
                    ),
                  ),
                ],
                title:
                    '${order.order_number} (${order.orderItems!.length.toString()} ${AppLocalizations.of(context)!.items})',
                content: '2',
              );
            },
          );
        }
        ;
      },
      child: Card(
        child: SizedBox(
            height: 110,
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0, top: 8),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.shopping_cart,
                              color: Colors.blue,
                              size: 16,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            order != null
                                ? Text(
                                    order.order_number.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                  )
                                : SizedBox(),
                            order != null
                                ? Text(
                                    ' (${order.orderItems!.length.toString()} ${AppLocalizations.of(context)!.items})',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 10))
                                : SizedBox(),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.only(right: 4.0, top: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                flex: 1,
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.40,
                                  // height: 35,

                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.business,
                                            color: Colors.blue,
                                            size: 16,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.35,
                                            child: Text(
                                                account != null &&
                                                        account.name != null
                                                    ? account.name!
                                                    : "",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineMedium,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 4.0),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.person,
                                              size: 16,
                                              color: Colors.blue,
                                            ),
                                            Text(
                                                contact != null
                                                    ? contact.first_name! +
                                                        " " +
                                                        contact.last_name!
                                                    : "",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineMedium,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                // width: MediaQuery.of(context).size.width * 0.28,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.phone_iphone,
                                          //size: 20,
                                          color: Colors.blue, size: 16,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25,
                                          child: Text(
                                              account?.phone ??
                                                  AppLocalizations.of(context)!
                                                      .na,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.phone_iphone,
                                            // size: 20,
                                            color: Colors.blue, size: 16,
                                          ),
                                          Text(
                                              contact != null &&
                                                      contact.phone != null
                                                  ? contact.phone!
                                                  : AppLocalizations.of(
                                                          context)!
                                                      .na,
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
                      ),
                    ],
                  ),
                ),

                // Row(
                //   children: [
                //     SizedBox(
                //       child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.end,
                //           children: [
                //             BarcodeWidget(
                //               barcode:
                //                   Barcode.qrCode(), // Barcode type and settings
                //               data:
                //                   'https://pub.dev/packages/barcode_widget', // Content
                //               width: 100,
                //               height: 100,
                //             ),
                //           ]),
                //     ),
                //   ],
                // )
              ],
            )),
      ),
    );
  }
}
