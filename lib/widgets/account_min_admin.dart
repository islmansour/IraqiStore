import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:hardwarestore/components/contact.dart';
import 'package:hardwarestore/models/account.dart';
import 'package:hardwarestore/models/contact.dart';
import 'package:hardwarestore/screens/admin/new_account.dart';
import 'package:hardwarestore/services/tools.dart';
import 'package:provider/provider.dart';

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
    if (widget.item.contactId != null &&
        Provider.of<EntityModification>(context).contacts != null &&
        Provider.of<EntityModification>(context).contacts.isNotEmpty &&
        Provider.of<EntityModification>(context)
                .contacts
                .where((element) => element.id == widget.item.contactId) !=
            null) {
      accountContact = Provider.of<EntityModification>(context)
          .contacts
          .where((element) => element.id == widget.item.contactId)
          .first;
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
                  children: [
                    Flexible(
                      flex: 60,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.only(right: 8, left: 4),
                                height: 20,
                                child: Icon(
                                  Icons.person,
                                  color: Colors.indigo.shade300,
                                  size: 18,
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: accountContact?.id == null ||
                                        accountContact?.id == 0
                                    ? Text('אין')
                                    : Text(
                                        accountContact!.last_name.toString() +
                                            ' ' +
                                            accountContact!.first_name
                                                .toString(),
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
                                padding:
                                    const EdgeInsets.only(right: 8, left: 4),
                                //width: 65,
                                child: Icon(
                                  Icons.home_work,
                                  color: Colors.indigo.shade300,
                                  size: 16,
                                ),
                              ),
                              SizedBox(
                                width: widget.item.street == null
                                    ? 50
                                    : widget.item.street!.length > 30
                                        ? MediaQuery.of(context).size.width *
                                            0.3
                                        : widget.item.street!.length * 5 +
                                            5, //MediaQuery.of(context).size.width * 0.3,
                                child: widget.item.street == null
                                    ? Text('אין רחוב')
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
                                child: widget.item.pobox == null
                                    ? Text(
                                        '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      )
                                    : Text(
                                        'ת.ד ' + widget.item.pobox.toString(),
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
                                    const EdgeInsets.only(right: 8, left: 4),
                                child: widget.item.pobox == null
                                    ? Text(
                                        '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      )
                                    : Text(
                                        widget.item.town.toString() + ',',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(right: 2),
                                child: widget.item.pobox == null
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
                                    onPressed: () {
                                      setState(() {});
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
                                    onPressed: () {
                                      setState(() {});
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
                                      setState(() {});
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
