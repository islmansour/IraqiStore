import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:hardwarestore/models/account.dart';
import 'package:hardwarestore/models/legal_document.dart';
import 'package:hardwarestore/services/api.dart';
import 'package:hardwarestore/services/tools.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class LegalFormBubbleButtons extends StatefulWidget {
  final Account account;
  const LegalFormBubbleButtons({Key? key, required this.account})
      : super(key: key);

  @override
  State<LegalFormBubbleButtons> createState() => _LegalFormBubbleButtonsState();
}

class _LegalFormBubbleButtonsState extends State<LegalFormBubbleButtons>
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
        // Bubble(
        //   title: translate!.allLegalAgrements,
        //   iconColor: Colors.white,
        //   bubbleColor: Colors.indigo.shade300,
        //   icon: Icons.document_scanner,
        //   titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
        //   onPress: () {
        //     _animationController.reverse();
        //   },
        // ),
        // Floating action menu item
        Bubble(
          title: translate!.supplyLegalAgreement,
          iconColor: Colors.white,
          bubbleColor: Colors.indigo.shade300,
          icon: Icons.document_scanner,
          titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
          onPress: () {
            try {
              widget.account.accountLegalForms ??= <LegalDocument>[];

              if (widget.account.accountLegalForms!
                  .where((element) =>
                      element.name == 'supply' && element.active == true)
                  .isEmpty) {
                LegalDocument doc = LegalDocument(
                    accountId: widget.account.id, active: true, name: 'supply');

                Repository().upsertLegalDocument(doc)?.then((value) {
                  doc.id = value;
                  widget.account.accountLegalForms?.add(doc);
                  Provider.of<EntityModification>(context, listen: false)
                      .updateAccount(widget.account);

                  setState(() {});
                });
              }
            } catch (e) {
              // Scaffold.of(context).showSnackBar(SnackBar(
              //     content: Text(AppLocalizations.of(context)!.errorChoosen)));
            }
            _animationController.reverse();
          },
        ),
        //Floating action menu item
        Bubble(
          title: translate.guaranteeLegalAgreement,
          iconColor: Colors.white,
          bubbleColor: Colors.indigo.shade300,
          icon: Icons.document_scanner,
          titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
          onPress: () {
            try {
              widget.account.accountLegalForms ??= <LegalDocument>[];

              if (widget.account.accountLegalForms!
                  .where((element) =>
                      element.name == 'guarantee' && element.active == true)
                  .isEmpty) {
                LegalDocument doc = LegalDocument(
                    accountId: widget.account.id,
                    active: true,
                    name: 'guarantee');

                Repository().upsertLegalDocument(doc)?.then((value) {
                  doc.id = value;
                  widget.account.accountLegalForms?.add(doc);
                  Provider.of<EntityModification>(context, listen: false)
                      .updateAccount(widget.account);

                  setState(() {});
                });
              }
            } catch (e) {
              // Scaffold.of(context).showSnackBar(SnackBar(
              //     content: Text(AppLocalizations.of(context)!.errorChoosen)));
            }
            //
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
      iconColor: Colors.indigo.shade300,

      // Flaoting Action button Icon
      iconData: Icons.add,
      backGroundColor: Colors.white,
    );
  }
}
