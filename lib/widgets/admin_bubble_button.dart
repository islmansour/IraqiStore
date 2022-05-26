import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';

import '../screens/admin/new_account.dart';
import '../screens/admin/new_order.dart';
import '../screens/admin/new_product.dart';
import '../screens/admin/new_quote.dart';

class AdminBubbleButtons extends StatefulWidget {
  const AdminBubbleButtons({Key? key}) : super(key: key);

  @override
  State<AdminBubbleButtons> createState() => _AdminBubbleButtonsState();
}

class _AdminBubbleButtonsState extends State<AdminBubbleButtons>
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
    return FloatingActionBubble(
      // Menu items
      items: <Bubble>[
        // Floating action menu item
        Bubble(
          title: 'לקוח',
          iconColor: Colors.white,
          bubbleColor: Colors.blue,
          icon: Icons.person_add,
          titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
          onPress: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => CreateNewAccountForm()));
            _animationController.reverse();
          },
        ),
        // Floating action menu item
        Bubble(
          title: "מוצר",
          iconColor: Colors.white,
          bubbleColor: Colors.blue,
          icon: Icons.category,
          titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
          onPress: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => CreateNewProductForm()));
            _animationController.reverse();
          },
        ),
        //Floating action menu item
        Bubble(
          title: "הזמנה",
          iconColor: Colors.white,
          bubbleColor: Colors.blue,
          icon: Icons.shopping_cart,
          titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
          onPress: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => CreateNewOrderForm()));
            _animationController.reverse();
          },
        ),
        Bubble(
          title: "הצעת מחיר ",
          iconColor: Colors.white,
          bubbleColor: Colors.blue,
          icon: Icons.shopping_basket,
          titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
          onPress: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => CreateNewQuoteForm()));
            _animationController.reverse();
          },
        ),
      ],

      // animation controller
      animation: _animation,

      // On pressed change animation state
      onPress: () => _animationController.isCompleted
          ? _animationController.reverse()
          : _animationController.forward(),

      // Floating Action button Icon color
      iconColor: Colors.blue,

      // Flaoting Action button Icon
      iconData: Icons.ac_unit,
      backGroundColor: Colors.white,
    );
  }
}
