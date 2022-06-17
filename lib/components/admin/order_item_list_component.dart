import 'package:flutter/material.dart';
import 'package:hardwarestore/models/order_item.dart';
import 'package:hardwarestore/models/orders.dart';
import 'package:hardwarestore/services/api.dart';
import 'package:hardwarestore/services/django_services.dart';
import 'package:hardwarestore/widgets/order_item_admin.dart';
import 'package:provider/provider.dart';

import '../../services/tools.dart';

class OrderItemList extends StatefulWidget {
  final int orderId;
  OrderItemList({Key? key, required this.orderId}) : super(key: key);

  @override
  State<OrderItemList> createState() => _OrderItemListState();
}

class _OrderItemListState extends State<OrderItemList> {
  List<OrderItem>? orderItems;
  var isLoaded = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<EntityModification>(context)
        .order
        .where(
          (element) => element.id == widget.orderId,
        )
        .isEmpty) {
      Provider.of<EntityModification>(context).refreshOrdersFromDB();
    }
    Order order = Provider.of<EntityModification>(context)
        .order
        .where(
          (element) => element.id == widget.orderId,
        )
        .first;
    List<OrderItem>? _items = order.orderItems;
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Scrollbar(
            child: RefreshIndicator(
          onRefresh: _pullRefresh,
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: _items?.length ?? 0,
              itemBuilder: (context, index) {
                Provider.of<CurrentOrderItemUpdate>(context).orderItems =
                    _items;

                return order.isReadOnly
                    ? Container(
                        child: OrderItemAdmin(
                          item: _items![index],
                          orderId: widget.orderId,
                        ),
                      )
                    : Dismissible(
                        key: Key(_items![index].id.toString()),
                        background: Container(color: Colors.red),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          if (order.isReadOnly) return;
                          OrderItem _currentItem = _items[index];

                          //DjangoServices().deleteOrderItem(_items[index].id!);
                          Repository().deleteOrderItem(_items[index].id!);

                          Provider.of<EntityModification>(context,
                                  listen: false)
                              .order
                              .where((element) => element.id == widget.orderId)
                              .first
                              .orderItems!
                              .forEach((item) {
                            if (item.id == _currentItem.id!) {
                              Provider.of<EntityModification>(context,
                                      listen: false)
                                  .order
                                  .where(
                                      (element) => element.id == widget.orderId)
                                  .first
                                  .orderItems
                                  ?.forEach(
                                (itemElement) {
                                  if (itemElement.id == _currentItem.id) {
                                    itemElement = OrderItem();
                                  }
                                },
                              );
                            }

                            Order x = Provider.of<EntityModification>(context,
                                    listen: false)
                                .order
                                .where(
                                    (element) => element.id == widget.orderId)
                                .first;

                            Provider.of<EntityModification>(context,
                                    listen: false)
                                .update(x);
                          });

                          setState(() {
                            _items.removeAt(index);
                          });
                          Scaffold.of(context).showSnackBar(
                              const SnackBar(content: Text("הוסר בהצלה")));
                        },
                        child: OrderItemAdmin(
                          item: _items[index],
                          orderId: widget.orderId,
                        ),
                      );
              }),
        )));
  }

  Future<void> _pullRefresh() async {
    //  List<WordPair> freshWords = await WordDataSource().getFutureWords(delay: 2);
    setState(() {
      //    words = freshWords;
    });
    // why use freshWords var? https://stackoverflow.com/a/52992836/2301224
  }
}

class _dismis extends StatelessWidget {
  const _dismis({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class CurrentOrderItemUpdate extends ChangeNotifier {
  List<OrderItem>? orderItems;
  void updateProduct(OrderItem item) {
    orderItems?.add((item));
    notifyListeners();
  }
}
