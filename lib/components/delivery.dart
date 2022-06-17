import 'package:flutter/material.dart';
import 'package:hardwarestore/services/api.dart';
import 'package:hardwarestore/widgets/delivery_min_admin.dart';
import 'package:provider/provider.dart';

import '../models/delivery.dart';
import '../services/tools.dart';

class DeliverysList extends StatefulWidget {
  DeliverysList({Key? key}) : super(key: key);

  @override
  State<DeliverysList> createState() => _DeliverysListState();
}

class _DeliverysListState extends State<DeliverysList> {
  List<Delivery>? myDeliverys;
  var isLoaded = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Delivery>?>(
        future: Repository().getDeliverys(),
        builder: (context, AsyncSnapshot<List<Delivery>?> deliverySnap) {
          if (deliverySnap.connectionState == ConnectionState.none &&
              deliverySnap.hasData == null) {
            return Container();
          }
          int len = deliverySnap.data?.length ?? 0;

          return SizedBox(
              height: MediaQuery.of(context).size.height * 0.80,
              child: Scrollbar(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: deliverySnap.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        Provider.of<EntityModification>(context).deliveries =
                            deliverySnap.data!;
                        return DeliveryMiniAdmin(
                            item: deliverySnap.data![index]);
                      })));
        });
  }
}
