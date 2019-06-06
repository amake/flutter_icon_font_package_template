import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_icon_font_package_template/custom_font.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Icon Font Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        iconTheme: IconThemeData.fallback(), //.copyWith(size: 48),
      ),
      home: MyHomePage(title: 'Icon Font vs SVG Test'),
    );
  }
}

final _random = Random();
Color _randomColor() => Color(_random.nextInt(0xFFFFFFFF));

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(text: 'TTF', icon: Icon(CustomFontIcons.uE000)),
              Tab(text: 'SVG', icon: SvgIcon('assets/images/ei-heart.svg')),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            InfiniteIcons(
                () => Icon(CustomFontIcons.uE000, color: _randomColor())),
            InfiniteIcons(() =>
                SvgIcon('assets/images/ei-heart.svg', color: _randomColor())),
          ],
        ),
      ),
    );
  }
}

class SvgIcon extends StatelessWidget {
  final String assetName;
  final Color color;

  SvgIcon(this.assetName, {this.color});

  @override
  Widget build(BuildContext context) {
    final size = IconTheme.of(context).size;
    final iconColor = color ?? IconTheme.of(context).color;
    return SvgPicture.asset(assetName,
        width: size, height: size, color: iconColor);
  }
}

typedef Widget IconGen();

class InfiniteIcons extends StatelessWidget {
  final IconGen gen;

  InfiniteIcons(this.gen);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
        itemBuilder: (context, i) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _iconRow(context).toList(),
          );
        },
      ),
    );
  }

  Iterable<Widget> _iconRow(BuildContext context) sync* {
    final count =
        MediaQuery.of(context).size.width ~/ IconTheme.of(context).size;
    for (var i = 0; i < count; i++) {
      yield gen();
    }
  }
}
