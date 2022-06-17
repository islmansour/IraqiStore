import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/add_item_to_quote.dart';

class QuoteBubbleButtons extends StatefulWidget {
  final int quoteId;
  const QuoteBubbleButtons({Key? key, required this.quoteId}) : super(key: key);

  @override
  State<QuoteBubbleButtons> createState() => _QuoteBubbleButtonsState();
}

class _QuoteBubbleButtonsState extends State<QuoteBubbleButtons>
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
    var translate = AppLocalizations.of(context);

    return FloatingActionBubble(
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
                        AddItemToQuote(quoteId: widget.quoteId)));
            _animationController.reverse();
          },
        ),
        // Floating action menu item
        Bubble(
          title: translate.confirm,
          iconColor: Colors.white,
          bubbleColor: Colors.blue,
          icon: Icons.category,
          titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
          onPress: () {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (BuildContext context) => CreateNewProductForm()));
            // _animationController.reverse();
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
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (BuildContext context) => CreateNewQuoteForm()));
            // _animationController.reverse();
          },
        ),
        // Bubble(
        //   title: translate.,
        //   iconColor: Colors.white,
        //   bubbleColor: Colors.blue,
        //   icon: Icons.shopping_basket,
        //   titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
        //   onPress: () {
        //     // Navigator.push(
        //     //     context,
        //     //     MaterialPageRoute(
        //     //         builder: (BuildContext context) => CreateNewQuoteForm()));
        //     // _animationController.reverse();
        //   },
        // ),
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
