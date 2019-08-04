import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_icon_font_package_template/custom_font.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fps/fps.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Icon Font Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        iconTheme: const IconThemeData.fallback(), //.copyWith(size: 48),
      ),
      home: const MyHomePage(title: 'Icon Font vs SVG Test'),
    );
  }
}

final _random = Random();
Color _randomColor() => Color(_random.nextInt(0xFFFFFFFF));

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(text: 'TTF', icon: Icon(CustomFontIcons.heart)),
              Tab(text: 'SVG', icon: SvgIcon('assets/images/ei-heart.svg')),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            InfiniteIcons(
                () => Icon(CustomFontIcons.heart, color: _randomColor())),
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

  const SvgIcon(this.assetName, {this.color});

  @override
  Widget build(BuildContext context) {
    final size = IconTheme.of(context).size;
    final iconColor = color ?? IconTheme.of(context).color;
    return SvgPicture.asset(assetName,
        width: size, height: size, color: iconColor);
  }
}

typedef IconGen = Widget Function();

class InfiniteIcons extends StatelessWidget {
  final IconGen gen;

  const InfiniteIcons(this.gen);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          ListView.builder(
            itemBuilder: (context, i) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _iconRow(context).toList(),
              );
            },
          ),
          const Positioned(
            right: 0,
            top: 0,
            child: FpsCounter(),
          ),
        ],
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

class FpsCounter extends StatelessWidget {
  const FpsCounter();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(2)),
        color: Colors.black.withOpacity(0.6),
      ),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      child: StreamBuilder<num>(
        stream: eachFrame().transform(const ComputeFps()),
        builder: (context, snapshot) {
          return Text(
            '${snapshot.data?.round() ?? '?'} fps',
            style: const TextStyle(
              color: Colors.white,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          );
        },
      ),
    );
  }
}
