import 'package:flutter/material.dart';

import 'package:hardwarestore/models/account.dart';
import 'package:hardwarestore/models/contact.dart';
import 'package:hardwarestore/screens/admin/new_account.dart';
import 'package:hardwarestore/services/tools.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountMiniAdmin extends StatefulWidget {
  final Account item;

  const AccountMiniAdmin({Key? key, required this.item}) : super(key: key);

  @override
  State<AccountMiniAdmin> createState() => _AccountMiniAdminState();
}

class _AccountMiniAdminState extends State<AccountMiniAdmin> {
  Contact? accountContact = Contact();

  @override
  Widget build(BuildContext context) {
    var translation = AppLocalizations.of(context);
    if (widget.item.contactId != null &&
        Provider.of<EntityModification>(context).contacts.isNotEmpty &&
        Provider.of<EntityModification>(context)
            .contacts
            .where((element) => element.id == widget.item.contactId)
            .isNotEmpty) {
      try {
        accountContact = Provider.of<EntityModification>(context)
            .contacts
            .where((element) => element.id == widget.item.contactId)
            .first;
      } catch (e) {
        throw "$e";
      }
    }
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CreateNewAccountForm(
                    item: widget.item,
                  )),
        );
      },
      child: Card(
        child: SizedBox(
            // padding: const EdgeInsets.all(5),
            height: 100,
            width: double.infinity,
            child: Column(
              children: [
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
                                widget.item.account_number.toString(),
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Text(widget.item.name.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      Theme.of(context).textTheme.displaySmall),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 60,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                        right: 8, left: 4),
                                    height: 20,
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.indigo.shade300,
                                      size: 18,
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: accountContact?.id == null ||
                                            accountContact?.id == 0
                                        ? Text(
                                            translation!.na,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall,
                                          )
                                        : Text(
                                            accountContact!.last_name
                                                    .toString() +
                                                ' ' +
                                                accountContact!.first_name
                                                    .toString(),
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium,
                                          ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 50,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      Provider.of<EntityModification>(context)
                                          .getLovValue(
                                              'ACCOUNT_TYPE',
                                              widget.item.type.toString(),
                                              AppLocalizations.of(context)!
                                                  .localeName)
                                          .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                        right: 8, left: 4),
                                    //width: 65,
                                    child: Icon(
                                      Icons.home_work,
                                      color: Colors.indigo.shade300,
                                      size: 16,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: widget.item.street == null ||
                                                widget.item.street == ""
                                            ? 50
                                            : widget.item.street!.length > 30
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3
                                                : widget.item.street!.length *
                                                    10,
                                        child: widget.item.street == null ||
                                                widget.item.street == ""
                                            ? Text(
                                                translation!.na,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              )
                                            : Text(
                                                widget.item.street.toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(
                                            right: 8, left: 4),
                                        child: widget.item.pobox == null ||
                                                widget.item.pobox == ""
                                            ? Text(
                                                '',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              )
                                            : Text(
                                                ',' +
                                                    widget.item.pobox
                                                        .toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(
                                            right: 0, left: 4),
                                        child: widget.item.town == null ||
                                                widget.item.town == ""
                                            ? Text(
                                                '',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              )
                                            : Text(
                                                widget.item.town.toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                      ),
                                      Container(
                                        padding:
                                            const EdgeInsets.only(right: 2),
                                        child: widget.item.zip == null ||
                                                widget.item.zip == ""
                                            ? Text(
                                                '',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              )
                                            : Text(
                                                widget.item.zip.toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          alignment: Alignment.topCenter,
                          child: Column(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(right: 0.0),
                                  child: IconButton(
                                    color: Colors.blueGrey,
                                    icon: const Icon(Icons.email),
                                    onPressed: () async {
                                      if (widget.item == null ||
                                          widget.item.email == null ||
                                          widget.item.email == "") return;

                                      var url = Uri.parse(
                                          "mailto:${widget.item.email}");
                                      if (await canLaunchUrl(url)) {
                                        await launchUrl(url);
                                      } else {
                                        Scaffold.of(context).showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Could not launch $url')));
                                      }
                                    },
                                  )),
                            ],
                          ),
                        ),
                        Container(
                          // color: Colors.blue.shade400,
                          alignment: Alignment.topCenter,
                          child: Column(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(right: 0.0),
                                  child: IconButton(
                                    color: Colors.brown,
                                    icon: const Icon(Icons.phone),
                                    onPressed: () async {
                                      if (widget.item == null ||
                                          widget.item.phone == null ||
                                          widget.item.phone == "") return;

                                      var url =
                                          Uri.parse("tel:${widget.item.phone}");
                                      if (await canLaunchUrl(url)) {
                                        await launchUrl(url);
                                      } else {
                                        Scaffold.of(context).showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Could not launch $url')));
                                      }
                                    },
                                  )),
                            ],
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                              //       color: Colors.blue.shade400,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10))),
                          alignment: Alignment.topCenter,
                          child: Column(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(right: 0.0),
                                  child: IconButton(
                                    color: Colors.orange,
                                    icon: const Icon(Icons.message),
                                    onPressed: () async {
                                      if (widget.item == null ||
                                          widget.item.phone == null ||
                                          widget.item.phone == "") return;

                                      var url =
                                          Uri.parse("sms:${widget.item.phone}");
                                      if (await canLaunchUrl(url)) {
                                        await launchUrl(url);
                                      } else {
                                        Scaffold.of(context).showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Could not launch $url')));
                                      }
                                    },
                                  )),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                )
              ],
            )),
      ),
    );
  }
}
