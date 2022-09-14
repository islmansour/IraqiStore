import 'package:flutter/material.dart';
import 'package:hardwarestore/models/news.dart';
import 'package:hardwarestore/models/products.dart';
import 'package:hardwarestore/screens/admin/new_news.dart';
import 'package:hardwarestore/services/tools.dart';
import 'package:hardwarestore/widgets/client/product_display_client.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ClientNewsCard extends StatefulWidget {
  News? news;
  ClientNewsCard({Key? key, this.news}) : super(key: key);

  @override
  State<ClientNewsCard> createState() => _ClientNewsCardState();
}

class _ClientNewsCardState extends State<ClientNewsCard> {
  @override
  Widget build(BuildContext context) {
    String? img = widget.news!.url;
    DateTime? _created = widget.news!.created;
    Product? _prod;
    if (widget.news!.productId != null) {
      try {
        _prod = Provider.of<EntityModification>(context)
            .products
            .where((element) => element.id == widget.news!.productId)
            .first;
      } catch (e) {}
    }

    return Card(
      child: Container(
        width: double.infinity,
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _created != null
                ? Container(
                    child: Text(
                        DateFormat('dd/MM/yy hh:mm')
                            .format(widget.news!.created!),
                        style: Theme.of(context).textTheme.labelSmall),
                  )
                : Container(),
            Container(
              padding: EdgeInsets.only(right: 8, top: 8),
              alignment: Alignment.topRight,
              child: Text(
                widget.news == null || widget.news!.desc == null
                    ? ""
                    : widget.news!.desc!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Expanded(
              child: _prod == null
                  ? Container(
                      alignment: Alignment.center,
                      // width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: img == 'http://localhost.com' ||
                              img == null ||
                              img == ""
                          ? Icon(
                              Icons.broken_image,
                              size: 100,
                              color: Colors.grey,
                            )
                          : SizedBox(
                              child: Image.network(img, errorBuilder:
                                  (BuildContext context, Object exception,
                                      StackTrace? stackTrace) {
                                // Appropriate logging or analytics, e.g.
                                // myAnalytics.recordError(
                                //   'An error occurred loading "https://example.does.not.exist/image.jpg"',
                                //   exception,
                                //   stackTrace,
                                // );
                                return const Text('');
                              }),
                            ),
                    )
                  : DisplayProductClientLarge(
                      discount: _prod.discount.toString(),
                      img: _prod.img,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
