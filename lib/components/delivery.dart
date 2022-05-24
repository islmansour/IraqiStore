import 'package:flutter/material.dart';
import 'package:hardwarestore/models/delivery.dart';
import 'package:provider/provider.dart';

import '../services/django_services.dart';
import '../widgets/delivery_min_admin.dart';

class DeliverysList extends StatefulWidget {
  DeliverysList({Key? key}) : super(key: key);

  @override
  State<DeliverysList> createState() => _DeliverysListState();
}

class _DeliverysListState extends State<DeliverysList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Delivery>?>(
        future: DjangoServices().getDeliverys(),
        builder: (context, AsyncSnapshot<List<Delivery>?> deliverySnap) {
          if (deliverySnap.connectionState == ConnectionState.none &&
              deliverySnap.hasData == null) {
            return Container();
          }
          int len = deliverySnap.data?.length ?? 0;

          return ExpansionTile(
              title: Text('הובלות ' + len.toString(),
                  style: Theme.of(context).textTheme.displayMedium),
              children: [
                ListTile(
                    title: SizedBox(
                        height: MediaQuery.of(context).size.height / 2,
                        child: Scrollbar(
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: deliverySnap.data?.length ?? 0,
                                itemBuilder: (context, index) {
                                  Provider.of<CurrentDeliverysUpdate>(context)
                                      .deliverys = deliverySnap.data;
                                  return DeliveryMiniAdmin(
                                      item: deliverySnap.data![index]);
                                }))))
              ]);
        });
  }
}

class CurrentDeliverysUpdate extends ChangeNotifier {
  List<Delivery>? deliverys = [];
  void updateDelivery(Delivery delivery) {
    deliverys?.add((delivery));
    notifyListeners();
  }
}
