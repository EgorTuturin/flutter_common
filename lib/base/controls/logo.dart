import 'package:flutter/material.dart';

class CircleAssetLogo extends StatelessWidget {
  final String logoPath;
  final double size;

  CircleAssetLogo(this.logoPath, {this.size});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(double.maxFinite),
        child: Image.asset(logoPath, width: size, height: size));
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
