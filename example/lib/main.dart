import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_icon_font_package_template/custom_font.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

final _random = Random();

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: ListView.builder(
          itemBuilder: (context, i) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ..._iconRow(MediaQuery.of(context).size.width ~/
                    IconTheme.of(context).size)
              ],
            );
          },
        ),
      ),
    );
  }

  Iterable<Widget> _iconRow(int count) sync* {
    for (var i = 0; i < count; i++) {
      yield Icon(CustomFontIcons.uE000,
          color: Color(_random.nextInt(0xFFFFFFFF)));
    }
  }
}
