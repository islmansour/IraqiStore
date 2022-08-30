import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:hardwarestore/components/add_items_to_orders.dart';
import 'package:hardwarestore/models/delivery.dart';
import 'package:hardwarestore/models/orders.dart';
import 'package:hardwarestore/services/api.dart';
import 'package:hardwarestore/services/tools.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderBubbleButtons extends StatefulWidget {
  final Order order;
  const OrderBubbleButtons({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderBubbleButtons> createState() => _OrderBubbleButtonsState();
}

class _OrderBubbleButtonsState extends State<OrderBubbleButtons>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var format = NumberFormat.simpleCurrency(locale: 'he');
    var translate = AppLocalizations.of(context);

    return widget.order.isReadOnly
        ? Container()
        : FloatingActionBubble(
            // Menu items
            items: <Bubble>[
              // Floating action menu item
              Bubble(
                title: translate!.addProduct,
                iconColor: Colors.white,
                bubbleColor: Colors.blue,
                icon: Icons.add,
                titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
                onPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              AddItemToOrder(order: widget.order)));
                  _animationController.reverse();
                },
              ),
              // Floating action menu item
              Bubble(
                title: translate.loading,
                iconColor: Colors.white,
                bubbleColor: Colors.blue,
                icon: Icons.category,
                titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
                onPress: () {
                  widget.order.status = 'loading';

                  Delivery delivery = Delivery(
                      id: 0,
                      accountId: widget.order.accountId,
                      contactId: widget.order.contactId,
                      date: DateTime.now(),
                      orderId: widget.order.id,
                      status: 'xXx');
                  Repository().upsertDelivery(delivery)!.then((value) {
                    widget.order.deliveryId = value;

                    Repository().upsertOrder(widget.order);
                    Provider.of<EntityModification>(context, listen: false)
                        .update(widget.order);
                    setState(() {});
                  });

                  _animationController.reverse();
                },
              ),
              //Floating action menu item
              Bubble(
                title: translate.cancelled,
                iconColor: Colors.white,
                bubbleColor: Colors.blue,
                icon: Icons.shopping_cart,
                titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
                onPress: () {
                  widget.order.status = 'cancelled';
                  Repository().upsertOrder(widget.order);
                  Provider.of<EntityModification>(context, listen: false)
                      .update(widget.order);
                  _animationController.reverse();
                },
              ),
              Bubble(
                title: translate.delivered,
                iconColor: Colors.white,
                bubbleColor: Colors.blue,
                icon: Icons.shopping_basket,
                titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
                onPress: () {
                  widget.order.status = 'delivered';
                  Repository().upsertOrder(widget.order);
                  Provider.of<EntityModification>(context, listen: false)
                      .update(widget.order);
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (BuildContext context) => CreateNewQuoteForm()));
                  _animationController.reverse();
                },
              ),
            ],

            // animation controller
            animation: _animation,

            // On pressed change animation state
            onPress: () {
              _animationController.isCompleted
                  ? _animationController.reverse()
                  : _animationController.forward();
            },

            // Floating Action button Icon color
            iconColor: Colors.blue,

            // Flaoting Action button Icon
            iconData: Icons.add,
            backGroundColor: Colors.white,
          );
  }
}
