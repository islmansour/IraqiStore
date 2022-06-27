import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hardwarestore/components/user.dart';
import 'package:hardwarestore/models/legal_document.dart';
import 'package:hardwarestore/services/api.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

enum GuaranteeType { from, to }

class guaranteePerson {
  String? name;
  String? ssn;
  String? street;
  String? town;
  String? zip;
  String? phone;
  GuaranteeType? type;
  guaranteePerson(
      {this.name = "",
      this.phone = "",
      this.ssn = "",
      this.street = "",
      this.town = "",
      this.zip = "",
      this.type});

  bool inValid() {
    if (name == "" || ssn == "")
      return true;
    else
      return false;
  }
}

class FormGuaranteegreement extends StatefulWidget {
  final LegalDocument? document;

  const FormGuaranteegreement({Key? key, required this.document})
      : super(key: key);
  @override
  _FormGuaranteegreementState createState() => _FormGuaranteegreementState();
}

class _FormGuaranteegreementState extends State<FormGuaranteegreement> {
  int _currentStep = 0;
  bool save = false;
  bool sigRequired = true;
  File? file;
  String? userPhone;
  guaranteePerson? _person1;
  guaranteePerson? _person2;
  guaranteePerson? _person3;
  guaranteePerson? _person4;
  guaranteePerson? _person5;
  guaranteePerson? _person6;

  String? from;

  StepperType stepperType = StepperType.vertical;

  final SignatureController _controller1 = SignatureController(
    // penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
    exportPenColor: Colors.black,
  );
  final SignatureController _controller2 = SignatureController(
    // penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
    exportPenColor: Colors.black,
  );

