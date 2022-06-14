import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hardwarestore/components/user.dart';
import 'package:hardwarestore/models/legal_document.dart';
import 'package:hardwarestore/services/api.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class FormDeliveryAgreement extends StatefulWidget {
  @override
  _FormDeliveryAgreementState createState() => _FormDeliveryAgreementState();
}

class _FormDeliveryAgreementState extends State<FormDeliveryAgreement> {
  int _currentStep = 0;
  bool save = false;
  String? name;
  String? ssn;
  String? street;
  String? town;
  String? phone;
  bool sigRequired = true;
  File? file;

  StepperType stepperType = StepperType.vertical;

  final SignatureController _controller = SignatureController(
    // penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
    exportPenColor: Colors.black,
  );
  @override
  void initState() {
    super.initState();
    _controller.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    phone = Provider.of<GetCurrentUser>(context).currentUser?.uid ?? "";
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('חתימות על הסכמים'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Stepper(
              type: stepperType,
              physics: ScrollPhysics(),
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
                            filledAllData() ? Colors.blue : Colors.grey,
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
                    'הסכם אספקת חומרי בניין',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                          'אשר נערך ונחתם בטירה ביום ${DateTime.now().day} חודש ${DateTime.now().month} שנה ${DateTime.now().year}'),
                      const Text(
                        'בין:',
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'בין',
                            helperText: 'חובה',
                            helperStyle:
                                TextStyle(color: Colors.red, fontSize: 10)),
                        onChanged: (value) {
                          setState(() {
                            name = value;
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
                            helperStyle:
                                TextStyle(color: Colors.red, fontSize: 10)),
                        onChanged: (value) {
                          setState(() {
                            ssn = value;
                          });
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'רח׳',
                            helperText: 'חובה',
                            helperStyle:
                                TextStyle(color: Colors.red, fontSize: 10)),
                        onChanged: (value) {
                          setState(() {
                            street = value;
                          });
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'ישוב',
                            helperText: 'חובה',
                            helperStyle:
                                TextStyle(color: Colors.red, fontSize: 10)),
                        onChanged: (value) {
                          setState(() {
                            town = value;
                          });
                        },
                      ),
                      // TextFormField(
                      //   decoration: InputDecoration(labelText: 'טל׳'),
                      // ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Text('(להלן: "המזמין")',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                            Text(
                              'מצד אחד',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        'לבין: בלוק עיראקי בע"מ ח.פ. 511530610 מטירה – 44915 ',
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Text('(להלן: "הספק")',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                            Text(
                              'מצד שני',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 0
                      ? StepState.complete
                      : StepState.disabled,
                ),
                Step(
                  title: const Text(
                    'המשך...',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerRight,
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text('הואיל :',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    )),
                                Container(
                                  alignment: Alignment.centerRight,
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: const Text(
                                    'והמזמין פנה לספק ובקשו שיספק לו ברזל , בלוקים , צבע וחומרי בניין , (להלן "הסחורה") ,בניין לפי הזמנה/הזמנות שמתכוון המזמין להזמין מאת הספק . ',
                                    maxLines: 6,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text('והואיל :',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    )),
                                Container(
                                  alignment: Alignment.centerRight,
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: const Text(
                                    'וברצון הספק לספק למזמין סחורה בכמויות ובהזמנה שיסוכמו בין הצדדים .',
                                    maxLines: 6,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text('והואיל :',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    )),
                                Container(
                                  alignment: Alignment.centerRight,
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: const Text(
                                    'וברצון הצדדים להגדיר ולהסדיר את יחסיהם המשפטיים כמפורט בתנאי הסכם זה להלן:',
                                    maxLines: 6,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
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
                    'לפיכן הוסכם , הוצהר והותנה בין הצדדים כדלקמן :',
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
                              '1 .	המבוא להסכם מהווה חלק בלתי נפרד הימנו ותנאי מתנאיו .',
                              maxLines: 6,
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 12),
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
                              '2 .	המזמין מצהיר ומתחייב בזאת לשלם עם דרישת הספק הראשונה את כל התמורה בעד כל הזמנה / ההזמנות שהוזמנו אצל הספק ותמורת כל הסחורה אשר סופקה לו על ידי הספק .',
                              maxLines: 6,
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 12),
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
                              '2.1 	במידה והספק לא ישלם את התשלומים המוטלים עליו יהא המזמין רשאי להגיש נגדו   תביעה משפטית ולנקוט נגדו בכל הליך כפי שיראה לו לנכון .',
                              maxLines: 6,
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 12),
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
                              '3 .		המזמין מצהיר ומתחייב לשלם את תמורת כל הזמנה לפי המחירים שיסוכמו בין הצדדים מעת לעת ולפי כל הזמנה והזמנה ',
                              maxLines: 6,
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 12),
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
                              '4 .	המזמין מצהיר כי רישומי הספק מחייבים אותו וכי מתחייב הוא לשלם את כל התשלומים המוטלים עליו לפי הרשום בספרי הספק .',
                              maxLines: 6,
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 12),
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
                              '5 .	כל מחלוקת אשר תהא בין הצדדים בנוגע להסכם זה בנוגע לסמכות המקומית תהא מסורה לבית משפט השלום בכ"ס . ',
                              maxLines: 6,
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 12),
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
                              '6 .	במעמד חתימת הסכם זה יחתום המזמין על שטר חוב פתוח .',
                              maxLines: 6,
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 12),
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
                    'ולראייה באו הצדדים על החתום',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 210,
                        width: 310,
                        // child: SignaturePage()
                        child: Signature(controller: _controller),
                      ),
                      if (sigRequired)
                        const Text(
                          'יש לחתום על ההסכם...',
                          style: TextStyle(color: Colors.red),
                        ),
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
    if (!filledAllData()) return null;
    if (_currentStep == 2) save = true;
    _currentStep < 3 ? setState(() => _currentStep += 1) : null;
  }

