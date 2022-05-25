import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hardwarestore/services/django_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../components/admin/product_admin_list_component.dart';
import '../../components/user.dart';
import '../../models/imgbb_model.dart';
import '../../models/products.dart';
import '../../services/imgbb.dart';

class CreateNewProductForm extends StatefulWidget {
  final Product? item;
  const CreateNewProductForm({Key? key, this.item}) : super(key: key);

  @override
  State<CreateNewProductForm> createState() => _CreateNewProductFormState();
}

class _CreateNewProductFormState extends State<CreateNewProductForm> {
  bool delay = true;
  bool loading = false;
  String txt = 'Choose Image';
  Dio dio = Dio();
  late ImgbbResponseModel imgbbResponse;
  File? _image;
  final picker = ImagePicker();

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

  void uploadingImageViaImageUrl() async {
    setState(() {
      loading = true;
    });
    FormData formData =
        FormData.fromMap({"key": imgBBkey, "image": imageString});

    Response response =
        await dio.post("https://api.imgbb.com/1/upload", data: formData);
    if (response.statusCode != 400) {
      imgbbResponse = ImgbbResponseModel.fromJson(response.data);
      widget.item?.img = imgbbResponse.data?.displayUrl;

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

  void uploadImageFile(File _image, Product product) async {
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
      Provider.of<CurrentProductsUpdate>(context, listen: false)
          .products
          ?.where((element) => element.id == widget.item?.id)
          .first
          .img = imgbbResponse.data?.displayUrl;
      Product? _p = Provider.of<CurrentProductsUpdate>(context, listen: false)
          .products
          ?.where((element) => element.id == widget.item?.id)
          .first;

      DjangoServices().upsertProduct(_p!);
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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Product _data = Product();

  void submit() {
    // First validate form.
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      DjangoServices().upsertProduct(_data);
      Navigator.pop(context); // Save our form now.
    }
  }

  @override
  void initState() {
    try {
      if (widget.item != null) _data = widget.item!;
    }
    // ignore: empty_catches
    catch (e) {}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    String? currentImg = widget.item?.img;
    // Provider.of<CurrentProductsUpdate>(context, listen: false)
    //     .products
    //     ?.where((element) => element.id == widget.item?.id)
    //     .first
    //     .img;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product'),
      ),
      body: Container(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  initialValue: _data.name != null ? _data.name : "",
                  onSaved: (String? value) {
                    // ignore: unrelated_type_equality_checks
                    if (_data == null || _data.id == null || _data.id == 0) {
                      _data.id = 0;
                      _data.active = true;
                      _data.created_by =
                          Provider.of<GetCurrentUser>(context, listen: false)
                              .currentUser
                              ?.id;
                    }
                    _data.name = value;
                  },
                  decoration: const InputDecoration(
                      hintText: 'name', labelText: 'Name'),
                ),
                TextFormField(
                  initialValue: _data.category != null ? _data.category : "",
                  onSaved: (String? value) {
                    _data.category = value;
                  },
                  decoration: const InputDecoration(
                      hintText: 'category', labelText: 'Category'),
                ),
                TextFormField(
                  initialValue: _data.desc != null ? _data.desc : "",
                  onSaved: (String? value) {
                    _data.desc = value;
                  },
                  decoration: const InputDecoration(
                      hintText: 'description', labelText: 'Description'),
                ),
                TextFormField(
                  initialValue:
                      _data.discount != null ? _data.discount.toString() : "0",
                  onSaved: (String? value) {
                    // ignore: curly_braces_in_flow_control_structures
                    if (value != "") {
                      _data.discount = double.parse(value!);
                    }
                  },
                  decoration: const InputDecoration(
                      hintText: 'discount', labelText: 'discount'),
                ),
                TextFormField(
                  initialValue:
                      _data.price != null ? _data.price.toString() : "0",
                  onSaved: (String? value) {
                    _data.price = double.parse(value!);
                  },
                  decoration: const InputDecoration(
                      hintText: 'price', labelText: 'Price'),
                ),
                TextButton(
                  onPressed: () async {
                    await getImage();
                    if (_image != null) uploadImageFile(_image!, widget.item!);
                  },
                  child: currentImg == 'http://localhost.com' ||
                          currentImg == null ||
                          currentImg == ""
                      ? Text(txt)
                      : SizedBox(
                          height: 75,
                          width: 75,
                          child: Image.network(currentImg)),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Switch(
                    value: (_data == null || _data.id == null || _data.id == 0)
                        ? true
                        : _data.active!,
                    onChanged: (value) {
                      setState(() {
                        _data.active = value;
                      });
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  ),
                ),
                Container(
                  width: screenSize.width,
                  child: TextButton(
                    child: Text(
                      'Save',
                      style: _data.id == null ||
                              _data.name == null ||
                              _data.name == ""
                          ? const TextStyle(color: Colors.grey)
                          : const TextStyle(color: Colors.green),
                    ),
                    onPressed: _data.id == null ||
                            _data.name == null ||
                            _data.name == ""
                        ? null
                        : submit,
                  ),
                  margin: const EdgeInsets.only(top: 20.0),
                )
              ],
            ),
          )),
    );
  }
}