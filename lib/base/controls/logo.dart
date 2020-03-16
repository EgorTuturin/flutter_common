import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final String logoPath;

  Logo(this.logoPath);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(backgroundColor: Colors.transparent, radius: 48.0, child: Image.asset(logoPath));
  }
}
