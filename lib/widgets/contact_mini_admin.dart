import 'package:flutter/material.dart';
import 'package:hardwarestore/models/contact.dart';

class ContactMiniAdmin extends StatefulWidget {
  final Contact item;

  const ContactMiniAdmin({Key? key, required this.item}) : super(key: key);

  @override
  State<ContactMiniAdmin> createState() => _ContactMiniAdminState();
}

class _ContactMiniAdminState extends State<ContactMiniAdmin> {
  @override
  Widget build(BuildContext context) {
    print('ContactMiniAdmin' + widget.item.id.toString());

    return InkWell(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => CreateNewAccountForm(
        //             item: widget.item,
        //           )),
        // );
      },
      child: SizedBox(
          // padding: const EdgeInsets.all(5),
          height: 60,
          width: double.infinity,
          child: Column(
            children: [
              Row(children: [
                Flexible(
                    flex: 30, // 15%
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.only(
                              //      bottomRight: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      height: 48,
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              widget.item.first_name.toString(),
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                          ),
                        ],
                      ),
                    )),
                Flexible(
                    flex: 70, // 60%
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                      ),
                      height: 48,
                      alignment: Alignment.centerRight,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 4.0, top: 8),
                            child: Text(widget.item.last_name.toString(),
                                style:
                                    Theme.of(context).textTheme.displayMedium),
                          ),
                        ],
                      ),
                    )),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                  ),
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(right: 0.0),
                          child: IconButton(
                            color: Colors.blue.shade500,
                            icon: const Icon(Icons.email),
                            onPressed: () {
                              setState(() {});
                            },
                          )),
                    ],
                  ),
                ),
                Container(
                  color: Colors.orange,
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
                      color: Colors.orange,
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(10))),
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(right: 0.0),
                          child: IconButton(
                            color: Colors.yellowAccent,
                            icon: const Icon(Icons.message),
                            onPressed: () {
                              setState(() {});
                            },
                          )),
                    ],
                  ),
                )
              ]),
            ],
          )),
    );
  }
}
