import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:hardwarestore/services/api.dart';
import 'package:hardwarestore/widgets/client/client_news_card.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/imgbb_model.dart';
import '../../models/products.dart';
import '../../services/imgbb.dart';

import 'package:flutter/material.dart';

import 'package:hardwarestore/controllers/navigation.dart';
import 'package:hardwarestore/models/news.dart';

import 'package:hardwarestore/models/products.dart';
import 'package:hardwarestore/services/tools.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class NewNewsStepper extends StatefulWidget {
  News? news;
  NewNewsStepper({Key? key, this.news}) : super(key: key);

  @override
  State<NewNewsStepper> createState() => _NewNewsStepperState();
}

class _NewNewsStepperState extends State<NewNewsStepper> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool loading = false;
  bool delay = true;

  String txt = 'Choose Image';
  Dio dio = Dio();
  late ImgbbResponseModel imgbbResponse;
  File? _image;
  final picker = ImagePicker();
  int _currentStep = 0;
  StepperType stepperType = StepperType.horizontal;
  News _data = News();
  bool hasDelivery = false;
  @override
  void initState() {
    if (widget.news != null) _data = widget.news!;
    super.initState();
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      try {
        _image = File(pickedFile!.path);
      } catch (e) {
        print(e.toString());
      }
    });
  }

  void uploadImageFile(
    File _image,
  ) async {
    setState(() {
      loading = true;
    });

    ByteData bytes = await rootBundle.load(_image.path);
    var buffer = bytes.buffer;
    var m = base64.encode(Uint8List.view(buffer));

    FormData formData = FormData.fromMap({"key": imgBBkey, "image": m});

    Response response = await dio.post(
      "https://api.imgbb.com/1/upload",
      data: formData,
    );
    if (response.statusCode != 400) {
      imgbbResponse = ImgbbResponseModel.fromJson(response.data);

      _data.url = imgbbResponse.data?.displayUrl;

      // Repository().upsertProduct(product)!.then((value) {
      //   setState(() {
      //     _data.id = value;
      //   });
      // });
      setState(() {
        delay = false;
        loading = false;
      });
    } else {
      txt = 'Error Upload';
      setState(() {
        loading = false;
      });
    }
  }

  void submit() {
    try {
      // First validate form.
      if (_image != null) uploadImageFile(_image!);

      if (_formKey.currentState!.validate()) {
        _formKey.currentState?.save();
        if (_data.id == null || _data.id == 0) {
          _data.id = 0;
          _data.active = true;
        }

        //DjangoServices().upsertNews(_data)?.then((value) {
        Repository().upsertNews(_data)?.then((value) {
          _data.id == value;
          Provider.of<EntityModification>(context, listen: false)
              .refreshAllNewsFromDB();
        });

        Navigator.pop(context);
        // Save our form now.
      }
    } catch (e) {
      Scaffold.of(context).showSnackBar(
          const SnackBar(content: Text("התרחשה תקלה בשמירת  ההזמנה החדשה.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    var translation = AppLocalizations.of(context);
    txt = translation!.chooseImage;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade500,
        title: Text(translation.news),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.75,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Expanded(
                child: Theme(
                  data: ThemeData(
                      colorScheme: ColorScheme.light(
                          primary: Colors.green.shade500,
                          secondary: Colors.lightBlue.shade300)),
                  child: Stepper(
                    controlsBuilder: (context, _) {
                      return Row(
                        children: <Widget>[
                          TextButton(
                            onPressed: () {
                              if (_currentStep == 2)
                                submit();
                              else
                                continued();
                            },
                            child: Text(_currentStep == 2
                                ? translation.save
                                : translation.proceed),
                          ),
                          TextButton(
                            onPressed: () {
                              switch (_currentStep) {
                                case 0:
                                  Provider.of<NavigationController>(context,
                                          listen: false)
                                      .changeScreen('/');
                                  break;
                                default:
                                  back();
                                  break;
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
                        title: Text(translation.product),
                        content: Column(
                          children: <Widget>[
                            Switch(
                              value: (_data.active == null || _data.active!)
                                  ? true
                                  : false,
                              onChanged: (value) {
                                setState(() {
                                  _data.active = value;
                                });
                              },
                              activeTrackColor: Colors.green.shade200,
                              activeColor: Colors.green,
                            ),
                            TextFormField(
                              initialValue: _data.desc,
                              onChanged: (value) {
                                _data.desc = value;
                              },
                              keyboardType: TextInputType.multiline,
                              maxLines: 6,
                              decoration: InputDecoration.collapsed(
                                  hintText: translation.writeDescription),
                            ),
                            TextButton(
                              onPressed: () async {
                                await getImage();
                                if (_image != null) {
                                  setState(() {
                                    //   uploadImageFile(_image!);
                                  });
                                }
                              },
                              child:
                                  // currentImg == 'http://localhost.com' ||
                                  //         currentImg == null ||
                                  //         currentImg == ""
                                  _image == null
                                      ? _data.url == null || _data.url == ""
                                          ? Text(txt)
                                          : SizedBox(
                                              height: 75,
                                              width: 75,
                                              //child: Image.network(currentImg)
                                              child: Image.network(_data.url!))
                                      : SizedBox(
                                          height: 75,
                                          width: 75,
                                          //child: Image.network(currentImg)
                                          child: Image.file(_image!)),
                            ),
                          ],
                        ),
                        isActive: _currentStep >= 0,
                        state: _currentStep >= 0
                            ? StepState.complete
                            : StepState.disabled,
                      ),
                      Step(
                        title: Text(translation.description),
                        content: Column(
                          children: <Widget>[
                            DropdownButtonFormField(
                                value: _data.productId,
                                items: Provider.of<EntityModification>(context)
                                    .products
                                    .where((element) => element.active == true)
                                    .map((Product prod) {
                                  return DropdownMenuItem(
                                      value: prod.id,
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.category,
                                            size: 14,
                                            color: Colors.green.shade500,
                                          ),
                                          const Text(' '),
                                          Text(
                                            prod.name!,
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
                                      _data.active = true;
                                      _data.productId =
                                          int.parse(newValue.toString());
                                    });
                                  } catch (e) {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                        content: Text(
                                            translation.errorDisplayAccount)));
                                  }
                                },
                                decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.only(right: 8))),
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
                            _data == null
                                ? Container()
                                : ClientNewsCard(
                                    news: _data,
                                  )
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
      // _data.id = 0;
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
