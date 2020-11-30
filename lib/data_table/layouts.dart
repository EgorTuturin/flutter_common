import 'package:flutter/material.dart';
import 'package:flutter_common/data_table/data_source.dart';
import 'package:flutter_common/data_table/table.dart';
import 'package:flutter_common/scrollable.dart';

class DataLayout<T> extends StatelessWidget {
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
  Widget build(BuildContext context) {
    if (canScrollTable) {
      return ScrollableEx.withBar(builder: (controller) {
        return SingleChildScrollView(controller: controller, child: _content());
      });
    } else {
      return _content();
    }
  }

  Widget _content() {
    return title == null ? _table() : _withTitle();
  }

  Widget _withTitle() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[_title(), _table()]);
  }

  Widget _table() {
    return DataTableEx(dataSource, header, _actions);
  }

  Widget _title() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)));
  }

  List<Widget> _actions() {
    if (dataSource.selectedRowCount == 1) {
      return singleItemActions(dataSource.selectedItems().first);
    } else if (dataSource.selectedRowCount > 1) {
      return multipleItemActions(dataSource.selectedItems());
    }
    return [];
  }
}
