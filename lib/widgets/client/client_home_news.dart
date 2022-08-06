import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:hardwarestore/services/tools.dart';
import 'package:hardwarestore/widgets/client/client_news_card.dart';
import 'package:provider/provider.dart';

class ClientHomeNews extends StatefulWidget {
  ClientHomeNews({Key? key}) : super(key: key);

  @override
  State<ClientHomeNews> createState() => _ClientHomeNewsState();
}

class _ClientHomeNewsState extends State<ClientHomeNews> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: MediaQuery.of(context).size.width,
      child: CarouselSlider(
          options: CarouselOptions(
            height: 300,
            autoPlay: true,
            aspectRatio: 2.0,
            enlargeCenterPage: true,
          ),
          items: GetNewsCards(context)),
    );
  }
}

List<Widget> GetNewsCards(BuildContext context) {
  List<Widget> newsCards = <Widget>[];

  Provider.of<EntityModification>(context).activeNews.forEach((element) {
    newsCards.add(ClientNewsCard(news: element));
  });

  return newsCards;
}
