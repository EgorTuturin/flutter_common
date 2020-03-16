import 'package:flutter/material.dart';

class CustomWrap extends StatelessWidget {
  final double width;
  final double itemWidth;
  final double horizontalPadding;
  final double verticalPadding;
  final ScrollController scrollController;
  final List<Widget> children;

  CustomWrap(
      {@required this.width,
      @required this.itemWidth,
      @required this.children,
      this.horizontalPadding,
      this.verticalPadding,
      this.scrollController});

  @override
  Widget build(BuildContext context) {
    double vertPadding = verticalPadding ?? 0;
    double horPadding = horizontalPadding ?? 0;

    final int maxItemCountPerRow = (width ~/ (itemWidth + horPadding));
    List<List<Widget>> rows = [];
    for (int i = 0; i < children.length; i += maxItemCountPerRow) {
      List<Widget> row = [];
      for (int k = 0; k < maxItemCountPerRow; k++) {
        row.add(children[i + k]);
        final box = SizedBox(width: horPadding);
        row.add(box);
      }
      row.removeLast();
      rows.add(row);
    }
    return Padding(
        padding: EdgeInsets.symmetric(vertical: vertPadding),
        child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: vertPadding),
            itemCount: rows.length,
            itemBuilder: (context, index) {
              final row = Row(
                  mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max, children: rows[index]);
              return row;
            }));
  }
}
