import 'package:flutter/material.dart';
import 'package:flutter_common/table.dart';
import 'package:flutter_common/data_table/data_source.dart';

class DataTableEx extends StatefulWidget {
  final DataSource source;
  final Widget header;
  final Widget Function() actionsWidget;
  final List<Widget> Function() actions;

  DataTableEx(this.source, this.header, this.actions) : actionsWidget = null;

  DataTableEx.customActions(this.source, this.header, this.actionsWidget) : actions = null;

  @override
  DataTableExState createState() => DataTableExState();
}

class DataTableExState extends State<DataTableEx> {
  static const HEADER_AND_FOOTER = 176.0;
  static const ROW_HEIGHT = 48.0;
  int _rowsPerPage = 10;

  DataSource get _source => widget.source;

  @override
  void initState() {
    super.initState();
    _source.addListener(_handleDataSourceChanged);
  }

  @override
  void didUpdateWidget(DataTableEx oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.source != widget.source) {
      oldWidget.source.removeListener(_handleDataSourceChanged);
      widget.source.addListener(_handleDataSourceChanged);
      _handleDataSourceChanged();
    }
  }

  @override
  void dispose() {
    _source.removeListener(_handleDataSourceChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: HEADER_AND_FOOTER + _rowsPerPage * ROW_HEIGHT,
      child: PaginatedDataTableEx(
          emptyList: _source.searching ? _source.noItemsFound : _source.noItems,
          header: widget.header,
          showCheckboxColumn: true,
          columnSpacing: 16,
          source: _source,
          sortColumnIndex: _source.sortColumn,
          sortAscending: _source.sortAscending,
          onPageChanged: (index) {},
          rowsPerPage: _rowsPerPage,
          onRowsPerPageChanged: (rows) => _setHeight(rows),
          onSelectAll: (value) {
            value ? _source.selectAllItems() : _source.unSelectAllItems();
          },
          columns: _source.columns(),
          actionsHeader: widget.actionsWidget == null ? null : widget.actionsWidget(),
          actions: widget.actions == null ? null : widget.actions()),
    );
  }

  void _setHeight(int rows) {
    setState(() {
      _rowsPerPage = rows;
    });
  }

  void _handleDataSourceChanged() {
    setState(() {});
  }
}
