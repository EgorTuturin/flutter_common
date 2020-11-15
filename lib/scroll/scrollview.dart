import 'package:flutter/material.dart';
import 'package:flutter_common/scroll/draggable_scrollbar.dart';

class CustomSingleChildScrollView extends StatelessWidget {
  final Widget child;

  CustomSingleChildScrollView({@required this.child});

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollbar.arrows(
        alwaysVisibleScrollThumb: true,
        padding: EdgeInsets.all(8),
        controller: _scrollController,
        backgroundColor: Theme.of(context).accentColor,
        child: SingleChildScrollView(
            controller: _scrollController, child: Padding(padding: const EdgeInsets.all(8.0), child: child)));
  }
}
