import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../models/user.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserMiniAdmin extends StatefulWidget {
  final User item;

  const UserMiniAdmin({Key? key, required this.item}) : super(key: key);

  @override
  State<UserMiniAdmin> createState() => _UserMiniAdminState();
}

class _UserMiniAdminState extends State<UserMiniAdmin> {
  @override
  Widget build(BuildContext context) {
    var format = NumberFormat.simpleCurrency(locale: 'he');
    var translation = AppLocalizations.of(context);

    return InkWell(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => CreateNewUserForm(
        //             item: widget.item,
        //           )),
        // );
      },
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: SizedBox(
            height: 100,
            child: Column(
              children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Flexible(
                      flex: 60, // 60%
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.teal,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          topLeft: Radius.circular(10))),
                                  height: 30,
                                  alignment: Alignment.centerRight,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Row(
                                          children: [
                                            Text(
                                                widget.item
                                                        .userContactDetails(
                                                            context)
                                                        .first_name
                                                        .toString() +
                                                    " ",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayMedium),
                                            Text(
                                                widget.item
                                                    .userContactDetails(context)
                                                    .last_name
                                                    .toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayMedium),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                flex: 40,
                                child: Column(
                                  children: [
                                    Container(
                                      //    height: 30,
                                      alignment: Alignment.topRight,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0, top: 2),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.person,
                                                  size: 20,
                                                  color: Colors.teal,
                                                ),
                                                Text(
                                                    widget.item.uid.toString()),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                flex: 60,
                                child: Column(
                                  children: [],
                                ),
                              ),
                              Flexible(
                                flex: 10,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Row(
                                        children: [
                                          if (widget.item.active != null &&
                                              widget.item.active == true)
                                            Text(translation!.active)
                                          else
                                            Text(translation!.inactive)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      )),
                ])
              ],
            ),
          )),
    );
  }
}
