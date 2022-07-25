import 'package:flutter/material.dart';

import 'package:hardwarestore/components/client/add_order_items_client.dart';
import 'package:hardwarestore/components/user.dart';
import 'package:hardwarestore/models/orders.dart';
import 'package:hardwarestore/services/api.dart';
import 'package:hardwarestore/services/tools.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../models/account.dart';

class NewOrderStepper extends StatefulWidget {
  bool newRecord = false;
  NewOrderStepper({Key? key}) : super(key: key);

  @override
  State<NewOrderStepper> createState() => _NewOrderStepperState();
}

class _NewOrderStepperState extends State<NewOrderStepper> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  int _currentStep = 0;
  StepperType stepperType = StepperType.horizontal;
  Order _data = Order();
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
    _data.contactId =
        Provider.of<GetCurrentUser>(context).currentUser!.contactId;
    return Form(
      key: _formKey,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            !widget.newRecord
                ? Padding(
                    padding: const EdgeInsets.only(top: 100.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          widget.newRecord = true;
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
                              primary: Colors.blue, secondary: Colors.green)),
                      child: Stepper(
                        controlsBuilder: (context, _) {
                          return Row(
                            children: <Widget>[
                              TextButton(
                                onPressed: () {},
                                child: Text(translation!.cancel),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text('EXIT'),
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
                                                color: Colors.lightBlue,
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
                                TextFormField(
                                  onChanged: (value) {
                                    Provider.of<ClientEnvironment>(context,
                                            listen: false)
                                        .currentOrder!
                                        .notes = value;
                                  },
                                  decoration: InputDecoration(
                                      labelText: translation.notes),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      translation.delivery,
                                    ),
                                    Checkbox(
                                        value: false, onChanged: (value) {}),
                                  ],
                                ),
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
                                                .currentOrder!
                                                .id = value;
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

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }
}
