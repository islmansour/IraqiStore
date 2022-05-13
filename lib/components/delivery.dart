import 'package:flutter/material.dart';
import 'package:hardwarestore/models/delivery.dart';
import 'package:provider/provider.dart';

import '../widgets/delivery_min_admin.dart';

class DeliverysList extends StatefulWidget {
  DeliverysList({Key? key}) : super(key: key);

  @override
  State<DeliverysList> createState() => _DeliverysListState();
}

class _DeliverysListState extends State<DeliverysList> {
  @override
  Widget build(BuildContext context) {
    return Provider.of<CurrentDeliverysUpdate>(context).deliverys.isNotEmpty
        ? ExpansionTile(
            title: Text(
                'הובלות ' +
                    Provider.of<CurrentDeliverysUpdate>(context)
                        .deliverys
                        .length
                        .toString(),
                style: Theme.of(context).textTheme.headline1),
            children: [
                ListTile(
                    title: SizedBox(
                        height: MediaQuery.of(context).size.height / 2,
                        child: Scrollbar(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount:
                                    Provider.of<CurrentDeliverysUpdate>(context)
                                        .deliverys
                                        .length,
                                itemBuilder: (context, index) {
                                  return DeliveryMiniAdmin(
                                      item: Provider.of<CurrentDeliverysUpdate>(
                                              context)
                                          .deliverys[index]);
                                }))))
              ])
        : const Text('אין הוברלות');
  }
}

class CurrentDeliverysUpdate extends ChangeNotifier {
  List<Delivery> deliverys = [];
  void updateDelivery(Delivery delivery) {
    deliverys.add((delivery));
    notifyListeners();
  }
}
