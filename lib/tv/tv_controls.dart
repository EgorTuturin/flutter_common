import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_common/tv/key_code.dart';

mixin BaseTVControls {
  bool nodeAction(FocusScopeNode scope, FocusNode node, RawKeyEvent event,
      [void Function() onEnter]) {
    if (event is RawKeyDownEvent && event.data is RawKeyEventDataAndroid) {
      final RawKeyDownEvent rawKeyDownEvent = event;
      final RawKeyEventDataAndroid rawKeyEventDataAndroid = rawKeyDownEvent.data;
      switch (rawKeyEventDataAndroid.keyCode) {
        case ENTER:
        case KEY_CENTER:
          onEnter?.call();
          break;
        case KEY_UP:
          scope.focusInDirection(TraversalDirection.up);
          break;
        case KEY_DOWN:
          scope.focusInDirection(TraversalDirection.down);
          break;
        case KEY_RIGHT:
          scope.focusInDirection(TraversalDirection.right);
          break;
        case KEY_LEFT:
          scope.focusInDirection(TraversalDirection.left);
          break;
        default:
          break;
      }
    }
    return node.hasFocus;
  }
}