  @override
  void initState() {
    super.initState();
    _controller1.addListener(() {});
    _controller2.addListener(() {});
    _person1 = guaranteePerson();
    _person2 = guaranteePerson();
    _person3 = guaranteePerson();
    _person4 = guaranteePerson();
    _person5 = guaranteePerson();
    _person6 = guaranteePerson();
    // _controller3.addListener(() {});

    // _controller4.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    userPhone = Provider.of<GetCurrentUser>(context).currentUser?.uid ?? "";
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('כתב ערבות'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Stepper(
              type: stepperType,
              physics: const ScrollPhysics(),
              currentStep: _currentStep,
              onStepTapped: (step) => tapped(step),
              onStepContinue: save ? saveData : continued,
              onStepCancel: cancel,
              controlsBuilder: (BuildContext ctx, ControlsDetails dtl) {
                return Row(
                  children: <Widget>[
                    TextButton(
                      onPressed: dtl.onStepCancel,
                      child: Text(save == true ? 'ביטול' : 'ביטול'),
                    ),
                    TextButton(
                      onPressed: dtl.onStepContinue,
                      style: TextButton.styleFrom(
                        backgroundColor:
                            notfilledAllData() ? Colors.grey : Colors.blue,
                      ),
                      child: Text(
                        save == true ? 'שמור' : 'המשך',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                );
              },
              steps: <Step>[
                Step(
                  title: const Text(
                    'ערב 1',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ExpansionTile(
                          title: const Text('אנו הח״מ: (1)'),
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'שם',
                                  helperText: 'חובה',
                                  helperStyle: TextStyle(
                                      color: Colors.red, fontSize: 10)),
                              onChanged: (value) {
                                setState(() {
                                  _person1!.type = GuaranteeType.from;

                                  _person1?.name = value;
                                });
                              },
                            ),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ], // Only numbers can be entered

                              decoration: const InputDecoration(
                                  labelText: 'ת.ז.',
                                  helperText: 'חובה',
                                  helperStyle: TextStyle(
                                      color: Colors.red, fontSize: 10)),
                              onChanged: (value) {
                                setState(() {
                                  _person1?.ssn = value;
                                });
                              },
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'רח׳',
                                  helperText: 'חובה',
                                  helperStyle: TextStyle(
                                      color: Colors.red, fontSize: 10)),
                              onChanged: (value) {
                                setState(() {
                                  _person1?.street = value;
                                });
                              },
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'ישוב',
                                  helperText: 'חובה',
                                  helperStyle: TextStyle(
                                      color: Colors.red, fontSize: 10)),
                              onChanged: (value) {
                                setState(() {
                                  _person1?.town = value;
                                });
                              },
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'מיקוד',
                                  helperText: 'חובה',
                                  helperStyle: TextStyle(
                                      color: Colors.red, fontSize: 10)),
                              onChanged: (value) {
                                setState(() {
                                  _person1?.zip = value;
                                });
                              },
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'טל׳',
                                  helperText: 'חובה',
                                  helperStyle: TextStyle(
                                      color: Colors.red, fontSize: 10)),
                              onChanged: (value) {
                                setState(() {
                                  _person1?.phone = value;
                                  // people.add(_person1);
                                });
                              },
                            ),
                          ]),
                      ExpansionTile(
                          title: const Text('אנו הח״מ: (1)'),
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'שם',
                                  helperText: 'חובה',
                                  helperStyle: TextStyle(
                                      color: Colors.red, fontSize: 10)),
                              onChanged: (value) {
                                setState(() {
                                  _person2!.type = GuaranteeType.from;

                                  _person2?.name = value;
                                });
                              },
                            ),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ], // Only numbers can be entered

                              decoration: const InputDecoration(
                                  labelText: 'ת.ז.',
                                  helperText: 'חובה',
                                  helperStyle: TextStyle(
                                      color: Colors.red, fontSize: 10)),
                              onChanged: (value) {
                                setState(() {
                                  _person2?.ssn = value;
                                });
                              },
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'רח׳',
                                  helperText: 'חובה',
                                  helperStyle: TextStyle(
                                      color: Colors.red, fontSize: 10)),
                              onChanged: (value) {
                                setState(() {
                                  _person2?.street = value;
                                });
                              },
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'ישוב',
                                  helperText: 'חובה',
                                  helperStyle: TextStyle(
                                      color: Colors.red, fontSize: 10)),
                              onChanged: (value) {
                                setState(() {
                                  _person2?.town = value;
                                });
                              },
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'מיקוד',
                                  helperText: 'חובה',
                                  helperStyle: TextStyle(
                                      color: Colors.red, fontSize: 10)),
                              onChanged: (value) {
                                setState(() {
                                  _person2?.zip = value;
                                });
                              },
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'טל׳',
                                  helperText: 'חובה',
                                  helperStyle: TextStyle(
                                      color: Colors.red, fontSize: 10)),
                              onChanged: (value) {
                                setState(() {
                                  _person2?.phone = value;
                                  // people.add(_person2);
                                });
                              },
                            ),
                          ]),
                    ],
                  ),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 0
                      ? StepState.complete
                      : StepState.disabled,
                ),
                Step(
                  title: const Text(
                    'פרטי לקוח',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerRight,
                        child: Column(
                          children: [
                            const Text(
                                'כולנו ביחד וכל אחד מאיתנו לחוד ,ערבים בזה ל בלוק עיראקי בע"מ ח.פ. 511530610 (להלן – הספק הנ"ל). לפרעון מלא ומדויק של כל הכספים אשר יגיעו לו מאת: (2)'),
                            const SizedBox(
                              height: 30,
                            ),
                            ExpansionTile(
                                title: const Text('לקוח 1'),
                                children: [
                                  TextFormField(
                                    decoration: const InputDecoration(
                                        labelText: 'שם',
                                        helperText: 'חובה',
                                        helperStyle: TextStyle(
                                            color: Colors.red, fontSize: 10)),
                                    onChanged: (value) {
                                      setState(() {
                                        _person3!.type = GuaranteeType.to;

                                        _person3?.name = value;
                                      });
                                    },
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ], // Only numbers can be entered

                                    decoration: const InputDecoration(
                                        labelText: 'ת.ז.',
                                        helperText: 'חובה',
                                        helperStyle: TextStyle(
                                            color: Colors.red, fontSize: 10)),
                                    onChanged: (value) {
                                      setState(() {
                                        _person3?.ssn = value;
                                      });
                                    },
                                  ),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                        labelText: 'רח׳',
                                        helperText: 'חובה',
                                        helperStyle: TextStyle(
                                            color: Colors.red, fontSize: 10)),
                                    onChanged: (value) {
                                      setState(() {
                                        _person3?.street = value;
                                      });
                                    },
                                  ),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                        labelText: 'ישוב',
                                        helperText: 'חובה',
                                        helperStyle: TextStyle(
                                            color: Colors.red, fontSize: 10)),
                                    onChanged: (value) {
                                      setState(() {
                                        _person3?.town = value;
                                      });
                                    },
                                  ),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                        labelText: 'מיקוד',
                                        helperText: 'חובה',
                                        helperStyle: TextStyle(
                                            color: Colors.red, fontSize: 10)),
                                    onChanged: (value) {
                                      setState(() {
                                        _person3?.zip = value;
                                      });
                                    },
                                  ),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                        labelText: 'טל׳',
                                        helperText: 'חובה',
                                        helperStyle: TextStyle(
                                            color: Colors.red, fontSize: 10)),
                                    onChanged: (value) {
                                      setState(() {
                                        _person3?.phone = value;
                                        //  people.add(_person);
                                      });
                                    },
                                  ),
                                ]),
                            ExpansionTile(
                                title: const Text('לקוח 2'),
                                children: [
                                  TextFormField(
                                    decoration: const InputDecoration(
                                        labelText: 'שם',
                                        helperText: 'חובה',
                                        helperStyle: TextStyle(
                                            color: Colors.red, fontSize: 10)),
                                    onChanged: (value) {
                                      setState(() {
                                        _person4!.type = GuaranteeType.to;

                                        _person4?.name = value;
                                      });
                                    },
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ], // Only numbers can be entered

                                    decoration: const InputDecoration(
                                        labelText: 'ת.ז.',
                                        helperText: 'חובה',
                                        helperStyle: TextStyle(
                                            color: Colors.red, fontSize: 10)),
                                    onChanged: (value) {
                                      setState(() {
                                        _person4?.ssn = value;
                                      });
                                    },
                                  ),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                        labelText: 'רח׳',
                                        helperText: 'חובה',
                                        helperStyle: TextStyle(
                                            color: Colors.red, fontSize: 10)),
                                    onChanged: (value) {
                                      setState(() {
                                        _person4?.street = value;
                                      });
                                    },
                                  ),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                        labelText: 'ישוב',
                                        helperText: 'חובה',
                                        helperStyle: TextStyle(
                                            color: Colors.red, fontSize: 10)),
                                    onChanged: (value) {
                                      setState(() {
                                        _person4?.town = value;
                                      });
                                    },
                                  ),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                        labelText: 'מיקוד',
                                        helperText: 'חובה',
                                        helperStyle: TextStyle(
                                            color: Colors.red, fontSize: 10)),
                                    onChanged: (value) {
                                      setState(() {
                                        _person4?.zip = value;
                                      });
                                    },
                                  ),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                        labelText: 'טל׳',
                                        helperText: 'חובה',
                                        helperStyle: TextStyle(
                                            color: Colors.red, fontSize: 10)),
                                    onChanged: (value) {
                                      setState(() {
                                        _person4?.phone = value;
                                        // people.add(_person4);
                                      });
                                    },
                                  ),
                                ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 1
                      ? StepState.complete
                      : StepState.disabled,
                ),
                Step(
                  title: const Text(
                    'המשף...',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: Column(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: const Text(
                              '1 . אנו מתחייבים לשלם מיד עם דרישתן הראשונה של הספק הנ"ל כל סכום שידרשו מאיתנו , על חשבון המגיע לו מאת',
                              maxLines: 6,
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 8),
                            ),
                          ),

                          Text(_person1!.name! + ' ' + _person2!.name!),

                          //,(להלן – החייב/ים) בצירוף הפרשי הצמדה, וריבית, הוצאות ושכ"ט עו"ד (להלן – "סכום הערבות").
                        ],
                      ),
                      const Text(
                        '(להלן – החייב/ים) בצירוף הפרשי הצמדה, וריבית, הוצאות ושכ"ט עו"ד (להלן – "סכום הערבות").',
                        maxLines: 6,
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 8),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: const Text(
                              'אנו מתחייבים לשלם לספק הנ"ל את סכום הערבות מבלי שהוא יצטרך להוכיח לנו שהחייב/ים הפרו את התחייבויותיהם כלפיו ומבלי שינקטו תחילה בכל צעדים שהם לגבייתו של החוב מאת החייב/ים. ',
                              maxLines: 6,
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 8),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: const Text(
                              'התחייבותנו זו לתשלום סכום הערבות תעמוד בתקופה ,לא תושפע ולא תפגע גם אם כתוצאה מהסדר נושים - ,או כתוצאה מפשיטת רגל, פירוק חברה, כינוס נכסים או כל העדר יכולת של החייב/ים, יוחלט ע"י בימ"ש מוסמך להפטיר את הערבים או למחול על ערבותם  עפ"י כתב ערבות זה.',
                              maxLines: 6,
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 8),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: const Text(
                              '4 .אנו מוותרים בזה על זכותנו לטעון כל הגנה שהן, ומתחייבים לשפות את הספק , על כל נזק ,הפסד והוצאות שייגרמו לו עקב הסדר תשלומים עם החייב/ים.',
                              maxLines: 6,
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 8),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: const Text(
                              'אנו מסכימים כי הרישומים בספרי הספק הינם הרישומים המחייבים וזאת לרבות רישומי כרטסת הנהלת החשבונות שלו . אנו מסכימים כי אין הספק חייב לשמור על תעודות המשלוח לתקופה העולה על 6 חודשים .',
                              maxLines: 6,
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 8),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: const Text(
                              ' .ערבותנו זו תשמש בטוחה מתמדת וחוזרת ותישאר בתוקפה למרות כל הסדר תשלומים שייעשה עם החייב/ים ותחייב אותנו ואת חליפינו חוקיים, עד לסילוק המלא והסופי של סכום הערבות לספק הנ"ל .',
                              maxLines: 6,
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 8),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: const Text(
                              '7 .ערבות זו ניתנת על – ידינו ביחד ולחוד לספק הנ"ל,',
                              maxLines: 6,
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 8),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: const Text(
                              '8. בשום מקרה איש מאתנו לא מהווה "ערב יחיד" או "ערב מוגן" כמשמעו בחוק הערבות, התשכ"ז - 1967, ואהיה מנוע מלטעון אחרת.',
                              maxLines: 6,
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 8),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: const Text(
                              'אנו מוותרים על כל הגנה על פי חוק הערבות, תשכ"ז - 1967, ככל שניתן להתנות על האמור בו.',
                              maxLines: 6,
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 8),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: const Text(
                              '9 .מקום השיפוט לצורך כתב ערבות זה הינו ביהמ"ש המוסמך בכפר – סבא ו/או בנתניה .',
                              maxLines: 6,
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 2
                      ? StepState.complete
                      : StepState.disabled,
                ),
                Step(
                  title: const Text(
                    'ולראיה באנו על החתום:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: Column(
                    children: [
                      ExpansionTile(
                        title: const Text('חתימת ערב 1'),
                        children: [
                          Text(
                            'אני מאשר כי ביום $formattedDate הופיע בפני הערב הנ"ל ולאחר שזיהיתי אותו על-פי ת.ז. מספר',
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'חתם בפני',
                                helperText: 'חובה',
                                helperStyle:
                                    TextStyle(color: Colors.red, fontSize: 10)),
                            onChanged: (value) {
                              setState(() {
                                _person5?.name = value;
                              });
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'שם ומשפחה',
                                helperText: 'חובה',
                                helperStyle:
                                    TextStyle(color: Colors.red, fontSize: 10)),
                            onChanged: (value) {
                              setState(() {
                                _person5?.ssn = value;
                              });
                            },
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            height: 210,
                            width: 310,
                            // child: SignaturePage()
                            child: Signature(controller: _controller1),
                          ),
                          if (sigRequired)
                            const Text(
                              'יש לחתום על ההסכם...',
                              style: TextStyle(color: Colors.red),
                            ),
                        ],
                      ),
                      ExpansionTile(
                        title: const Text('חתימת ערב 2'),
                        children: [
                          Text(
                            'אני מאשר כי ביום $formattedDate הופיע בפני הערב הנ"ל ולאחר שזיהיתי אותו על-פי ת.ז. מספר',
                          ),
                          TextFormField(
                            // Only numbers can be entered

                            decoration: const InputDecoration(
                                labelText: 'חתם בפני',
                                helperText: 'חובה',
                                helperStyle:
                                    TextStyle(color: Colors.red, fontSize: 10)),
                            onChanged: (value) {
                              setState(() {
                                _person6?.name = value;
                              });
                            },
                          ),
                          TextFormField(
                            // Only numbers can be entered

                            decoration: const InputDecoration(
                                labelText: 'שם ומשפחה',
                                helperText: 'חובה',
                                helperStyle:
                                    TextStyle(color: Colors.red, fontSize: 10)),
                            onChanged: (value) {
                              setState(() {
                                _person6?.ssn = value;
                              });
                            },
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            height: 210,
                            width: 310,
                            // child: SignaturePage()
                            child: Signature(controller: _controller2),
                          ),
                          if (sigRequired)
                            const Text(
                              'יש לחתום על ההסכם...',
                              style: TextStyle(color: Colors.red),
                            ),
                        ],
                      ),
                      // ExpansionTile(
                      //   title: Text('תימת ערב 2'),
                      //   children: [
                      //     TextFormField(
                      //       keyboardType: TextInputType.number,
                      //       inputFormatters: <TextInputFormatter>[
                      //         FilteringTextInputFormatter.digitsOnly
                      //       ], // Only numbers can be entered

                      //       decoration: const InputDecoration(
                      //           labelText:
                      //               'אני מאשר כי ביום זה הופיע בפני הערב הנ"ל ולאחר שזיהיתי אותו על-פי ת.ז. מספר',
                      //           helperText: 'חובה',
                      //           helperStyle:
                      //               TextStyle(color: Colors.red, fontSize: 10)),
                      //       onChanged: (value) {
                      //         setState(() {
                      //           //  _person?.ssn = value;
                      //         });
                      //       },
                      //     ),
                      //     TextFormField(
                      //       keyboardType: TextInputType.number,
                      //       inputFormatters: <TextInputFormatter>[
                      //         FilteringTextInputFormatter.digitsOnly
                      //       ], // Only numbers can be entered

                      //       decoration: const InputDecoration(
                      //           labelText: 'חתם בפני',
                      //           helperText: 'חובה',
                      //           helperStyle:
                      //               TextStyle(color: Colors.red, fontSize: 10)),
                      //       onChanged: (value) {
                      //         setState(() {
                      //           //  _person?.ssn = value;
                      //         });
                      //       },
                      //     ),
                      //     TextFormField(
                      //       keyboardType: TextInputType.number,
                      //       inputFormatters: <TextInputFormatter>[
                      //         FilteringTextInputFormatter.digitsOnly
                      //       ], // Only numbers can be entered

                      //       decoration: const InputDecoration(
                      //           labelText: 'שם ומשפחה',
                      //           helperText: 'חובה',
                      //           helperStyle:
                      //               TextStyle(color: Colors.red, fontSize: 10)),
                      //       onChanged: (value) {
                      //         setState(() {
                      //           //  _person?.ssn = value;
                      //         });
                      //       },
                      //     ),
                      //     Container(
                      //       alignment: Alignment.centerLeft,
                      //       height: 210,
                      //       width: 310,
                      //       // child: SignaturePage()
                      //       child: Signature(controller: _controller3),
                      //     ),
                      //     if (sigRequired)
                      //       const Text(
                      //         'יש לחתום על ההסכם...',
                      //         style: TextStyle(color: Colors.red),
                      //       ),
                      //   ],
                      // ),
                      // ExpansionTile(
                      //   title: Text('חתימת ערב 1'),
                      //   children: [
                      //     TextFormField(
                      //       keyboardType: TextInputType.number,
                      //       inputFormatters: <TextInputFormatter>[
                      //         FilteringTextInputFormatter.digitsOnly
                      //       ], // Only numbers can be entered

                      //       decoration: const InputDecoration(
                      //           labelText:
                      //               'אני מאשר כי ביום זה הופיע בפני הערב הנ"ל ולאחר שזיהיתי אותו על-פי ת.ז. מספר',
                      //           helperText: 'חובה',
                      //           helperStyle:
                      //               TextStyle(color: Colors.red, fontSize: 10)),
                      //       onChanged: (value) {
                      //         setState(() {
                      //           //  _person?.ssn = value;
                      //         });
                      //       },
                      //     ),
                      //     TextFormField(
                      //       keyboardType: TextInputType.number,
                      //       inputFormatters: <TextInputFormatter>[
                      //         FilteringTextInputFormatter.digitsOnly
                      //       ], // Only numbers can be entered

                      //       decoration: const InputDecoration(
                      //           labelText: 'חתם בפני',
                      //           helperText: 'חובה',
                      //           helperStyle:
                      //               TextStyle(color: Colors.red, fontSize: 10)),
                      //       onChanged: (value) {
                      //         setState(() {
                      //           //  _person?.ssn = value;
                      //         });
                      //       },
                      //     ),
                      //     TextFormField(
                      //       keyboardType: TextInputType.number,
                      //       inputFormatters: <TextInputFormatter>[
                      //         FilteringTextInputFormatter.digitsOnly
                      //       ], // Only numbers can be entered

                      //       decoration: const InputDecoration(
                      //           labelText: 'שם ומשפחה',
                      //           helperText: 'חובה',
                      //           helperStyle:
                      //               TextStyle(color: Colors.red, fontSize: 10)),
                      //       onChanged: (value) {
                      //         setState(() {
                      //           //  _person?.ssn = value;
                      //         });
                      //       },
                      //     ),
                      //     Container(
                      //       alignment: Alignment.centerLeft,
                      //       height: 210,
                      //       width: 310,
                      //       // child: SignaturePage()
                      //       child: Signature(controller: _controller4),
                      //     ),
                      //     if (sigRequired)
                      //       const Text(
                      //         'יש לחתום על ההסכם...',
                      //         style: TextStyle(color: Colors.red),
                      //       ),
                      //   ],
                      // ),
                    ],
                  ),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 3
                      ? StepState.complete
                      : StepState.disabled,
                ),
              ],
            ),
          ),
        ],
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
    if (_currentStep == 0 && (_person1!.inValid() && _person2!.inValid()))
      return null;
    if (_currentStep == 1 && (_person4!.inValid() && _person3!.inValid()))
      return null;
    // if (notfilledAllData()) return null;
    if (_currentStep == 2) save = true;
    _currentStep < 3 ? setState(() => _currentStep += 1) : null;
  }

  bool notfilledAllData() {
    if (_currentStep == 0 && (_person1!.inValid() && _person2!.inValid()))
      return true;
    if (_currentStep == 1 && (_person4!.inValid() && _person3!.inValid()))
      return true;
    return false;
  }

  saveData() async {
    if (file != null) return;
    final font = await rootBundle.load("assets/fonts/Arimo-Regular.ttf");
    final ttf = pw.Font.ttf(font);
    final fontBold = await rootBundle.load("assets/fonts/Arimo-SemiBold.ttf");
    final ttfBold = pw.Font.ttf(fontBold);
    final fontExtraBold = await rootBundle.load("assets/fonts/Arimo-Bold.ttf");
    final ttfExtraBold = pw.Font.ttf(fontExtraBold);

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy/MM/dd').format(now);
    final pdf = pw.Document();

    Uint8List? data1;
    Uint8List? data2;
    // Uint8List? data3;
    // Uint8List? data4;

    if (_controller1.isNotEmpty) {
      data1 = await _controller1.toPngBytes();
      if (data1 != null) {
        pw.MemoryImage(data1);

        setState(() {
          sigRequired = false;
        });
      }
    } else {
      if (_person1?.name == null || _person1!.name == "") {
        setState(() {
          sigRequired = false;
        });
      } else if (save) return null;
    }
    if (_controller2.isNotEmpty) {
      data2 = await _controller2.toPngBytes();
      if (data2 != null) {
        pw.MemoryImage(data2);

        setState(() {
          sigRequired = false;
        });
      }
    } else {
      if (_person2?.name == null || _person2!.name == "") {
        setState(() {
          sigRequired = false;
        });
      } else if (save) return null;
    }
    pdf.addPage(
      pw.Page(
        theme: pw.ThemeData.withFont(
          base: ttf,
        ),
        build: (pw.Context context) => pw.Center(
            child: pw.Column(children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: <pw.Widget>[
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
                pw.Container(
                  child: pw.Text('כתב ערבות'.split('').reversed.join(),
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                        font: ttfExtraBold,
                      ),
                      textDirection: pw.TextDirection.rtl),
                ),
              ]),
              pw.SizedBox(height: 10),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
                pw.Container(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Text(ReverseString('אנו הח"מ: (1)'),
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                        font: ttf,
                      ),
                      textDirection: pw.TextDirection.rtl),
                ),
              ]),
              // pw.Row(
              //   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              //   children: [
              //     pw.Column(
              //       children: [
              //         pw.Container(
              //           alignment: pw.Alignment.centerRight,
              //           child: pw.Text(ReverseString('לשימוש משרדי'),
              //               style: pw.TextStyle(
              //                 fontWeight: pw.FontWeight.bold,
              //                 font: ttfBold,
              //               ),
              //               textDirection: pw.TextDirection.rtl),
              //         ),
              //         pw.Container(
              //           alignment: pw.Alignment.centerRight,
              //           child: pw.Text(ReverseString(' מס׳ לקוח _________'),
              //               style: pw.TextStyle(
              //                 fontWeight: pw.FontWeight.bold,
              //                 font: ttfBold,
              //               ),
              //               textDirection: pw.TextDirection.rtl),
              //         ),
              //       ],
              //     ),
              //     pw.Container(
              //       alignment: pw.Alignment.centerRight,
              //       child: pw.Text(ReverseString('אנו הח"מ : (1)'),
              //           style: pw.TextStyle(
              //             fontWeight: pw.FontWeight.bold,
              //             font: ttfBold,
              //           ),
              //           textDirection: pw.TextDirection.rtl),
              //     ),
              //   ],
              // ),
              pw.SizedBox(height: 10),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children: [
                      pw.Container(
                          width: 80,
                          alignment: pw.Alignment.centerRight,
                          decoration: const pw.BoxDecoration(
                              border: pw.Border(
                            bottom: pw.BorderSide(
                                width: 1.0, color: PdfColors.black),
                          )),
                          child: pw.Text(
                            //ssn!.split('').reversed.join(),
                            ReverseString(_person1!.ssn.toString()),
                            style: pw.TextStyle(
                              fontSize: 10,
                              font: ttf,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          )),
                      pw.Text(
                        'ת.ז.:  '.split('').reversed.join(),
                        style: pw.TextStyle(
                          font: ttf,
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(
                        width: 10,
                      ),
                      pw.Container(
                        alignment: pw.Alignment.centerRight,
                        width: 80,
                        decoration: const pw.BoxDecoration(
                            border: pw.Border(
                          bottom:
                              pw.BorderSide(width: 1.0, color: PdfColors.black),
                        )),
                        child: pw.Text(
                          // name!.split('').reversed.join(),
                          ReverseString(_person1!.name.toString()),
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          textDirection: pw.TextDirection.rtl,
                        ),
                      ),
                      pw.Text(
                        'שם:  '.split('').reversed.join(),
                        style: pw.TextStyle(
                          font: ttf,
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Padding(
                          padding: const pw.EdgeInsets.only(right: 10),
                          child: pw.Text(
                            '1.'.split('').reversed.join(),
                            style: pw.TextStyle(
                              font: ttf,
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          )),
                    ],
                  ),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            pw.Container(
                                width: 80,
                                alignment: pw.Alignment.centerRight,
                                decoration: const pw.BoxDecoration(
                                    border: pw.Border(
                                  bottom: pw.BorderSide(
                                      width: 1.0, color: PdfColors.black),
                                )),
                                child: pw.Text(
                                  //  phone!.split('').reversed.join(),
                                  ReverseString(_person1!.phone!),
                                  style: pw.TextStyle(
                                    font: ttf,
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                )),
                            pw.Text('טל:  '.split('').reversed.join(),
                                style: pw.TextStyle(
                                  font: ttf,
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                                textDirection: pw.TextDirection.rtl),
                          ],
                        ),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            pw.Container(
                                width: 80,
                                alignment: pw.Alignment.centerRight,
                                decoration: const pw.BoxDecoration(
                                    border: pw.Border(
                                  bottom: pw.BorderSide(
                                      width: 1.0, color: PdfColors.black),
                                )),
                                child: pw.Text(
                                  //  phone!.split('').reversed.join(),
                                  ReverseString(_person1!.zip!),
                                  style: pw.TextStyle(
                                    font: ttf,
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                )),
                            pw.Text('מיקוד:  '.split('').reversed.join(),
                                style: pw.TextStyle(
                                  font: ttf,
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                                textDirection: pw.TextDirection.rtl),
                          ],
                        ),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            pw.Container(
                                width: 80,
                                alignment: pw.Alignment.centerRight,
                                decoration: const pw.BoxDecoration(
                                    border: pw.Border(
                                  bottom: pw.BorderSide(
                                      width: 1.0, color: PdfColors.black),
                                )),
                                child: pw.Text(
                                  //    town!.split('').reversed.join(),
                                  ReverseString(_person1!.town!),
                                  style: pw.TextStyle(
                                    font: ttf,
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                )),
                            pw.Text(
                              'ישוב: '.split('').reversed.join(),
                              style: pw.TextStyle(
                                font: ttf,
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            pw.Container(
                              alignment: pw.Alignment.centerRight,
                              width: 80,
                              decoration: const pw.BoxDecoration(
                                  border: pw.Border(
                                bottom: pw.BorderSide(
                                    width: 1.0, color: PdfColors.black),
                              )),
                              child: pw.Text(
                                // street!.split('').reversed.join(),
                                ReverseString(_person1!.street!),
                                style: pw.TextStyle(
                                  font: ttf,
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                            pw.Text('רח:  '.split('').reversed.join(),
                                style: pw.TextStyle(
                                  font: ttf,
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                                textDirection: pw.TextDirection.rtl),
                            pw.SizedBox(
                              width: 10,
                            )
                          ],
                        ),
                      ]),
                ],
              ),
              pw.Column(
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children: [
                      pw.Container(
                          width: 80,
                          alignment: pw.Alignment.centerRight,
                          decoration: const pw.BoxDecoration(
                              border: pw.Border(
                            bottom: pw.BorderSide(
                                width: 1.0, color: PdfColors.black),
                          )),
                          child: pw.Text(
                            //ssn!.split('').reversed.join(),
                            ReverseString(_person2!.ssn.toString()),
                            style: pw.TextStyle(
                              font: ttf,
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          )),
                      pw.Text(
                        'ת.ז.:  '.split('').reversed.join(),
                        style: pw.TextStyle(
                          font: ttf,
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(
                        width: 10,
                      ),
                      pw.Container(
                        width: 80,
                        alignment: pw.Alignment.centerRight,
                        decoration: const pw.BoxDecoration(
                            border: pw.Border(
                          bottom:
                              pw.BorderSide(width: 1.0, color: PdfColors.black),
                        )),
                        child: pw.Text(
                          // name!.split('').reversed.join(),
                          ReverseString(_person2!.name.toString()),
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          textDirection: pw.TextDirection.rtl,
                        ),
                      ),
                      pw.Text(
                        'שם:  '.split('').reversed.join(),
                        style: pw.TextStyle(
                          font: ttf,
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Padding(
                          padding: const pw.EdgeInsets.only(right: 10),
                          child: pw.Text(
                            '2.'.split('').reversed.join(),
                            style: pw.TextStyle(
                              font: ttf,
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          )),
                    ],
                  ),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            pw.Container(
                                width: 80,
                                alignment: pw.Alignment.centerRight,
                                decoration: const pw.BoxDecoration(
                                    border: pw.Border(
                                  bottom: pw.BorderSide(
                                      width: 1.0, color: PdfColors.black),
                                )),
                                child: pw.Text(
                                  //  phone!.split('').reversed.join(),
                                  ReverseString(_person2!.phone!),
                                  style: pw.TextStyle(
                                    font: ttf,
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                )),
                            pw.Text('טל: '.split('').reversed.join(),
                                style: pw.TextStyle(
                                  font: ttf,
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                                textDirection: pw.TextDirection.rtl),
                            pw.SizedBox(
                              width: 10,
                            )
                          ],
                        ),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            pw.Container(
                                width: 80,
                                alignment: pw.Alignment.centerRight,
                                decoration: const pw.BoxDecoration(
                                    border: pw.Border(
                                  bottom: pw.BorderSide(
                                      width: 1.0, color: PdfColors.black),
                                )),
                                child: pw.Text(
                                  //  phone!.split('').reversed.join(),
                                  ReverseString(_person2!.zip!),
                                  style: pw.TextStyle(
                                    font: ttf,
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                )),
                            pw.Text('מיקוד:  '.split('').reversed.join(),
                                style: pw.TextStyle(
                                  font: ttf,
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                                textDirection: pw.TextDirection.rtl),
                          ],
                        ),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            pw.Container(
                                width: 80,
                                alignment: pw.Alignment.centerRight,
                                decoration: const pw.BoxDecoration(
                                    border: pw.Border(
                                  bottom: pw.BorderSide(
                                      width: 1.0, color: PdfColors.black),
                                )),
                                child: pw.Text(
                                  //    town!.split('').reversed.join(),
                                  ReverseString(_person2!.town!),
                                  style: pw.TextStyle(
                                    font: ttf,
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                )),
                            pw.Text(
                              'ישוב: '.split('').reversed.join(),
                              style: pw.TextStyle(
                                font: ttf,
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            pw.Container(
                                width: 80,
                                alignment: pw.Alignment.centerRight,
                                decoration: const pw.BoxDecoration(
                                    border: pw.Border(
                                  bottom: pw.BorderSide(
                                      width: 1.0, color: PdfColors.black),
                                )),
                                child: pw.Text(
                                  // street!.split('').reversed.join(),
                                  ReverseString(_person2!.street!),
                                  style: pw.TextStyle(
                                    font: ttf,
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                )),
                            pw.Text('רח:  '.split('').reversed.join(),
                                style: pw.TextStyle(
                                  font: ttf,
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                                textDirection: pw.TextDirection.rtl),
                          ],
                        ),
                      ]),
                ],
              ),

              pw.SizedBox(
                height: 30,
              ),
              pw.Text(
                  ReverseString(
                      'כולנו ביחד וכל אחד מאיתנו לחוד ,ערבים בזה ל בלוק עיראקי בע"מ ח.פ. 511530610 (להלן – הספק הנ"ל). לפרעון מלא ומדויק של כל הכספים אשר יגיעו לו מאת: (2)'),
                  style: pw.TextStyle(
                      font: ttfBold, fontWeight: pw.FontWeight.bold),
                  textDirection: pw.TextDirection.rtl),
              pw.SizedBox(
                height: 30,
              ),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Row(children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Container(
                            width: 80,
                            alignment: pw.Alignment.centerRight,
                            decoration: const pw.BoxDecoration(
                                border: pw.Border(
                              bottom: pw.BorderSide(
                                  width: 1.0, color: PdfColors.black),
                            )),
                            child: pw.Text(
                              //ssn!.split('').reversed.join(),
                              ReverseString(_person3!.ssn.toString()),
                              style: pw.TextStyle(
                                font: ttf,
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                          pw.Text(
                            'ת.ז.:  '.split('').reversed.join(),
                            style: pw.TextStyle(
                              font: ttf,
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.SizedBox(
                            width: 10,
                          ),
                          pw.Container(
                            width: 80,
                            alignment: pw.Alignment.centerRight,
                            decoration: const pw.BoxDecoration(
                                border: pw.Border(
                              bottom: pw.BorderSide(
                                  width: 1.0, color: PdfColors.black),
                            )),
                            child: pw.Text(
                              // name!.split('').reversed.join(),
                              ReverseString(_person3!.name.toString()),
                              style: pw.TextStyle(
                                font: ttf,
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                              ),
                              textDirection: pw.TextDirection.rtl,
                            ),
                          ),
                          pw.Text(
                            'שם:  '.split('').reversed.join(),
                            style: pw.TextStyle(
                              font: ttf,
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ]),
                    pw.Row(children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Container(
                              width: 80,
                              alignment: pw.Alignment.centerRight,
                              decoration: const pw.BoxDecoration(
                                  border: pw.Border(
                                bottom: pw.BorderSide(
                                    width: 1.0, color: PdfColors.black),
                              )),
                              child: pw.Text(
                                //  phone!.split('').reversed.join(),
                                ReverseString(_person3!.phone!),
                                style: pw.TextStyle(
                                  font: ttf,
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              )),
                          pw.Text('טל:  '.split('').reversed.join(),
                              style: pw.TextStyle(
                                font: ttf,
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                              ),
                              textDirection: pw.TextDirection.rtl),
                        ],
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Container(
                              width: 80,
                              alignment: pw.Alignment.centerRight,
                              decoration: const pw.BoxDecoration(
                                  border: pw.Border(
                                bottom: pw.BorderSide(
                                    width: 1.0, color: PdfColors.black),
                              )),
                              child: pw.Text(
                                //    town!.split('').reversed.join(),
                                ReverseString(_person3!.zip!),
                                style: pw.TextStyle(
                                  font: ttf,
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              )),
                          pw.Text(
                            'מיקוד: '.split('').reversed.join(),
                            style: pw.TextStyle(
                              font: ttf,
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Container(
                              width: 80,
                              alignment: pw.Alignment.centerRight,
                              decoration: const pw.BoxDecoration(
                                  border: pw.Border(
                                bottom: pw.BorderSide(
                                    width: 1.0, color: PdfColors.black),
                              )),
                              child: pw.Text(
                                //    town!.split('').reversed.join(),
                                ReverseString(_person3!.town!),
                                style: pw.TextStyle(
                                  font: ttf,
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              )),
                          pw.Text(
                            'ישוב: '.split('').reversed.join(),
                            style: pw.TextStyle(
                              font: ttf,
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Container(
                              width: 80,
                              alignment: pw.Alignment.centerRight,
                              decoration: const pw.BoxDecoration(
                                  border: pw.Border(
                                bottom: pw.BorderSide(
                                    width: 1.0, color: PdfColors.black),
                              )),
                              child: pw.Text(
                                // street!.split('').reversed.join(),
                                ReverseString(_person3!.street!),
                                style: pw.TextStyle(
                                  font: ttf,
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              )),
                          pw.Text('רח:  '.split('').reversed.join(),
                              style: pw.TextStyle(
                                font: ttf,
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                              ),
                              textDirection: pw.TextDirection.rtl),
                        ],
                      ),
                    ]),
                  ],
                ),
              ]),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            pw.Container(
                                width: 80,
                                alignment: pw.Alignment.centerRight,
                                decoration: const pw.BoxDecoration(
                                    border: pw.Border(
                                  bottom: pw.BorderSide(
                                      width: 1.0, color: PdfColors.black),
                                )),
                                child: pw.Text(
                                  //ssn!.split('').reversed.join(),
                                  ReverseString(_person4!.ssn.toString()),
                                  style: pw.TextStyle(
                                    font: ttf,
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                )),
                            pw.Text(
                              'ת.ז.:  '.split('').reversed.join(),
                              style: pw.TextStyle(
                                font: ttf,
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.SizedBox(
                              width: 10,
                            ),
                            pw.Container(
                              width: 80,
                              alignment: pw.Alignment.centerRight,
                              decoration: const pw.BoxDecoration(
                                  border: pw.Border(
                                bottom: pw.BorderSide(
                                    width: 1.0, color: PdfColors.black),
                              )),
                              child: pw.Text(
                                // name!.split('').reversed.join(),
                                ReverseString(_person4!.name.toString()),
                                style: pw.TextStyle(
                                  font: ttf,
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                                textDirection: pw.TextDirection.rtl,
                              ),
                            ),
                            pw.Text(
                              'שם:  '.split('').reversed.join(),
                              style: pw.TextStyle(
                                font: ttf,
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ]),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            pw.Container(
                                width: 80,
                                alignment: pw.Alignment.centerRight,
                                decoration: const pw.BoxDecoration(
                                    border: pw.Border(
                                  bottom: pw.BorderSide(
                                      width: 1.0, color: PdfColors.black),
                                )),
                                child: pw.Text(
                                  //  phone!.split('').reversed.join(),
                                  ReverseString(_person4!.phone!),
                                  style: pw.TextStyle(
                                    font: ttf,
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                )),
                            pw.Text('טל:  '.split('').reversed.join(),
                                style: pw.TextStyle(
                                  font: ttf,
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                                textDirection: pw.TextDirection.rtl),
                          ],
                        ),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            pw.Container(
                                width: 80,
                                alignment: pw.Alignment.centerRight,
                                decoration: const pw.BoxDecoration(
                                    border: pw.Border(
                                  bottom: pw.BorderSide(
                                      width: 1.0, color: PdfColors.black),
                                )),
                                child: pw.Text(
                                  //    town!.split('').reversed.join(),
                                  ReverseString(_person4!.zip!),
                                  style: pw.TextStyle(
                                    font: ttf,
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                )),
                            pw.Text(
                              'מיקוד: '.split('').reversed.join(),
                              style: pw.TextStyle(
                                font: ttf,
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            pw.Container(
                                width: 80,
                                alignment: pw.Alignment.centerRight,
                                decoration: const pw.BoxDecoration(
                                    border: pw.Border(
                                  bottom: pw.BorderSide(
                                      width: 1.0, color: PdfColors.black),
                                )),
                                child: pw.Text(
                                  //    town!.split('').reversed.join(),
                                  ReverseString(_person4!.town!),
                                  style: pw.TextStyle(
                                    font: ttf,
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                )),
                            pw.Text(
                              'ישוב: '.split('').reversed.join(),
                              style: pw.TextStyle(
                                font: ttf,
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            pw.Container(
                                width: 80,
                                alignment: pw.Alignment.centerRight,
                                decoration: const pw.BoxDecoration(
                                    border: pw.Border(
                                  bottom: pw.BorderSide(
                                      width: 1.0, color: PdfColors.black),
                                )),
                                child: pw.Text(
                                  // street!.split('').reversed.join(),
                                  ReverseString(_person4!.street!),
                                  style: pw.TextStyle(
                                    font: ttf,
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                )),
                            pw.Text('רח:  '.split('').reversed.join(),
                                style: pw.TextStyle(
                                  font: ttf,
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                                textDirection: pw.TextDirection.rtl),
                          ],
                        ),
                      ]),
                ],
              ),
            ],
          ),
          // pw.Column(
          //   crossAxisAlignment: pw.CrossAxisAlignment.end,
          //   children: <pw.Widget>[
          //     pw.Container(
          //       //alignment: pw.Alignment.centerRight,
          //       child: pw.Column(
          //         crossAxisAlignment: pw.CrossAxisAlignment.end,
          //         children: [
          //           pw.Row(
          //             mainAxisAlignment: pw.MainAxisAlignment.end,
          //             children: [
          //               pw.Column(children: [
          //                 pw.Row(children: [
          //                   pw.Container(
          //                     padding: pw.EdgeInsets.only(left: 50),
          //                     // alignment: pw.Alignment.centerRight,
          //                     // width:
          //                     //   MediaQuery.of(context).size.width * 0.6,
          //                     child: pw.Text(
          //                         'והמזמין פנה לספק ובקשו שיספק לו ברזל , בלוקים , צבע וחומרי בניין ,'
          //                             .split('')
          //                             .reversed
          //                             .join(),
          //                         // maxLines: 6,
          //                         //textAlign: pw.TextAlign.right,
          //                         style: pw.TextStyle(fontSize: 8, font: ttf),
          //                         textDirection: pw.TextDirection.rtl),
          //                   ),
          //                 ]),
          //                 pw.Container(
          //                   child: pw.Text(
          //                       '    )להלן "הסחורה"( ,בניין לפי הזמנה/הזמנות שמתכוון המזמין להזמין מאת הספק.'
          //                           .split('')
          //                           .reversed
          //                           .join(),
          //                       // maxLines: 6,
          //                       //textAlign: pw.TextAlign.right,
          //                       style: pw.TextStyle(fontSize: 8, font: ttf),
          //                       textDirection: pw.TextDirection.rtl),
          //                 ),
          //               ]),
          //             ],
          //           ),
          //           pw.Row(
          //             mainAxisAlignment: pw.MainAxisAlignment.end,
          //             children: [
          //               pw.Container(
          //                 //alignment: pw.Alignment.centerRight,
          //                 child: pw.Text(
          //                     'וברצון הספק לספק למזמין סחורה בכמויות ובהזמנה שיסוכמו בין הצדדים.'
          //                         .split('')
          //                         .reversed
          //                         .join(),
          //                     // maxLines: 6,
          //                     //textAlign: pw.TextAlign.right,
          //                     style: pw.TextStyle(fontSize: 8, font: ttf),
          //                     textDirection: pw.TextDirection.rtl),
          //               ),
          //             ],
          //           ),
          //           pw.Row(
          //             mainAxisAlignment: pw.MainAxisAlignment.end,
          //             children: [
          //               pw.Container(
          //                 //alignment: pw.Alignment.centerRight,
          //                 child: pw.Text(
          //                     'וברצון הצדדים להגדיר ולהסדיר את יחסיהם המשפטיים כמפורט בתנאי הסכם זה להלן:'
          //                         .split('')
          //                         .reversed
          //                         .join(),
          //                     // maxLines: 6,
          //                     //textAlign: pw.TextAlign.right,
          //                     style: pw.TextStyle(fontSize: 8, font: ttf),
          //                     textDirection: pw.TextDirection.rtl),
          //               ),
          //             ],
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          pw.SizedBox(
              width: 500,
              child: pw.Column(
                children: <pw.Widget>[
                  pw.SizedBox(height: 30),
                  pw.Column(children: [
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Container(
                            alignment: pw.Alignment.centerRight,

                            //alignment: pw.Alignment.centerRight,
                            // width: MediaQuery.of(context).size.width * 0.6,
                            child: pw.Text(
                                '1 . אנו מתחייבים לשלם מיד עם דרישתן הראשונה של הספק הנ"ל כל סכום שידרשו מאיתנו , על חשבון המגיע לו מאת'
                                    .split('')
                                    .reversed
                                    .join(),
                                maxLines: 2,
                                //textAlign: pw.TextAlign.right,
                                style: pw.TextStyle(fontSize: 8, font: ttf),
                                textDirection: pw.TextDirection.rtl),
                          ),
                        ]),
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.end,
                              children: [
                                pw.Container(
                                  alignment: pw.Alignment.centerRight,

                                  //alignment: pw.Alignment.centerRight,
                                  // width: MediaQuery.of(context).size.width * 0.6,
                                  child: pw.Text(
                                      ',)להלן – החייב/ים( בצירוף הפרשי הצמדה, וריבית, הוצאות ושכ"ט עו"ד )להלן – "סכום הערבות"(.'
                                          .split('')
                                          .reversed
                                          .join(),
                                      maxLines: 2,
                                      //textAlign: pw.TextAlign.right,
                                      style:
                                          pw.TextStyle(fontSize: 8, font: ttf),
                                      textDirection: pw.TextDirection.rtl),
                                ),
                              ]),
                          pw.Container(
                            padding: const pw.EdgeInsets.only(right: 10),
                            child: pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.end,
                              children: [
                                pw.Container(
                                    padding: const pw.EdgeInsets.only(right: 5),
                                    width: 100,
                                    alignment: pw.Alignment.centerRight,
                                    decoration: const pw.BoxDecoration(
                                        border: pw.Border(
                                      bottom: pw.BorderSide(
                                          width: 1.0, color: PdfColors.black),
                                    )),
                                    child: pw.Text(
                                      //    town!.split('').reversed.join(),
                                      ReverseString(_person3!.name!),
                                      style:
                                          pw.TextStyle(font: ttf, fontSize: 8),
                                    )),
                              ],
                            ),
                          )
                        ]),

                    //
                  ]),

                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children: [
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Text(
                                '2 . אנו מתחייבים לשלם לספק הנ"ל את סכום הערבות מבלי שהוא יצטרך להוכיח לנו שהחייב/ים'
                                    .split('')
                                    .reversed
                                    .join(),
                                maxLines: 2,
                                //textAlign: pw.TextAlign.right,
                                style: pw.TextStyle(fontSize: 8, font: ttf),
                                textDirection: pw.TextDirection.rtl),
                            pw.Container(
                                padding: const pw.EdgeInsets.only(right: 10),
                                child: pw.Text(
                                    'הפרו את התחייבויותיהם כלפיו ומבלי שינקטו תחילה בכל צעדים שהם לגבייתו של החוב מאת החייב/ים. '
                                        .split('')
                                        .reversed
                                        .join(),
                                    maxLines: 2,
                                    //textAlign: pw.TextAlign.right,
                                    style: pw.TextStyle(fontSize: 8, font: ttf),
                                    textDirection: pw.TextDirection.rtl)),
                          ]),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Text(
                              ReverseString(
                                  '3. התחייבותנו זו לתשלום סכום הערבות תעמוד בתקופה ,לא תושפע ולא תפגע גם אם כתוצאה מהסדר נושים - , '),

                              // maxLines: 6,
                              //textAlign: pw.TextAlign.right,
                              style: pw.TextStyle(fontSize: 8, font: ttf),
                              textDirection: pw.TextDirection.rtl),
                        ],
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Container(
                            padding: const pw.EdgeInsets.only(right: 10),
                            child: pw.Text(
                                ReverseString(
                                    'או כתוצאה מפשיטת רגל, פירוק חברה, כינוס נכסים או כל העדר יכולת של החייב/ים, יוחלט ע"י בימ"ש מוסמך להפטיר את הערבים'),

                                // maxLines: 6,
                                //textAlign: pw.TextAlign.right,
                                style: pw.TextStyle(fontSize: 8, font: ttf),
                                textDirection: pw.TextDirection.rtl),
                          )
                        ],
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Container(
                            padding: const pw.EdgeInsets.only(right: 10),
                            child: pw.Text(
                                ReverseString(
                                    ' או למחול על ערבותם  עפ"י כתב ערבות זה.'),

                                // maxLines: 6,
                                //textAlign: pw.TextAlign.right,
                                style: pw.TextStyle(fontSize: 8, font: ttf),
                                textDirection: pw.TextDirection.rtl),
                          )
                        ],
                      ),
                    ],
                  ),
                  pw.Column(
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Text(
                              '4 .אנו מוותרים בזה על זכותנו לטעון כל הגנה שהן, ומתחייבים לשפות את הספק , על כל נזק , הפסד והוצאות שייגרמו לו עקב הסדר '
                                  .split('')
                                  .reversed
                                  .join(),
                              //  maxLines: 6,
                              //textAlign: pw.TextAlign.right,
                              style: pw.TextStyle(fontSize: 8, font: ttf),
                              textDirection: pw.TextDirection.rtl),
                        ],
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Container(
                            padding: const pw.EdgeInsets.only(right: 10),
                            child: pw.Text(
                                'תשלומים עם החייב/ים.'
                                    .split('')
                                    .reversed
                                    .join(),
                                //  maxLines: 6,
                                //textAlign: pw.TextAlign.right,
                                style: pw.TextStyle(fontSize: 8, font: ttf),
                                textDirection: pw.TextDirection.rtl),
                          )
                        ],
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Text(
                              'אנו מסכימים כי הרישומים בספרי הספק הינם הרישומים המחייבים וזאת לרבות רישומי כרטסת הנהלת החשבונות שלו .'
                                  .split('')
                                  .reversed
                                  .join(),
                              // maxLines: 6,
                              //textAlign: pw.TextAlign.right,
                              style: pw.TextStyle(fontSize: 8, font: ttf),
                              textDirection: pw.TextDirection.rtl),
                        ],
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Text(
                              'אנו מסכימים כי אין הספק חייב לשמור על תעודות המשלוח לתקופה העולה על 6 חודשים .'
                                  .split('')
                                  .reversed
                                  .join(),
                              // maxLines: 6,
                              //textAlign: pw.TextAlign.right,
                              style: pw.TextStyle(fontSize: 8, font: ttf),
                              textDirection: pw.TextDirection.rtl),
                        ],
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Text(
                              '5 .ערבותנו זו תשמש בטוחה מתמדת וחוזרת ותישאר בתוקפה למרות כל הסדר תשלומים שייעשה עם החייב/ים ותחייב אותנו ואת חליפינו חוקיים, '
                                  .split('')
                                  .reversed
                                  .join(),
                              // maxLines: 6,
                              //   //textAlign: pw.TextAlign.right,
                              style: pw.TextStyle(fontSize: 8, font: ttf),
                              textDirection: pw.TextDirection.rtl),
                        ],
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Container(
                            padding: const pw.EdgeInsets.only(right: 9),
                            child: pw.Text(
                                'עד לסילוק המלא והסופי של סכום הערבות לספק הנ"ל .'
                                    .split('')
                                    .reversed
                                    .join(),
                                // maxLines: 6,
                                //   //textAlign: pw.TextAlign.right,
                                style: pw.TextStyle(fontSize: 8, font: ttf),
                                textDirection: pw.TextDirection.rtl),
                          )
                        ],
                      ),
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children: [
                      pw.Text(
                          '6.   במעמד חתימת הסכם זה יחתום המזמין על שטר חוב פתוח.'
                              .split('')
                              .reversed
                              .join(),
                          //  maxLines: 6,
                          //textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(fontSize: 8, font: ttf),
                          textDirection: pw.TextDirection.rtl),
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children: [
                      pw.Text(
                          '7 .ערבות זו ניתנת על – ידינו ביחד ולחוד לספק הנ"ל,'
                              .split('')
                              .reversed
                              .join(),
                          //  maxLines: 6,
                          //textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(fontSize: 8, font: ttf),
                          textDirection: pw.TextDirection.rtl),
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children: [
                      pw.Text(
                          ', ואהיה מנוע מלטעון אחרת.'.split('').reversed.join(),
                          //  maxLines: 6,
                          //textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(fontSize: 8, font: ttf),
                          textDirection: pw.TextDirection.rtl),
                      pw.Text(
                          'בחוק הערבות, התשכ"ז - 7691'
                              .split('')
                              .reversed
                              .join(),
                          //  maxLines: 6,
                          //textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(fontSize: 8, font: ttfExtraBold),
                          textDirection: pw.TextDirection.rtl),
                      pw.Text(
                          '8. בשום מקרה איש מאתנו לא מהווה "ערב יחיד" או "ערב מוגן" כמשמעו '
                              .split('')
                              .reversed
                              .join(),
                          //  maxLines: 6,
                          //textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(fontSize: 8, font: ttf),
                          textDirection: pw.TextDirection.rtl),
                    ],
                  ),
                  pw.SizedBox(height: 10), //

                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children: [
                      pw.Text(
                          ' ככל שניתן להתנות על האמור בו.'
                              .split('')
                              .reversed
                              .join(),
                          //  maxLines: 6,
                          //textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(fontSize: 8, font: ttf),
                          textDirection: pw.TextDirection.rtl),
                      pw.Text(
                          ' חוק הערבות, תשכ"ז - 7691, '
                              .split('')
                              .reversed
                              .join(),
                          //  maxLines: 6,
                          //textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(fontSize: 8, font: ttfExtraBold),
                          textDirection: pw.TextDirection.rtl),
                      pw.Text(
                          'אנו מוותרים על כל הגנה על פי'
                              .split('')
                              .reversed
                              .join(),
                          //  maxLines: 6,
                          //textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(fontSize: 8, font: ttf),
                          textDirection: pw.TextDirection.rtl),
                    ],
                  ),
                  pw.SizedBox(height: 10), //
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children: [
                      pw.Text(
                          '8 .מקום השיפוט לצורך כתב ערבות זה הינו ביהמ"ש המוסמך בכפר – סבא ו/או בנתניה '
                              .split('')
                              .reversed
                              .join(),
                          //  maxLines: 6,
                          //textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(fontSize: 8, font: ttf),
                          textDirection: pw.TextDirection.rtl),
                    ],
                  ),
                ],
              )),
          //
          pw.SizedBox(height: 15),
          pw.Container(
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(width: 1.0, color: PdfColors.black),
              ),
            ),
            child: pw.Text(ReverseString('ולראייה באו הצדדים על החתום:'),
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  font: ttfExtraBold,
                ),
                textDirection: pw.TextDirection.rtl),
          ),
          pw.SizedBox(
            height: 10,
          ),

          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Container(
                decoration: const pw.BoxDecoration(
                  border: pw.Border(
                    bottom: pw.BorderSide(width: 1.0, color: PdfColors.black),
                  ),
                ),
                child: pw.Text(ReverseString('$formattedDate'),
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                      font: ttfExtraBold,
                    ),
                    textDirection: pw.TextDirection.rtl),
              ),
              pw.Text(ReverseString('תאריך:'),
                  style: pw.TextStyle(
                    fontSize: 10,
                    font: ttfExtraBold,
                  ),
                  textDirection: pw.TextDirection.rtl),
            ],
          ),
          pw.SizedBox(
            height: 20,
          ),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              // pw.Column(children: [
              //   pw.SizedBox(
              //     height: 150,
              //   ),
              //   pw.Container(
              //     //alignment: pw.Alignment.centerRight,
              //     // width: MediaQuery.of(context).size.width * 0.6,
              //     child: pw.Text(ReverseString('בלוק עיראקי בע"מ   '),

              //         //  maxLines: 6,
              //         //textAlign: pw.TextAlign.right,
              //         style: pw.TextStyle(fontSize: 12, font: ttf),
              //         textDirection: pw.TextDirection.rtl),
              //   ),
              // ]),

              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Container(
                      width: 120,
                      decoration: const pw.BoxDecoration(
                        border: pw.Border(
                          top:
                              pw.BorderSide(width: 1.0, color: PdfColors.black),
                        ),
                      ),
                      child: pw.Text(ReverseString('חתימת ערב 2'),

                          //  maxLines: 6,
                          //textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(fontSize: 12, font: ttf),
                          textDirection: pw.TextDirection.rtl),
                    ),
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Container(
                            decoration: const pw.BoxDecoration(
                              border: pw.Border(
                                bottom: pw.BorderSide(
                                    width: 1.0, color: PdfColors.black),
                              ),
                            ),
                            child: pw.Text(ReverseString('$formattedDate'),

                                //  maxLines: 6,
                                //textAlign: pw.TextAlign.right,
                                style: pw.TextStyle(fontSize: 8, font: ttf),
                                textDirection: pw.TextDirection.rtl),
                          ),
                          pw.Text(ReverseString('אני מאשר כי ביום'),

                              //  maxLines: 6,
                              //textAlign: pw.TextAlign.right,
                              style: pw.TextStyle(fontSize: 8, font: ttf),
                              textDirection: pw.TextDirection.rtl),
                        ]),
                    pw.Container(
                        width: 60,
                        child: pw.Text(
                            ReverseString(
                                'הופיע בפני הערב הנ"ל ולאחר שזיהיתי אותו על-פי ת.ז. מספר'),

                            //  maxLines: 6,
                            //textAlign: pw.TextAlign.right,
                            style: pw.TextStyle(fontSize: 8, font: ttf),
                            maxLines: 3,
                            textDirection: pw.TextDirection.rtl)),
                    pw.Container(
                      width: 80,
                      decoration: const pw.BoxDecoration(
                        border: pw.Border(
                          bottom:
                              pw.BorderSide(width: 1.0, color: PdfColors.black),
                        ),
                      ),
                      child: pw.Text(ReverseString(_person5!.name!),

                          //  maxLines: 6,
                          //textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(fontSize: 12, font: ttf),
                          textDirection: pw.TextDirection.rtl),
                    ),
                    pw.Text(ReverseString('חתם בפני'),

                        //  maxLines: 6,
                        //textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(fontSize: 8, font: ttf),
                        textDirection: pw.TextDirection.rtl),
                    pw.Container(
                      width: 80,
                      decoration: const pw.BoxDecoration(
                        border: pw.Border(
                          bottom:
                              pw.BorderSide(width: 1.0, color: PdfColors.black),
                        ),
                      ),
                      child: pw.Text(ReverseString(_person5!.ssn!),

                          //  maxLines: 6,
                          //textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(fontSize: 8, font: ttf),
                          textDirection: pw.TextDirection.rtl),
                    ),
                    pw.Text(ReverseString('שם ומשפחה'),

                        //  maxLines: 6,
                        //textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(fontSize: 8, font: ttf),
                        textDirection: pw.TextDirection.rtl),
                    pw.SizedBox(
                      height: 10,
                    ),
                    data1 != null
                        ? pw.Image(pw.MemoryImage(data1))
                        : pw.Text(ReverseString(''),

                            //  maxLines: 6,
                            //textAlign: pw.TextAlign.right,
                            style: pw.TextStyle(fontSize: 8, font: ttf),
                            textDirection: pw.TextDirection.rtl),
                    pw.Text(ReverseString('חתימה'),

                        //  maxLines: 6,
                        //textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(fontSize: 8, font: ttf),
                        textDirection: pw.TextDirection.rtl),
                  ]),

              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Container(
                      width: 120,
                      decoration: const pw.BoxDecoration(
                        border: pw.Border(
                          top:
                              pw.BorderSide(width: 1.0, color: PdfColors.black),
                        ),
                      ),
                      child: pw.Text(ReverseString('חתימת ערב 1'),

                          //  maxLines: 6,
                          //textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(fontSize: 12, font: ttf),
                          textDirection: pw.TextDirection.rtl),
                    ),
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Container(
                            width: 60,
                            decoration: const pw.BoxDecoration(
                              border: pw.Border(
                                bottom: pw.BorderSide(
                                    width: 1.0, color: PdfColors.black),
                              ),
                            ),
                            child: pw.Text(
                                ReverseString(
                                  '$formattedDate',
                                ),

                                //  maxLines: 6,
                                //textAlign: pw.TextAlign.right,
                                style: pw.TextStyle(fontSize: 8, font: ttf),
                                textDirection: pw.TextDirection.rtl),
                          ),
                          pw.Text(ReverseString('אני מאשר כי ביום'),

                              //  maxLines: 6,
                              //textAlign: pw.TextAlign.right,
                              style: pw.TextStyle(fontSize: 8, font: ttf),
                              textDirection: pw.TextDirection.rtl),
                        ]),
                    pw.Container(
                        width: 80,
                        child: pw.Text(
                            ReverseString(
                                'הופיע בפני הערב הנ"ל ולאחר שזיהיתי אותו על-פי ת.ז. מספר'),

                            //  maxLines: 6,
                            //textAlign: pw.TextAlign.right,
                            style: pw.TextStyle(fontSize: 8, font: ttf),
                            maxLines: 3,
                            textDirection: pw.TextDirection.rtl)),
                    pw.Container(
                      width: 80,
                      decoration: const pw.BoxDecoration(
                        border: pw.Border(
                          bottom:
                              pw.BorderSide(width: 1.0, color: PdfColors.black),
                        ),
                      ),
                      child: pw.Text(ReverseString(_person5!.name!),

                          //  maxLines: 6,
                          //textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(fontSize: 8, font: ttf),
                          textDirection: pw.TextDirection.rtl),
                    ),
                    pw.Text(ReverseString('חתם בפני'),

                        //  maxLines: 6,
                        //textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(fontSize: 8, font: ttf),
                        textDirection: pw.TextDirection.rtl),
                    pw.Container(
                      width: 80,
                      decoration: const pw.BoxDecoration(
                        border: pw.Border(
                          bottom:
                              pw.BorderSide(width: 1.0, color: PdfColors.black),
                        ),
                      ),
                      child: pw.Text(ReverseString(_person5!.ssn!),

                          //  maxLines: 6,
                          //textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(fontSize: 8, font: ttf),
                          textDirection: pw.TextDirection.rtl),
                    ),
                    pw.Text(ReverseString('שם ומשפחה'),

                        //  maxLines: 6,
                        //textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(fontSize: 8, font: ttf),
                        textDirection: pw.TextDirection.rtl),
                    pw.SizedBox(
                      height: 10,
                    ),
                    data2 != null
                        ? pw.Image(pw.MemoryImage(data2))
                        : pw.Text(ReverseString(''),
                            //  maxLines: 6,
                            //textAlign: pw.TextAlign.right,
                            style: pw.TextStyle(fontSize: 8, font: ttf),
                            textDirection: pw.TextDirection.rtl),
                    pw.Text(ReverseString('חתימה'),
                        //  maxLines: 6,
                        //textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(fontSize: 8, font: ttf),
                        textDirection: pw.TextDirection.rtl),
                  ]),

              // pw.Column(children: [
              //   pw.Image(pw.MemoryImage(data3)),
              //   pw.Container(
              //     //alignment: pw.Alignment.centerRight,
              //     // width: MediaQuery.of(context).size.width * 0.6,
              //     child: pw.Text(ReverseString('חתימת ערב 2'),

              //         //  maxLines: 6,
              //         //textAlign: pw.TextAlign.right,
              //         style: pw.TextStyle(fontSize: 12, font: ttf),
              //         textDirection: pw.TextDirection.rtl),
              //   ),
              // ]),

              // pw.Column(children: [
              //   pw.Image(pw.MemoryImage(data4)),
              //   pw.Container(
              //     //alignment: pw.Alignment.centerRight,
              //     // width: MediaQuery.of(context).size.width * 0.6,
              //     child: pw.Text(ReverseString('חתימת ערב 1'),

              //         //  maxLines: 6,
              //         //textAlign: pw.TextAlign.right,
              //         style: pw.TextStyle(fontSize: 12, font: ttf),
              //         textDirection: pw.TextDirection.rtl),
              //   ),
              // ]),
            ],
          ),
        ])),
      ),
    );

    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String documentPath = documentDirectory.path;

    String id = DateTime.now().toString();
    try {
      int? conId = Provider.of<GetCurrentUser>(context, listen: false)
          .currentUser!
          .contactId;
      String fileName = '$conId-$id';
      fileName = fileName
          .replaceAll(" ", "")
          .replaceAll(':', '')
          .replaceAll('.', '')
          .replaceAll('-', '');
      fileName = fileName + ".pdf";

      file = File("$documentPath/$fileName");

      file?.writeAsBytesSync(await pdf.save());

      uploadFile(file!);

      if (widget.document != null &&
          widget.document!.id != null &&
          widget.document!.id != 0) {
        widget.document!.contactId = conId;
        widget.document!.documentLink = fileName;
        Repository().upsertLegalDocument(widget.document!);
      } else {
        LegalDocument doc = LegalDocument(
            id: 0,
            active: true,
            contactId: conId,
            documentLink: fileName,
            name: 'guarantee');
        Repository().upsertLegalDocument(doc);
      }
    } catch (e) {
      print('saveData' + e.toString());
    }
  }

  cancel() {
    save = false;
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }
}

