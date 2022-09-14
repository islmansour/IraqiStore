import 'package:flutter/material.dart';

import 'package:hardwarestore/components/client/add_order_items_client.dart';
import 'package:hardwarestore/components/client/client_order_item_total.dart';
import 'package:hardwarestore/components/client/order_items_confirmation.dart';
import 'package:hardwarestore/components/user.dart';
import 'package:hardwarestore/controllers/navigation.dart';
import 'package:hardwarestore/models/order_item.dart';
import 'package:hardwarestore/models/orders.dart';
import 'package:hardwarestore/services/api.dart';
import 'package:hardwarestore/services/tools.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../models/account.dart';

class NewOrderStepper extends StatefulWidget {
  NewOrderStepper({Key? key}) : super(key: key);

  @override
  State<NewOrderStepper> createState() => _NewOrderStepperState();
}

class _NewOrderStepperState extends State<NewOrderStepper> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  int _currentStep = 0;
  StepperType stepperType = StepperType.horizontal;
  Order _data = Order();
  bool hasDelivery = false;
  @override
  void initState() {
    super.initState();
  }

  // void submit() {
  //   try {
  //     // First validate form.
  //     if (_formKey.currentState!.validate()) {
  //       _formKey.currentState?.save();
  //       //DjangoServices().upsertOrder(_data)?.then((value) {
  //       Repository().upsertOrder(_data)?.then((value) {
  //         _data.id == value;
  //         Provider.of<EntityModification>(context, listen: false).update(_data);
  //       });
  //       Navigator.pop(context);
  //       // Save our form now.
  //     }
  //   } catch (e) {
  //     Scaffold.of(context).showSnackBar(
  //         const SnackBar(content: Text("התרחשה תקלה בשמירת  ההזמנה החדשה.")));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var translation = AppLocalizations.of(context);
    try {
      _data.contactId =
          Provider.of<GetCurrentUser>(context).currentUser!.contactId;
    } catch (e) {}
    return Form(
      key: _formKey,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Provider.of<ClientEnvironment>(context).theCurrentOrder == null
                ? Padding(
                    padding: const EdgeInsets.only(top: 100.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          Provider.of<ClientEnvironment>(context, listen: false)
                              .initCurrentOrder();
                        });
                      },
                      child: Card(
                          elevation: 20,
                          shape: const CircleBorder(),
                          color: Colors.green,
                          child: Container(
                            child: Icon(
                              Icons.add_shopping_cart_rounded,
                              size: 80,
                              color: Colors.white,
                            ),
                            width: 100,
                            height: 100,
                          )),
                    ),
                  )
                : Expanded(
                    child: Theme(
                      data: ThemeData(
                          colorScheme: ColorScheme.light(
                              primary: Colors.redAccent,
                              secondary: Colors.green)),
                      child: Stepper(
                        controlsBuilder: (context, _) {
                          return Row(
                            children: <Widget>[
                              TextButton(
                                onPressed: (_data.accountId == null ||
                                        _data.accountId == 0 ||
                                        _currentStep == 2)
                                    ? null
                                    : () {
                                        continued();
                                      },
                                child: Text(translation!.proceed),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (_currentStep == 0) {
                                    Provider.of<NavigationController>(context,
                                            listen: false)
                                        .changeScreen('/');
                                    Provider.of<ClientEnvironment>(context,
                                            listen: false)
                                        .resetCurrentOrder();
                                  } else {
                                    back();
                                  }
                                },
                                child: _currentStep > 0
                                    ? Text(translation.back)
                                    : Text(translation.cancel),
                              ),
                            ],
                          );
                        },
                        type: stepperType,
                        physics: ScrollPhysics(),
                        currentStep: _currentStep,
                        onStepTapped: (step) => tapped(step),
                        onStepContinue: continued,
                        onStepCancel: cancel,
                        steps: <Step>[
                          Step(
                            title: Text(translation!.account),
                            content: Column(
                              children: <Widget>[
                                DropdownButtonFormField(
                                    items:
                                        Provider.of<EntityModification>(context)
                                            .accounts
                                            .map((Account acc) {
                                      return DropdownMenuItem(
                                          value: acc.id,
                                          child: Row(
                                            children: <Widget>[
                                              const Icon(
                                                Icons.people,
                                                size: 14,
                                                color: Colors.redAccent,
                                              ),
                                              const Text(' '),
                                              Text(
                                                acc.name!,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ));
                                    }).toList(),
                                    onChanged: (newValue) {
                                      // do other stuff with _category
                                      try {
                                        setState(() {
                                          _data.status = 'new';
                                          _data.accountId =
                                              int.parse(newValue.toString());
                                        });
                                      } catch (e) {
                                        Scaffold.of(context).showSnackBar(
                                            SnackBar(
                                                content: Text(translation
                                                    .errorDisplayAccount)));
                                      }
                                    },
                                    decoration: const InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(right: 8))),
                              ],
                            ),
                            isActive: _currentStep >= 0,
                            state: _currentStep >= 0
                                ? StepState.complete
                                : StepState.disabled,
                          ),
                          Step(
                            title: Text(translation.products),
                            content: Column(
                              children: <Widget>[
                                AddItemToOrderClient(
                                  clientOrder: _data,
                                )
                              ],
                            ),
                            isActive: _currentStep >= 0,
                            state: _currentStep >= 1
                                ? StepState.complete
                                : StepState.disabled,
                          ),
                          Step(
                            title: Text(translation.confirm),
                            content: Column(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 0.0, left: 0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                translation.delivery,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineSmall,
                                              ),
                                            ),
                                            Checkbox(
                                                value: hasDelivery,
                                                onChanged: (value) {
                                                  setState(() {
                                                    hasDelivery = value!;

                                                    Repository()
                                                        .getSingleProducts(
                                                            '000000000')
                                                        .then((value) {
                                                      if (value != null) {
                                                        OrderItem _delivery =
                                                            OrderItem(
                                                                productId: value
                                                                    .first.id,
                                                                quantity: 1,
                                                                price: value
                                                                    .first
                                                                    .price,
                                                                orderId:
                                                                    _data.id);
                                                        if (hasDelivery)
                                                          Provider.of<ClientEnvironment>(
                                                                  context,
                                                                  listen: false)
                                                              .currentOrder!
                                                              .orderItems!
                                                              .add(_delivery);
                                                        else
                                                          Provider.of<ClientEnvironment>(
                                                                  context,
                                                                  listen: false)
                                                              .currentOrder!
                                                              .orderItems!
                                                              .removeWhere((element) =>
                                                                  element
                                                                      .productId ==
                                                                  _delivery
                                                                      .productId);
                                                      }
                                                    });
                                                  });
                                                }),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.65,
                                              child: TextFormField(
                                                onChanged: (value) {
                                                  Provider.of<ClientEnvironment>(
                                                          context,
                                                          listen: false)
                                                      .currentOrder!
                                                      .notes = value;
                                                },
                                                decoration: InputDecoration(
                                                    labelText:
                                                        translation.notes),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 4),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          //   width: 4.0,
                                          color: Colors.redAccent),
                                    ),
                                    //color: Colors.white,
                                  ),
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    translation.items,
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                  ),
                                ),
                                ClientOrderItemsConfirmation(order: this._data),
                                ClientOrderItemsTotal(order: this._data),
                                ElevatedButton(
                                    onPressed: () {
                                      try {
                                        // First validate form.
                                        if (_formKey.currentState!.validate()) {
                                          _formKey.currentState?.save();
                                          //DjangoServices().upsertOrder(_data)?.then((value) {
                                          Repository()
                                              .upsertOrderV2(Provider.of<
                                                          ClientEnvironment>(
                                                      context,
                                                      listen: false)
                                                  .currentOrder!)
                                              ?.then((value) {
                                            _data.id == value;
                                            Provider.of<ClientEnvironment>(
                                                    context,
                                                    listen: false)
                                                .resetCurrentOrder();
                                          });
                                          Navigator.pop(context);
                                          // Save our form now.
                                        }
                                      } catch (e) {
                                        print(e);
                                        Scaffold.of(context).showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    "התרחשה תקלה בשמירת  ההזמנה החדשה.")));
                                      }
                                    },
                                    child: Text(translation.confirm))
                              ],
                            ),
                            isActive: _currentStep >= 0,
                            state: _currentStep >= 2
                                ? StepState.complete
                                : StepState.disabled,
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  switchStepsType() {
    setState(() => stepperType == StepperType.vertical
        ? stepperType = StepperType.horizontal
        : stepperType = StepperType.vertical);
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    if (_currentStep == 0) {
      _data.id = 0;
    }
    _currentStep < 2 ? setState(() => _currentStep += 1) : null;
  }

  back() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  cancel() {
    NavigationController().changeScreen('/');
  }
}
