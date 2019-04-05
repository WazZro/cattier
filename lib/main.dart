import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:Catify/widgets/CatList.dart';

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
                  ))),
          home: CatListWidget()),
    );
