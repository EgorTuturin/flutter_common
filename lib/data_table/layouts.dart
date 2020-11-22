import 'package:flutter_common/data_table/data_source.dart';
import 'package:flutter_common/data_table/table.dart';
import 'package:flutter_common/scroll/scrollview.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class DataLayout<T> extends StatefulWidget {
  final DataSource<T> dataSource;
  final Widget header;
  final List<Widget> Function(T) singleItemActions;
  final List<Widget> Function(List<T>) multipleItemActions;
  final bool canScrollTable;
  final String title;

  DataLayout(
      {@required this.dataSource,
      @required this.header,
      @required this.singleItemActions,
      @required this.multipleItemActions,
      bool canScrollTable})
      : canScrollTable = canScrollTable ?? false,
        title = null;

  DataLayout.withHeader(
      {@required this.dataSource,
      @required this.header,
      @required this.title,
      @required this.singleItemActions,
      @required this.multipleItemActions,
      bool canScrollTable})
      : canScrollTable = canScrollTable ?? false;

  @override
  _DataLayoutState<T> createState() => _DataLayoutState<T>();
}

class _DataLayoutState<T> extends State<DataLayout<T>> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizingInformation) {
      if (widget.canScrollTable) {
        return CustomSingleChildScrollView(child: widget.title == null ? _table() : _withTitle());
      } else {
        return widget.title == null ? _table() : _withTitle();
      }
    });
  }

  // private:
  Widget _withTitle() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[_title(), _table()]);
  }

  Widget _table() {
    return DataTableEx(widget.dataSource, widget.header, _actions);
  }

  Widget _title() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(widget.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)));
  }

  List<Widget> _actions() {
    if (widget.dataSource.selectedRowCount == 1) {
      return widget.singleItemActions(widget.dataSource.selectedItems().first);
    } else if (widget.dataSource.selectedRowCount > 1) {
      return widget.multipleItemActions(widget.dataSource.selectedItems());
    }
    return [];
  }
}
