import 'package:flutter/material.dart';

class CustomWrap extends StatefulWidget {
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
  _CustomWrapState createState() => _CustomWrapState();
}

class _CustomWrapState extends State<CustomWrap> {
  int _maxItemCount;
  List<List<Widget>> rows = [];
  double _vertPadding;
  double _horPadding;

  @override
  void initState() {
    super.initState();
    _vertPadding = widget.verticalPadding ?? 0;
    _horPadding = widget.horizontalPadding ?? 0;
    _maxItemCount = widget.width ~/ (widget.itemWidth + _horPadding);
    _splitRows();
  }

  @override
  Widget build(BuildContext context) {
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
    for (i = 0; i < widget.children.length; i++) {
      List<Widget> row = [];
      for (int k = 0; k < _maxItemCount && i < widget.children.length; k++) {
        row.add(widget.children[i]);
        row.add(SizedBox(width: _horPadding));
        i++;
      }
      row.removeLast();
      rows.add(row);
    }
  }
}