  bool filledAllData() {
    if (name == null ||
        name!.isEmpty ||
        ssn == null ||
        ssn!.isEmpty ||
        town == null ||
        town!.isEmpty ||
        street == null ||
        street!.isEmpty) return false;
    return true;
  }

  saveData() async {
    if (file != null) return;
    final font = await rootBundle.load("assets/fonts/Arimo-Regular.ttf");
    final ttf = pw.Font.ttf(font);
    final fontBold = await rootBundle.load("assets/fonts/Arimo-SemiBold.ttf");
    final ttfBold = pw.Font.ttf(fontBold);
    final fontExtraBold = await rootBundle.load("assets/fonts/Arimo-Bold.ttf");
    final ttfExtraBold = pw.Font.ttf(fontExtraBold);

    final pdf = pw.Document();

    Uint8List? data;

    if (_controller.isNotEmpty) {
      data = await _controller.toPngBytes();
      if (data != null) {
        pw.MemoryImage(data);

        setState(() {
          sigRequired = false;
        });
      }
    } else {
      if (save) return null;
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
                  child: pw.Text(
                      '.' +
                          ' הסכם אספקת חומרי בניין '.split('').reversed.join() +
                          '.',
                      style: pw.TextStyle(
                        fontSize: 18,
                        decoration: pw.TextDecoration.underline,
                        fontWeight: pw.FontWeight.bold,
                        font: ttfExtraBold,
                      ),
                      textDirection: pw.TextDirection.rtl),
                ),
              ]),
              pw.SizedBox(height: 30),
              pw.Container(
                alignment: pw.Alignment.center,
                child: pw.Text(
                    ReverseString(
                        'אשר נערך ונחתם בטירה ביום ${DateTime.now().day} חודש ${DateTime.now().month} שנה ${DateTime.now().year}'),
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      font: ttfBold,
                    ),
                    textDirection: pw.TextDirection.rtl),
              ),
              pw.SizedBox(height: 30),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    //ssn!.split('').reversed.join(),
                    ReverseString(ssn!),
                    style: pw.TextStyle(
                      font: ttfBold,
                      fontWeight: pw.FontWeight.bold,
                      decoration: pw.TextDecoration.underline,
                    ),
                  ),
                  pw.Text('ת.ז.:  '.split('').reversed.join()),
                  pw.SizedBox(
                    width: 10,
                  ),
                  pw.Container(
                    decoration: const pw.BoxDecoration(
                        border: pw.Border(
                      bottom: pw.BorderSide(width: 1.0, color: PdfColors.black),
                    )),
                    child: pw.Text(
                      // name!.split('').reversed.join(),
                      ReverseString(name!),
                      style: pw.TextStyle(
                        font: ttfBold,
                        fontWeight: pw.FontWeight.bold,
                        //   decoration: pw.TextDecoration.underline,
                      ),
                      textDirection: pw.TextDirection.rtl,
                    ),
                  ),
                  pw.Text('בין:  '.split('').reversed.join(),
                      style: pw.TextStyle(font: ttf),
                      textDirection: pw.TextDirection.rtl),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    // street!.split('').reversed.join(),
                    ReverseString(street!),
                    style: pw.TextStyle(
                      font: ttfBold,
                      decoration: pw.TextDecoration.underline,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text('רח:  '.split('').reversed.join(),
                      style: pw.TextStyle(font: ttf),
                      textDirection: pw.TextDirection.rtl),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    //    town!.split('').reversed.join(),
                    ReverseString(town!),
                    style: pw.TextStyle(
                      font: ttfBold,
                      fontWeight: pw.FontWeight.bold,
                      decoration: pw.TextDecoration.underline,
                    ),
                  ),
                  pw.Text('ישוב: '.split('').reversed.join()),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    //  phone!.split('').reversed.join(),
                    ReverseString(phone!),
                    style: pw.TextStyle(
                      font: ttfBold,
                      fontWeight: pw.FontWeight.bold,
                      decoration: pw.TextDecoration.underline,
                    ),
                  ),
                  pw.Text('טל:  '.split('').reversed.join(),
                      style: pw.TextStyle(font: ttf),
                      textDirection: pw.TextDirection.rtl),
                ],
              ),

              // pw.Text('רח'.split('').reversed.join()),
              // pw.Text('ישוב'.split('').reversed.join()),
              // pw.Text('טל'.split('').reversed.join()),
              pw.Container(
                alignment: pw.Alignment.centerLeft,
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text(')להלן: "המזמין"('.split('').reversed.join(),
                        style: pw.TextStyle(
                          font: ttfExtraBold,
                          fontWeight: pw.FontWeight.bold,
                        ),
                        textDirection: pw.TextDirection.rtl),
                    pw.Text('מצד אחד'.split('').reversed.join(),
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          font: ttfExtraBold,
                          decoration: pw.TextDecoration.underline,
                        ),
                        textDirection: pw.TextDirection.rtl),
                  ],
                ),
              ),
              pw.SizedBox(
                height: 30,
              ),
              pw.Text(
                  ReverseString(
                      'לבין: בלוק עיראקי בע״מ ח״פ 511530610 מטירה – 44915 '),
                  style: pw.TextStyle(font: ttf),
                  textDirection: pw.TextDirection.rtl),
              pw.Container(
                alignment: pw.Alignment.centerLeft,
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text(')להלן: "הספק"('.split('').reversed.join(),
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          font: ttfExtraBold,
                        ),
                        textDirection: pw.TextDirection.rtl),
                    pw.Text('מצד שני'.split('').reversed.join(),
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          font: ttfExtraBold,
                          decoration: pw.TextDecoration.underline,
                        ),
                        textDirection: pw.TextDirection.rtl),
                  ],
                ),
              ),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: <pw.Widget>[
              pw.Container(
                //alignment: pw.Alignment.centerRight,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
                        pw.Column(children: [
                          pw.Row(children: [
                            pw.Container(
                              padding: pw.EdgeInsets.only(left: 50),
                              // alignment: pw.Alignment.centerLeft,
                              // width:
                              //   MediaQuery.of(context).size.width * 0.6,
                              child: pw.Text(
                                  'והמזמין פנה לספק ובקשו שיספק לו ברזל , בלוקים , צבע וחומרי בניין ,'
                                      .split('')
                                      .reversed
                                      .join(),
                                  // maxLines: 6,
                                  //textAlign: pw.TextAlign.right,
                                  style: pw.TextStyle(fontSize: 8, font: ttf),
                                  textDirection: pw.TextDirection.rtl),
                            ),
                            pw.Text('הואיל :'.split('').reversed.join(),
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  font: ttfBold,
                                ),
                                textDirection: pw.TextDirection.rtl),
                          ]),
                          pw.Container(
                            // alignment: pw.Alignment.centerLeft,
                            // width:
                            //   MediaQuery.of(context).size.width * 0.6,
                            child: pw.Text(
                                '    )להלן "הסחורה"( ,בניין לפי הזמנה/הזמנות שמתכוון המזמין להזמין מאת הספק.'
                                    .split('')
                                    .reversed
                                    .join(),
                                // maxLines: 6,
                                //textAlign: pw.TextAlign.right,
                                style: pw.TextStyle(fontSize: 8, font: ttf),
                                textDirection: pw.TextDirection.rtl),
                          ),
                        ]),
                      ],
                    ),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
                        pw.Container(
                          //alignment: pw.Alignment.centerRight,
                          child: pw.Text(
                              'וברצון הספק לספק למזמין סחורה בכמויות ובהזמנה שיסוכמו בין הצדדים.'
                                  .split('')
                                  .reversed
                                  .join(),
                              // maxLines: 6,
                              //textAlign: pw.TextAlign.right,
                              style: pw.TextStyle(fontSize: 8, font: ttf),
                              textDirection: pw.TextDirection.rtl),
                        ),
                        pw.Text('והואיל: '.split('').reversed.join(),
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, font: ttfBold),
                            textDirection: pw.TextDirection.rtl),
                      ],
                    ),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
                        pw.Container(
                          //alignment: pw.Alignment.centerRight,
                          child: pw.Text(
                              'וברצון הצדדים להגדיר ולהסדיר את יחסיהם המשפטיים כמפורט בתנאי הסכם זה להלן:'
                                  .split('')
                                  .reversed
                                  .join(),
                              // maxLines: 6,
                              //textAlign: pw.TextAlign.right,
                              style: pw.TextStyle(fontSize: 8, font: ttf),
                              textDirection: pw.TextDirection.rtl),
                        ),
                        pw.Text('והואיל: '.split('').reversed.join(),
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, font: ttfBold),
                            textDirection: pw.TextDirection.rtl),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: <pw.Widget>[
              pw.SizedBox(height: 30),
              pw.Container(
                decoration: const pw.BoxDecoration(
                  border: pw.Border(
                    bottom: pw.BorderSide(width: 1.0, color: PdfColors.black),
                  ),
                ),
                //alignment: pw.Alignment.centerRight,
                // width: MediaQuery.of(context).size.width * 0.6,
                child: pw.Text(
                    'לפיכן הוסכם , הוצהר והותנה בין הצדדים כדלקמן :'
                        .split('')
                        .reversed
                        .join(),
                    //  maxLines: 6,
                    //textAlign: pw.TextAlign.right,
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 14,
                      font: ttfBold,
                    ),
                    textDirection: pw.TextDirection.rtl),
              ),
              pw.SizedBox(height: 30),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Container(
                    //alignment: pw.Alignment.centerRight,
                    // width: MediaQuery.of(context).size.width * 0.6,
                    child: pw.Text(
                        '1.    המבוא להסכם מהווה חלק בלתי נפרד הימנו ותנאי מתנאיו.'
                            .split('')
                            .reversed
                            .join(),
                        //  maxLines: 6,
                        //textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(fontSize: 8, font: ttf),
                        textDirection: pw.TextDirection.rtl),
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Container(
                          //alignment: pw.Alignment.centerRight,
                          // width: MediaQuery.of(context).size.width * 0.6,
                          child: pw.Text(
                              '2.    המזמין מצהיר ומתחייב בזאת לשלם עם דרישת הספק הראשונה את כל התמורה בעד כל הזמנה /'
                                  .split('')
                                  .reversed
                                  .join(),
                              maxLines: 2,
                              //textAlign: pw.TextAlign.right,
                              style: pw.TextStyle(fontSize: 8, font: ttf),
                              textDirection: pw.TextDirection.rtl),
                        ),
                        pw.Container(
                          alignment: pw.Alignment.centerRight,
                          // width: MediaQuery.of(context).size.width * 0.6,
                          child: pw.Text(
                              '      ההזמנות שהוזמנו אצל הספק ותמורת כל הסחורה אשר סופקה לו על ידי הספק.'
                                  .split('')
                                  .reversed
                                  .join(),
                              maxLines: 2,
                              //textAlign: pw.TextAlign.right,
                              style: pw.TextStyle(fontSize: 8, font: ttf),
                              textDirection: pw.TextDirection.rtl),
                        ),
                      ]),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Container(
                    padding: const pw.EdgeInsets.only(right: 200),
                    //alignment: pw.Alignment.centerRight,
                    // width: MediaQuery.of(context).size.width * 0.6,
                    child: pw.Text(
                        ReverseString(
                            '2.1   במידה והספק לא ישלם את התשלומים המוטלים עליו יהא המזמין רשאי להגיש נגדו   תביעה משפטית ולנקוט נגדו בכל הליך כפי שיראה לו לנכון.'),

                        // maxLines: 6,
                        //textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(fontSize: 8, font: ttf),
                        textDirection: pw.TextDirection.rtl),
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Container(
                    //alignment: pw.Alignment.centerRight,
                    // width: MediaQuery.of(context).size.width * 0.6,
                    child: pw.Text(
                        '3.   המזמין מצהיר ומתחייב לשלם את תמורת כל הזמנה לפי המחירים שיסוכמו בין הצדדים מעת לעת ולפי כל הזמנה והזמנה'
                            .split('')
                            .reversed
                            .join(),
                        //  maxLines: 6,
                        //textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(fontSize: 8, font: ttf),
                        textDirection: pw.TextDirection.rtl),
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Container(
                    //alignment: pw.Alignment.centerRight,
                    // width: MediaQuery.of(context).size.width * 0.6,
                    child: pw.Text(
                        '4.   המזמין מצהיר כי רישומי הספק מחייבים אותו וכי מתחייב הוא לשלם את כל התשלומים המוטלים עליו לפי הרשום בספרי הספק.'
                            .split('')
                            .reversed
                            .join(),
                        // maxLines: 6,
                        //textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(fontSize: 8, font: ttf),
                        textDirection: pw.TextDirection.rtl),
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Container(
                    //alignment: pw.Alignment.centerRight,
                    // width: MediaQuery.of(context).size.width * 0.6,
                    child: pw.Text(
                        '5.   כל מחלוקת אשר תהא בין הצדדים בנוגע להסכם זה בנוגע לסמכות המקומית תהא מסורה לבית משפט השלום בכ"ס.'
                            .split('')
                            .reversed
                            .join(),
                        // maxLines: 6,
                        //   //textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(fontSize: 8, font: ttf),
                        textDirection: pw.TextDirection.rtl),
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Container(
                    //alignment: pw.Alignment.centerRight,
                    // width: MediaQuery.of(context).size.width * 0.6,
                    child: pw.Text(
                        '6.   במעמד חתימת הסכם זה יחתום המזמין על שטר חוב פתוח.'
                            .split('')
                            .reversed
                            .join(),
                        //  maxLines: 6,
                        //textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(fontSize: 8, font: ttf),
                        textDirection: pw.TextDirection.rtl),
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 50),
          pw.Container(
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(width: 1.0, color: PdfColors.black),
              ),
            ),
            child: pw.Text(ReverseString('ולראייה באו הצדדים על החתום'),
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  font: ttfBold,
                ),
                textDirection: pw.TextDirection.rtl),
          ),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(children: [
                pw.SizedBox(
                  height: 150,
                ),
                pw.Container(
                  //alignment: pw.Alignment.centerRight,
                  // width: MediaQuery.of(context).size.width * 0.6,
                  child: pw.Text(ReverseString('בלוק עיראקי בע"מ   '),

                      //  maxLines: 6,
                      //textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(fontSize: 12, font: ttf),
                      textDirection: pw.TextDirection.rtl),
                ),
              ]),
              pw.Column(children: [
                pw.Image(pw.MemoryImage(data!)),
                pw.Container(
                  //alignment: pw.Alignment.centerRight,
                  // width: MediaQuery.of(context).size.width * 0.6,
                  child: pw.Text(ReverseString('המזמין'),

                      //  maxLines: 6,
                      //textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(fontSize: 12, font: ttf),
                      textDirection: pw.TextDirection.rtl),
                ),
              ]),
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
      file = File("$documentPath/$conId-$id.pdf");

      file?.writeAsBytesSync(await pdf.save());
      uploadFile(file!);

      LegalDocument doc = LegalDocument(
        id: 0,
        active: true,
        contactId: conId,
        documentName: '/pdfs/$conId-$id.pdf',
      );
      Repository().upsertLegalDocument(doc);
    } catch (e) {
      print(e.toString());
    }
  }

  cancel() {
    save = false;
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }
}

uploadFile(File imageFile) async {
  var postUri = Uri.parse("http://127.0.0.1:8000/IraqiStore/upload/file/");
  var request = http.MultipartRequest("POST", postUri);
  request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));
  var response = await request.send();
  if (response.statusCode == 200 || response.statusCode == 201) {}
}

bool isArabic(String s) {
  var expr = RegExp(r'^[\u0621-\u064A\u0660-\u0669 ]+$');
  return expr.hasMatch(s);
}

String ReverseString(String s) {
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

    if (element == '.' || element == '-') {
      all.add(element);
    }

    // if (element == '(') {
    //   all.add(')');
    // }

    // if (element == '(') {
    //   all.add(')');
    // }
  });

  var _reversed = List.from(all.reversed);
  _reversed.forEach((element) {
    result = result + ' ' + element;
  });
  return (result);
}
