import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:hardwarestore/models/account.dart';
import 'package:hardwarestore/screens/admin/new_account.dart';

class AccountMiniAdmin extends StatefulWidget {
  final Account item;

  const AccountMiniAdmin({Key? key, required this.item}) : super(key: key);

  @override
  State<AccountMiniAdmin> createState() => _AccountMiniAdminState();
}

class _AccountMiniAdminState extends State<AccountMiniAdmin> {
  @override
  Widget build(BuildContext context) {
    /*
    1 columns that has
    3 rows
      1st row: has one ListTile with one text: Account Number + Account Date
      2nd row: has 3 columns each as a container with a text.
        first column is the account name
        second column is the contact name
        third column : if contact exists, displays contact phone. otherwise display account phone
      3rd row: has 2 columns: First colum is Account Status , second is dlivery status



    */
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
      child: SizedBox(
          // padding: const EdgeInsets.all(5),
          height: 60,
          width: double.infinity,
          child: Column(
            children: [
              Container(
                decoration: DottedDecoration(
                    shape: Shape.box,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    dash: <int>[2, 2],
                    strokeWidth: 1),
                child: Row(children: [
                  Flexible(
                      flex: 30, // 15%
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue.shade400,
                            borderRadius: const BorderRadius.only(
                                //      bottomRight: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        height: 48,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.item.account_number.toString(),
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ],
                        ),
                      )),
                  Flexible(
                      flex: 70, // 60%
                      child: Container(
                        decoration: BoxDecoration(
                            //     color: Colors.blue.shade400,
                            ),
                        height: 48,
                        alignment: Alignment.centerRight,
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 4.0, top: 8),
                              child: Text(widget.item.name.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium),
                            ),
                          ],
                        ),
                      )),
                  Container(
                    decoration: BoxDecoration(
//                    color: Colors.blue.shade400,
                        ),
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
                    decoration: BoxDecoration(
                        //       color: Colors.blue.shade400,
                        borderRadius: const BorderRadius.only(
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
                ]),
              ),
            ],
          )),
    );
  }
}
