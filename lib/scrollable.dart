import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_common/colors.dart';

typedef ScrollableBuilder = Widget Function(ScrollController);

class ScrollBarConfig {
  double scrollbarWidth;
  Color scrollbarBackgroundColor;
  double thumbHeight;
  double thumbHorizontalPadding;
  BoxDecoration decoration;

  ScrollBarConfig(
      {this.scrollbarWidth = 18,
      this.scrollbarBackgroundColor,
      this.thumbHeight = 56,
      this.thumbHorizontalPadding = 0,
      this.decoration});
}

class ScrollableEx extends StatefulWidget {
  static const double ARROW_EVENT_OFFSET = 50;
  final ScrollController controller;
  final ScrollableBuilder builder;
  final bool overlayContent;
  final ScrollBarConfig scrollBarConfig;

  const ScrollableEx({@required this.builder, this.controller, Key key})
      : scrollBarConfig = null,
        overlayContent = false,
        super(key: key);

  ScrollableEx.withBar(
      {@required this.builder,
      this.controller,
      this.overlayContent = false,
      ScrollBarConfig scrollBarConfig,
      Key key})
      : scrollBarConfig = scrollBarConfig ?? ScrollBarConfig(),
        super(key: key);

  @override
  _ScrollableExState createState() {
    return _ScrollableExState();
  }
}

class _ScrollableExState extends State<ScrollableEx> {
  final FocusNode _node = FocusNode();
  ScrollController _controller;
  final ScrollBarConfig _config = ScrollBarConfig();

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    }
    _node.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
        autofocus: true,
        focusNode: _node,
        onKey: (event) {
          _handleEvent(context, event);
        },
        child: _content());
  }

  Widget _content() {
    if (widget.scrollBarConfig == null) {
      return widget.builder(_controller);
    }

    return LayoutBuilder(builder: (context, constraints) {
      return MediaQuery(
          data: MediaQuery.of(context).copyWith(size: constraints.biggest),
          child: Stack(children: [
            Container(
                child: widget.builder(_controller),
                margin: EdgeInsets.only(right: widget.overlayContent ? 0 : _config.scrollbarWidth)),
            _FlutterWebScroller(_controller, config: _config)
          ]));
    });
  }

  void _handleEvent(BuildContext context, RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.pageUp) {
        _moveTo(-MediaQuery.of(context).size.height);
      } else if (event.logicalKey == LogicalKeyboardKey.pageDown) {
        _moveTo(MediaQuery.of(context).size.height);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        _moveTo(-ScrollableEx.ARROW_EVENT_OFFSET);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        _moveTo(ScrollableEx.ARROW_EVENT_OFFSET);
      } else if (event.logicalKey == LogicalKeyboardKey.home) {
        _moveTo(-_controller.position.maxScrollExtent);
      } else if (event.logicalKey == LogicalKeyboardKey.end) {
        _moveTo(_controller.position.maxScrollExtent);
      }
    }
  }

  void _moveTo(double offset) {
    double newOffset = 0;
    final double currentOffset = _controller.offset;
    final double maxOffset = _controller.position.maxScrollExtent;
    if (offset <= 0 && currentOffset + offset <= 0) {
      newOffset = 0;
    } else if (offset >= 0 && (currentOffset + offset >= maxOffset)) {
      newOffset = maxOffset;
    } else {
      newOffset = currentOffset + offset;
    }
    _controller.position.moveTo(newOffset);
  }
}

class _FlutterWebScroller extends StatefulWidget {
  final ScrollController controller;
  final ScrollBarConfig config;

  const _FlutterWebScroller(this.controller, {this.config});

  @override
  State<StatefulWidget> createState() {
    return _FlutterWebScrollerState();
  }
}

class _FlutterWebScrollerState extends State<_FlutterWebScroller> with WidgetsBindingObserver {
  BoxDecoration _decoration;
  double _offset = 0;
  double _fixCursorPosition = 0;
  double _scrollExtent;

  ScrollBarConfig get _config => widget.config ?? ScrollBarConfig();

  double get maxOffset => MediaQuery.of(context).size.height - _calcThumbHeight();

  Color get background =>
      _config.scrollbarBackgroundColor ?? Theme.of(context).colorScheme.background;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScroll);
    WidgetsBinding.instance.addObserver(this);
    _updateExtent();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _decoration = widget.config.decoration ??
        BoxDecoration(
            color: backgroundColorBrightness(background,
                onLight: Colors.black26, onDark: Colors.white24),
            borderRadius: BorderRadius.all(Radius.circular(_config.scrollbarWidth / 4)));
  }

  @override
  void didUpdateWidget(_FlutterWebScroller oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateExtent();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    _updateExtent();
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(_onScroll);
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerRight,
        height: MediaQuery.of(context).size.height,
        width: _config.scrollbarWidth,
        color: background,
        margin: EdgeInsets.only(left: MediaQuery.of(context).size.width - _config.scrollbarWidth),
        child: Container(
            alignment: Alignment.topCenter,
            child: GestureDetector(
                child: _thumbBuilder(),
                onVerticalDragStart: _onDragStart,
                onVerticalDragUpdate: _onDrag)));
  }

  Widget _thumbBuilder() {
    return Container(
        height: _calcThumbHeight(),
        margin: EdgeInsets.only(
            left: _config.thumbHorizontalPadding,
            right: _config.thumbHorizontalPadding,
            top: _offset),
        decoration: _decoration);
  }

  void _onDragStart(DragStartDetails details) {
    _fixCursorPosition = details.globalPosition.dy - _offset;
  }

  void _onDrag(DragUpdateDetails dragUpdate) {
    final double dy = dragUpdate.globalPosition.dy - _fixCursorPosition;
    final double scrollTo = dy * _scrollExtent / maxOffset;
    widget.controller.position.moveTo(scrollTo);
  }

  void _onScroll() {
    setState(() {
      if (_scrollExtent == 0) {
        _offset = 0;
      } else {
        _offset = widget.controller.offset * maxOffset / _scrollExtent;
        _offset = (_offset > maxOffset) ? maxOffset : _offset;
      }
    });
  }

  double _calcThumbHeight() {
    if (_scrollExtent == null) {
      return double.maxFinite;
    } else if (_scrollExtent == 0) {
      return double.maxFinite;
    }
    final double numberOfPages = 1 + _scrollExtent / MediaQuery.of(context).size.height;
    double thumbHeight = MediaQuery.of(context).size.height / numberOfPages;

    if (thumbHeight < _config.scrollbarWidth) {
      thumbHeight = _config.scrollbarWidth;
    }
    return thumbHeight;
  }

  void _updateExtent() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollExtent = widget.controller.position.maxScrollExtent;
      setState(() {});
    });
  }
}
