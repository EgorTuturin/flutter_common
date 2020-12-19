import 'package:flutter/material.dart';

class CustomScrollController {
  final int _scrollDurationMs;
  final double _itemHeight;
  final double _initialOffset;
  ScrollController _scrollController;

  CustomScrollController(
      {int scrollDurationMs = 100, double itemHeight = 0.0, double initOffset = 0.0})
      : _scrollDurationMs = scrollDurationMs,
        _itemHeight = itemHeight,
        _initialOffset = initOffset {
    _scrollController = ScrollController(initialScrollOffset: _initialOffset);
  }

  ScrollController get controller => _scrollController;

  double get itemHeight => _itemHeight;

  void _scrollTo(double offset) {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(offset,
          curve: Curves.linear, duration: Duration(milliseconds: _scrollDurationMs));
    }
  }

  void _jumpTo(double offset) {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(offset);
    }
  }

  void moveToTop() => _scrollTo(_scrollController.position.minScrollExtent);

  void moveToBottom() => _scrollTo(_scrollController.position.maxScrollExtent);

  void moveUp() => _scrollTo(_scrollController.offset - _itemHeight);

  void moveDown() => _scrollTo(_scrollController.offset + _itemHeight);

  void jumpUp() => _jumpTo(_scrollController.offset - _itemHeight);

  void jumpDown() => _jumpTo(_scrollController.offset + _itemHeight);

  void moveToPosition(int position) =>
      _scrollTo(_scrollController.position.minScrollExtent + position * _itemHeight);

  void jumpToPosition(int position) =>
      _jumpTo(_scrollController.position.minScrollExtent + position * _itemHeight);

  void dispose() {
    _scrollController?.dispose();
  }
}
