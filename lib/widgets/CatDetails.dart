import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:Catify/models/Cat.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CatDetailsWidget extends StatefulWidget {
  final Cat cat;

  CatDetailsWidget(this.cat);

  @override
  _CatDetailsWidgetState createState() => _CatDetailsWidgetState();
}

class _CatDetailsWidgetState extends State<CatDetailsWidget> {
  List images;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    images = map<Widget>(widget.cat.images, (index, i) {
      return Container(
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          child: CachedNetworkImage(
            imageUrl: i,
            height: 444,
            width: 562,
            placeholder: (context, url) => Image.asset(
                  'asset/default-placeholder.png',
                ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            backgroundColor: Colors.white30,
            middle: Text(
              widget.cat.name,
              style: TextStyle(
                color: Colors.teal,
                fontFamily: 'ProximaNovaSoft',
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            )),
        child: Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: ListView(padding: const EdgeInsets.all(16), children: [
              CarouselSlider(
                items: images,
                enableInfiniteScroll: false,
                autoPlay: false,
                enlargeCenterPage: true,
                viewportFraction: 0.9,
                aspectRatio: 16/9,
//                height: 300.0,
              ),
              new SizedBox(
                height: 200.0,
                child: new _FeaturedBar(cat: widget.cat),
              ),
              Text.rich(TextSpan(
                  text: 'Description: ',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                  children: [
                    TextSpan(
                        text: widget.cat.description,
                        style: TextStyle(fontWeight: FontWeight.normal))
                  ])),
              Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text.rich(TextSpan(
                    text: 'Origin: ',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                    children: [
                      TextSpan(
                          text: widget.cat.origin,
                          style: TextStyle(fontWeight: FontWeight.normal))
                    ])),
              ),
//              Padding(
//                padding: EdgeInsets.only(top: 8.0),
//                child: Text.rich(TextSpan(
//                    text: 'Life span: ',
//                    style: TextStyle(
//                      fontWeight: FontWeight.w700,
//                    ),
//                    children: [
//                      TextSpan(
//                          text: widget.cat,
//                          style: TextStyle(fontWeight: FontWeight.normal))
//                    ])),
//              ),
            ])));
  }
}

class _FeaturedBar extends StatelessWidget {
  final cat;
  List images;
  List<charts.Series<_ParamData, String>> seriesList;

  _FeaturedBar({this.cat}) {
    final data = [
      new _ParamData('Intelligence', cat.intelligence),
      new _ParamData('Energy', cat.energyLevel),
      new _ParamData('Health', cat.sheddingLevel),
      new _ParamData('Adaptability', cat.adaptability),
      new _ParamData('Affection', cat.affectionLevel),
    ];

    seriesList = [
      new charts.Series<_ParamData, String>(
        id: 'cat_params',
        measureLowerBoundFn: (_ParamData sales, _) => 0,
        measureUpperBoundFn: (_ParamData sales, _) => 5,
        domainFn: (_ParamData sales, _) => sales.name,
        measureFn: (_ParamData sales, _) => sales.level,
        data: data,
        fillColorFn: (_, __) => charts.MaterialPalette.cyan.shadeDefault,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new charts.BarChart(
      seriesList,
      primaryMeasureAxis: new charts.NumericAxisSpec(
          renderSpec: new charts.GridlineRendererSpec(
              labelStyle: new charts.TextStyleSpec(
                  fontSize: 18, // size in Pts.
                  color: charts.MaterialPalette.transparent),
              lineStyle: new charts.LineStyleSpec(
                  color: charts.MaterialPalette.transparent))),
      domainAxis: new charts.OrdinalAxisSpec(
          renderSpec: new charts.SmallTickRendererSpec(
              labelStyle: new charts.TextStyleSpec(
                  fontSize: 18, // size in Pts.
                  color: charts.MaterialPalette.teal.shadeDefault),
              lineStyle: new charts.LineStyleSpec(
                  color: charts.MaterialPalette.transparent))),
      vertical: false,
      animate: false,
    );
  }
}

class _ParamData {
  final String name;
  final int level;

  _ParamData(
    this.name,
    this.level,
  );
}

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }

  return result;
}
