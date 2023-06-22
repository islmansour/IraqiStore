import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';

import '../services/api.dart';

class ShowPDF extends StatefulWidget {
  // 'http://127.0.0.1:8000/getPDF/' + widget.link!,
  final String? link;
  const ShowPDF({Key? key, required this.link}) : super(key: key);

  @override
  _ShowPDFState createState() => _ShowPDFState();
}

class _ShowPDFState extends State<ShowPDF> {
  bool _isLoading = true;
  PDFDocument? document;

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    //document = await PDFDocument.fromAsset('assets/sample.pdf');
    changePDF(1);
    setState(() => _isLoading = false);
  }

  changePDF(value) async {
    setState(() => _isLoading = true);
    document = await PDFDocument.fromURL(
      '${ApiBaseHelper().apiURL}/IraqiStore/getPDF/' + widget.link!,
      /* cacheManager: CacheManager(
          Config(
            "customCacheKey",
            stalePeriod: const Duration(days: 2),
            maxNrOfCacheObjects: 10,
          ),
        ), */
    );
    setState(() => _isLoading = false);

    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    try {
      final Uri _url = Uri.parse(
          '${ApiBaseHelper().apiURL}:8000/IraqiStore/getPDF/' + widget.link!);
      // void _launchUrl() async {
      //   if (!await launchUrl(_url, webOnlyWindowName: "_blank"))
      //     throw 'Could not launch $_url';
      // }
    } catch (e) {
      return Container();
    }

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: _isLoading || document == null
            ? const Center(child: CircularProgressIndicator())
            : SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: PDFViewer(
                  document: document!,
                  //  zoomSteps: 1,
                ),
              ),
      ),
    );
  }
}
