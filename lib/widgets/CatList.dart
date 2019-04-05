import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:Catify/models/Cat.dart';
import 'package:Catify/widgets/CatDetails.dart';
import 'dart:convert';

class CatListWidget extends StatefulWidget {
  @override
  _CatListWidgetState createState() => _CatListWidgetState();
}

class _CatListWidgetState extends State<CatListWidget> {
  List<Cat> cats = List();
  var isLoading = false;
  _CatListWidgetState();

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
          return CatDetailsWidget(cat);
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
                                child: CachedNetworkImage(
                                  imageUrl: cats[index].imageUrl,
                                  placeholder: (context, url) => Image.asset(
                                        'asset/default-placeholder.png',
                                      ),
                                )),
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
