import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cached_network_image/cached_network_image.dart';
import 'Cat.dart';
import 'dart:convert';

class MainWidget extends StatefulWidget {
  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  List<Cat> cats = List();
  var isLoading = false;
  _MainWidgetState();
  _MainWidgetState.forDesignTime();

  _fetchData() async {
    setState(() {
      isLoading = true;
    });

    final response =
        await http.get('https://api.thecatapi.com/v1/breeds', headers: {
      'x-api-key': 'f99ea0d4-02dc-478c-8766-87cd0e559677',
    });

    if (response.statusCode == 200) {
      var catIds = json.decode(response.body) as List;
      var futures = <Future>[];
      for (var c in catIds) {
        var res = http.get(
            'https://api.thecatapi.com/v1/images/search?breed_id=' + c['id'],
            headers: {
              'x-api-key': 'f99ea0d4-02dc-478c-8766-87cd0e559677',
            });
        futures.add(res);
      }

      var res = await Future.wait(futures);
      for (var x in res) {
        var xx = json.decode(x.body)[0];
        var cat = Cat.fromJson(xx);
        cats.add(cat);
      }

//      cats = Cat.getCatsFromJson(json.decode(response.body) as List);
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load cats');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchData();
  }

  showDetailedPage(Cat cat) {
    Navigator.of(context).push(new CupertinoPageRoute(
        title: cat.name,
        builder: (context) {
          return AboutPageWidget(cat);
        }));
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: Colors.white,
        navigationBar: CupertinoNavigationBar(
          backgroundColor: Colors.white30,
          middle: Text(
            'Cattier',
            style: TextStyle(
              color: Colors.teal,
              fontFamily: 'ProximaNovaSoft',
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        child: isLoading
            ? Center(child: CupertinoActivityIndicator())
            : ListView.builder(
                itemCount: cats.length,
                itemBuilder: (BuildContext context, int index) {
                  return new GestureDetector(
                      onTap: () => showDetailedPage(cats[index]),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: new BorderRadius.circular(16.0),
                              child:
                                CachedNetworkImage(
                                    imageUrl: cats[index].imageUrl,
//                                    width: 592,
//                                    height: 444,
                                    placeholder: (context, url) => Image.asset(
                                      'asset/default-placeholder.png',
                                    ),
                                )
                            ),
                            Text(
                              cats[index].name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 32,
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  cats[index].temperament,
                                  textAlign: TextAlign.center,
//                                  overflow: TextOverflow.ellipsis,
                                ))
                          ],
                        ),
                      ));
                },
              ));
  }
}

class AboutPageWidget extends StatefulWidget {
  final Cat cat;

  AboutPageWidget(this.cat);

  @override
  _AboutPageWidgetState createState() => _AboutPageWidgetState();
}

class _AboutPageWidgetState extends State<AboutPageWidget> {
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
              new SizedBox(
                height: 200.0,
                child: new _FeaturedBar(widget.cat),
              )
            ])));
  }
}

class _FeaturedBar extends StatelessWidget {
  Cat cat;
  List<charts.Series<ParamData, String>> seriesList;

  _FeaturedBar(Cat cat) {
    this.cat = cat;

    final data = [
      new ParamData('Intelligence', cat.intelligence),
      new ParamData('Energy', cat.energyLevel),
      new ParamData('Health', cat.sheddingLevel),
    ];

    seriesList = [
      new charts.Series<ParamData, String>(
        id: 'cat_params',
        measureLowerBoundFn: (ParamData sales, _) => 0,
        measureUpperBoundFn: (ParamData sales, _) => 5,
        domainFn: (ParamData sales, _) => sales.name,
        measureFn: (ParamData sales, _) => sales.level,
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

class ParamData {
  final String name;
  final int level;

  ParamData(
    this.name,
    this.level,
  );
}

void main() => runApp(
      CupertinoApp(
          title: 'Cattier',
          theme: CupertinoThemeData(
              primaryColor: Colors.teal,
              textTheme: CupertinoTextThemeData(
                  primaryColor: Colors.teal,
                  textStyle: TextStyle(
                    color: Colors.teal,
                    fontFamily: 'ProximaNovaSoft',
                    fontSize: 24.0,
//                fontWeight: FontWeight.bold,
                  ))),
          home: MainWidget()),
    );