//final String _baseUrl = 'http://139.162.139.161:8000'; //http://127.0.0.1:8000
final String _baseUrl = ApiBaseHelper().apiURL;

uploadFile(File imageFile) async {
  try {
    var postUri = Uri.parse("$_baseUrl/IraqiStore/upload/file/");
    var request = http.MultipartRequest("POST", postUri);
    request.files
        .add(await http.MultipartFile.fromPath('file', imageFile.path));
    var response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {}
  } catch (e) {
    print('error uploading signature: ${e.toString()}');
  }
}

bool isArabic(String s) {
  var expr = RegExp(r'^[\u0621-\u064A\u0660-\u0669 ]+$');
  return expr.hasMatch(s);
}

String ReverseString(String s) {
  if (s == "") return "-";

  String result = "";
  String isNum = "";
  String isString = "";
  List<String> all = <String>[];
  s = s + ' ^';

  s.characters.forEach((element) {
    if (element.contains(RegExp(r'[0-9]'))) {
      isNum = isNum + element;
    } else {
      if (isNum.isNotEmpty) {
        all.add(isNum);
        isNum = "";
      }
    }
    var onlyHebrewPattern =
        RegExp(r"[\u0600-\u06FF\u0750-\u077F\u0590-\u05FF\uFE70-\uFEFF]");

    if (onlyHebrewPattern.hasMatch(element)) {
      isString = isString + element;
    } else {
      if (isString.isNotEmpty) {
        all.add(
          isString.split('').reversed.join(),
        );
        isString = "";
      }
    }

    //https://regex-generator.olafneumann.org

    if (element == '.' ||
        element == '-' ||
        element == '"' ||
        element == ',' ||
        element == '(' ||
        element == ')' ||
        element == ':' ||
        element == '/' ||
        element == '.') {
      all.add(element);
    }
  });
  var _reversed = List.from(all.reversed);

  _reversed.forEach((element) {
    String split = element.toString().length == 1 ? '' : ' ';
    if (element == '(') {
      result = result + ')';
    } else if (element == ')') {
      result = result + '(';
    } else
      result = result + split + element;
  });

  return (result);
}
