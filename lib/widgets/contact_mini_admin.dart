import 'package:flutter/material.dart';
import 'package:hardwarestore/models/contact.dart';
import 'package:hardwarestore/screens/screens.dart';
import '../screens/admin/new_contact.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactMiniAdmin extends StatefulWidget {
  final Contact item;

  const ContactMiniAdmin({Key? key, required this.item}) : super(key: key);

  @override
  State<ContactMiniAdmin> createState() => _ContactMiniAdminState();
}

class _ContactMiniAdminState extends State<ContactMiniAdmin> {
  Contact? contactContact = Contact();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CreateNewContactForm(
                    item: widget.item,
                  )),
        );
      },
      child: Card(
        child: SizedBox(
            // padding: const EdgeInsets.all(5),
            height: 80,
            width: double.infinity,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        height: 24,
                        alignment: Alignment.centerRight,
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(right: 12),
                              //   width: 65,
                              // child: Text(
                              //   widget.item.first_name.toString(),
                              //   style:
                              //       Theme.of(context).textTheme.displayMedium,
                              // ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Text(
                                  widget.item.first_name.toString() +
                                      ' ' +
                                      widget.item.last_name.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(right: 8, left: 4),
                      //width: 65,
                      child: const Icon(
                        Icons.home_work,
                        color: Colors.teal,
                        size: 16,
                      ),
                    ),
                    Flexible(
                      flex: 60,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: widget.item.street == null ||
                                        widget.item.street == ""
                                    ? 50
                                    : widget.item.street!.length > 30
                                        ? MediaQuery.of(context).size.width *
                                            0.3
                                        : widget.item.street!.length * 5 +
                                            5, //MediaQuery.of(context).size.width * 0.3,
                                child: widget.item.street == null ||
                                        widget.item.street == ""
                                    ? Text(
                                        AppLocalizations.of(context)!.na,
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
                                padding:
                                    const EdgeInsets.only(right: 8, left: 4),
                                child: widget.item.pobox == null ||
                                        widget.item.pobox == ""
                                    ? Text(
                                        '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      )
                                    : Text(
                                        ',' + widget.item.pobox.toString(),
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
                                padding:
                                    const EdgeInsets.only(right: 0, left: 4),
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
                                padding: const EdgeInsets.only(right: 2),
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
                                        // Scaffold.of(context).showSnackBar(
                                        //     SnackBar(
                                        //         content: Text(
                                        //             'Could not launch $url')));
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
                                        // Scaffold.of(context).showSnackBar(
                                        //     SnackBar(
                                        //         content: Text(
                                        //             'Could not launch $url')));
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
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatScreen(
                                                  contact: widget.item,
                                                )),
                                      );
                                      // if (widget.item == null ||
                                      //     widget.item.phone == null ||
                                      //     widget.item.phone == "") return;

                                      // var url =
                                      //     Uri.parse("sms:${widget.item.phone}");
                                      // if (await canLaunchUrl(url)) {
                                      //   await launchUrl(url);
                                      // } else {
                                      //   Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => ChatScreen(
                                      //               contact: widget.item,
                                      //             )),
                                      //   );
                                      // }
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
