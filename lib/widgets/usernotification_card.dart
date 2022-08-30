import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hardwarestore/models/userNotifications.dart';
import 'package:hardwarestore/services/api.dart';
import 'package:intl/intl.dart';

class UserNotificationsMiniAdmin extends StatefulWidget {
  final UserNotifications item;

  const UserNotificationsMiniAdmin({Key? key, required this.item})
      : super(key: key);

  @override
  State<UserNotificationsMiniAdmin> createState() =>
      _UserNotificationsMiniAdminState();
}

class _UserNotificationsMiniAdminState
    extends State<UserNotificationsMiniAdmin> {
  @override
  Widget build(BuildContext context) {
    //  UserNotifications _notification = UserNotifications();
    var format = NumberFormat.simpleCurrency(locale: 'he');
    bool isToday = DateTime(widget.item.created!.year,
                widget.item.created!.month, widget.item.created!.day)
            .difference(DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day))
            .inDays ==
        0;
    return InkWell(
      onTap: () {
        setState(() {
          widget.item.seen = DateTime.now();
          Repository().upsertUserNotification(widget.item);
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Card(
          elevation: 5,
          child: SizedBox(
              // padding: const EdgeInsets.all(5),
              height: 80,
              //   width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 8,
                  ),
                  SizedBox(
                    width: 55,
                    child: Text(
                      isToday
                          ? DateFormat('hh:mm').format(widget.item.created!)
                          : DateFormat('dd/MM/yy hh:mm')
                              .format(widget.item.created!),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: widget.item.content == null ||
                              widget.item.content == ""
                          ? Text(
                              AppLocalizations.of(context)!.na,
                              style: Theme.of(context).textTheme.bodySmall,
                            )
                          : Text(
                              widget.item.content.toString(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: widget.item.seen == null
                                  ? Theme.of(context).textTheme.titleMedium
                                  : Theme.of(context).textTheme.bodyMedium,
                            ),
                    ),
                  ),
                  Icon(
                    widget.item.seen == null
                        ? Icons.circle
                        : Icons.circle_outlined,
                    color:
                        widget.item.seen == null ? Colors.blue : Colors.black,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
