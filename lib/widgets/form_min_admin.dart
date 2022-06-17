import 'package:flutter/material.dart';
import 'package:hardwarestore/models/contact.dart';
import 'package:hardwarestore/models/legal_document.dart';
import 'package:hardwarestore/services/tools.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LegalFormMiniAdmin extends StatefulWidget {
  final LegalDocument item;

  const LegalFormMiniAdmin({Key? key, required this.item}) : super(key: key);

  @override
  State<LegalFormMiniAdmin> createState() => _LegalFormMiniAdminState();
}

class _LegalFormMiniAdminState extends State<LegalFormMiniAdmin> {
  Contact? legalFormContact = Contact();

  @override
  Widget build(BuildContext context) {
    if (widget.item.contactId != null &&
        Provider.of<EntityModification>(context).contacts != null &&
        Provider.of<EntityModification>(context).contacts.isNotEmpty &&
        Provider.of<EntityModification>(context)
                .contacts
                .where((element) => element.id == widget.item.contactId) !=
            null) {
      legalFormContact = Provider.of<EntityModification>(context)
          .contacts
          .where((element) => element.id == widget.item.contactId)
          .first;
    }

    return InkWell(
        onTap: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => CreateNewLegalFormForm(
          //             item: widget.item,
          //           )),
          // );
        },
        child: Card(
            child: SizedBox(
          // padding: const EdgeInsets.all(5),
          height: 100,
          width: double.infinity,
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.indigo.shade300,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    height: 24,
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(right: 8),
                          width: 65,
                          child: Text(
                            widget.item.id.toString(),
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Text(widget.item.active.toString(),
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.displaySmall),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(children: [
              Flexible(
                  flex: 60,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(right: 8, left: 4),
                            height: 20,
                            child: Icon(
                              Icons.person,
                              color: Colors.indigo.shade300,
                              size: 18,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: legalFormContact?.id == null ||
                                    legalFormContact?.id == 0
                                ? Text(AppLocalizations.of(context)!.na)
                                : Text(
                                    legalFormContact!.last_name.toString() +
                                        ' ' +
                                        legalFormContact!.first_name.toString(),
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(right: 8, left: 4),
                            //width: 65,
                            child: Icon(
                              Icons.home_work,
                              color: Colors.indigo.shade300,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ))
            ]),
          ]),
        )));
  }
}
