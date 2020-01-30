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

  int _maxItemCount;
  List<List<Widget>> rows = [];
  double _vertPadding;
  double _horPadding;

  @override
  Widget build(BuildContext context) {
    _vertPadding = verticalPadding ?? 0;
    _horPadding = horizontalPadding ?? 0;
    _maxItemCount = width ~/ (itemWidth + _horPadding);
    _splitRows();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: _vertPadding),
      child: ListView.separated(
          separatorBuilder: (context, index) => SizedBox(height: _vertPadding),
          itemCount: rows.length,
          itemBuilder: (context, index) {
            return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: rows[index]);
          })
    );
  }

  void _splitRows() {
    int i = 0;
    for (i = 0; i < children.length; i++) {
      List<Widget> row = [];
      for (int k = 0; k < _maxItemCount && i < children.length; k++) {
        row.add(children[i]);
        row.add(SizedBox(width: _horPadding));
        i++;
      }
      row.removeLast();
      rows.add(row);
    }
  }
}
