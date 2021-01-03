import 'package:flutter/material.dart';

class NonAvailableBuffer extends StatelessWidget {
  final String message;
  final IconData icon;
  final double iconSize;
  final double textSize;
  final double opacity;
  final Color color;

  const NonAvailableBuffer(
      {this.icon, this.iconSize, this.message, this.textSize, this.opacity, this.color});

  @override
  Widget build(BuildContext context) {
    final content = message == null
        ? const SizedBox()
        : Text(message,
            style: TextStyle(fontSize: textSize ?? 20, color: color),
            textAlign: TextAlign.center,
            softWrap: true);
    return Opacity(
        opacity: opacity ?? 0.5,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Icon(icon, size: iconSize ?? 96, color: color),
          SizedBox(height: (iconSize ?? 96) / 4),
          content
        ]));
  }
}
