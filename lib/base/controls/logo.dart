import 'package:flutter/material.dart';

class CircleAssetLogo extends StatelessWidget {
  final String logoPath;
  final double radius;

  CircleAssetLogo(this.logoPath, {this.radius = 48.0});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(backgroundColor: Colors.transparent, radius: radius, child: Image.asset(logoPath));
  }
}

class CustomAssetLogo extends StatelessWidget {
  final String logoPath;
  final double width;
  final double height;

  CustomAssetLogo(this.logoPath, {this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Image.asset(logoPath, width: width, height: height);
  }
}
