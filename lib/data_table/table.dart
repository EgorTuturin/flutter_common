import 'dart:math' as math;

import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_common/data_table/data_source.dart';

class TableChangedHeight extends Notification {
  final int rows;

  const TableChangedHeight(this.rows);
}

class DataTableEx extends StatefulWidget {
  final DataSource source;
  final Widget header;
  final Widget Function() actionsWidget;
  final List<Widget> Function() actions;

  const DataTableEx(this.source, this.header, this.actions) : actionsWidget = null;

  const DataTableEx.customActions(this.source, this.header, this.actionsWidget) : actions = null;

  @override
  DataTableExState createState() {
    return DataTableExState();
  }
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
    return SizedBox(
        height: HEADER_AND_FOOTER + _rowsPerPage * ROW_HEIGHT,
        child: _PaginatedDataTableEx(
            emptyList: _source.searching ? _source.noItemsFound : _source.noItems,
            header: widget.header,
            columnSpacing: 16,
            source: _source,
            sortColumnIndex: _source.sortColumnIndex,
            sortAscending: _source.sortAscending,
            onPageChanged: (index) {},
            rowsPerPage: _rowsPerPage,
            onRowsPerPageChanged: _setHeight,
            onSelectAll: (value) {
              value ? _source.selectAllItems() : _source.unSelectAllItems();
            },
            columns: _source.columns(),
            actionsHeader: widget.actionsWidget == null ? null : widget.actionsWidget(),
            actions: widget.actions == null ? null : widget.actions()));
  }

  void _setHeight(int rows) {
    setState(() {
      _rowsPerPage = rows;
    });
    TableChangedHeight(_rowsPerPage).dispatch(context);
  }

  void _handleDataSourceChanged() {
    setState(() {});
  }
}

///  * [DataTable], which is not paginated.
///  * <https://material.io/go/design-data-tables#data-tables-tables-within-cards>
class _PaginatedDataTableEx extends StatefulWidget {
  _PaginatedDataTableEx({
    Key key,
    @required this.header,
    this.emptyList,
    this.actions,
    this.actionsHeader,
    @required this.columns,
    this.sortColumnIndex,
    this.sortAscending = true,
    this.onSelectAll,
    this.dataRowHeight = kMinInteractiveDimension,
    this.headingRowHeight = 56.0,
    this.horizontalMargin = 24.0,
    this.columnSpacing = 56.0,
    this.showCheckboxColumn = true,
    this.initialFirstRowIndex = 0,
    this.onPageChanged,
    this.rowsPerPage = defaultRowsPerPage,
    this.availableRowsPerPage = const <int>[
      defaultRowsPerPage,
      defaultRowsPerPage * 2,
      defaultRowsPerPage * 5,
      defaultRowsPerPage * 10,
      defaultRowsPerPage * 20,
      defaultRowsPerPage * 50,
      defaultRowsPerPage * 100
    ],
    this.onRowsPerPageChanged,
    this.dragStartBehavior = DragStartBehavior.start,
    @required this.source,
  })  : assert(header != null),
        assert(columns != null),
        assert(dragStartBehavior != null),
        assert(columns.isNotEmpty),
        assert(
            sortColumnIndex == null || (sortColumnIndex >= 0 && sortColumnIndex < columns.length)),
        assert(sortAscending != null),
        assert(dataRowHeight != null),
        assert(actions == null || actionsHeader == null),
        assert(headingRowHeight != null),
        assert(horizontalMargin != null),
        assert(columnSpacing != null),
        assert(showCheckboxColumn != null),
        assert(rowsPerPage != null),
        assert(rowsPerPage > 0),
        assert(() {
          if (onRowsPerPageChanged != null)
            assert(availableRowsPerPage != null && availableRowsPerPage.contains(rowsPerPage));
          return true;
        }()),
        assert(source != null),
        super(key: key);

  final Widget header;
  final Widget emptyList;
  final List<Widget> actions;
  final Widget actionsHeader;
  final List<DataColumn> columns;
  final int sortColumnIndex;
  final bool sortAscending;
  final ValueSetter<bool> onSelectAll;
  final double dataRowHeight;
  final double headingRowHeight;
  final double horizontalMargin;
  final double columnSpacing;
  final bool showCheckboxColumn;
  final int initialFirstRowIndex;
  final ValueChanged<int> onPageChanged;
  final int rowsPerPage;
  static const int defaultRowsPerPage = 10;
  final List<int> availableRowsPerPage;
  final ValueChanged<int> onRowsPerPageChanged;
  final DataTableSource source;
  final DragStartBehavior dragStartBehavior;

  @override
  _PaginatedDataTableExState createState() => _PaginatedDataTableExState();
}

class _PaginatedDataTableExState extends State<_PaginatedDataTableEx> {
  int _firstRowIndex;
  int _rowCount;
  bool _rowCountApproximate;
  int _selectedRowCount;
  final Map<int, DataRow> _rows = <int, DataRow>{};

  @override
  void initState() {
    super.initState();
    _firstRowIndex =
        PageStorage.of(context)?.readState(context) as int ?? widget.initialFirstRowIndex ?? 0;
    widget.source.addListener(_handleDataSourceChanged);
    _handleDataSourceChanged();
  }

  @override
  void didUpdateWidget(_PaginatedDataTableEx oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.source != widget.source) {
      oldWidget.source.removeListener(_handleDataSourceChanged);
      widget.source.addListener(_handleDataSourceChanged);
      _handleDataSourceChanged();
    }
  }

  @override
  void dispose() {
    widget.source.removeListener(_handleDataSourceChanged);
    super.dispose();
  }

  void _handleDataSourceChanged() {
    setState(() {
      _rowCount = widget.source.rowCount;
      _rowCountApproximate = widget.source.isRowCountApproximate;
      _selectedRowCount = widget.source.selectedRowCount;
      _rows.clear();
    });
  }

  /// Ensures that the given row is visible.
  void pageTo(int rowIndex) {
    final int oldFirstRowIndex = _firstRowIndex;
    setState(() {
      final int rowsPerPage = widget.rowsPerPage;
      _firstRowIndex = (rowIndex ~/ rowsPerPage) * rowsPerPage;
    });
    if ((widget.onPageChanged != null) && (oldFirstRowIndex != _firstRowIndex))
      widget.onPageChanged(_firstRowIndex);
  }

  DataRow _getBlankRowFor(int index) {
    return DataRow.byIndex(
        index: index,
        cells: widget.columns.map<DataCell>((DataColumn column) => DataCell.empty).toList());
  }

  DataRow _getProgressIndicatorRowFor(int index) {
    bool haveProgressIndicator = false;
    final List<DataCell> cells = widget.columns.map<DataCell>((DataColumn column) {
      if (!column.numeric) {
        haveProgressIndicator = true;
        return const DataCell(CircularProgressIndicator());
      }
      return DataCell.empty;
    }).toList();
    if (!haveProgressIndicator) {
      haveProgressIndicator = true;
      cells[0] = const DataCell(CircularProgressIndicator());
    }
    return DataRow.byIndex(
      index: index,
      cells: cells,
    );
  }

  List<DataRow> _getRows(int firstRowIndex, int rowsPerPage) {
    final List<DataRow> result = <DataRow>[];
    final int nextPageFirstRowIndex = firstRowIndex + rowsPerPage;
    bool haveProgressIndicator = false;
    for (int index = firstRowIndex; index < nextPageFirstRowIndex; index += 1) {
      DataRow row;
      if (index < _rowCount || _rowCountApproximate) {
        row = _rows.putIfAbsent(index, () => widget.source.getRow(index));
        if (row == null && !haveProgressIndicator) {
          row ??= _getProgressIndicatorRowFor(index);
          haveProgressIndicator = true;
        }
      }
      row ??= _getBlankRowFor(index);
      result.add(row);
    }
    return result;
  }

  void _handlePrevious() {
    pageTo(math.max(_firstRowIndex - widget.rowsPerPage, 0));
  }

  void _handleNext() {
    pageTo(_firstRowIndex + widget.rowsPerPage);
  }

  final GlobalKey _tableKey = GlobalKey();

  double startPadding = 24.0;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      return Card(
          semanticContainer: false,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[_header(), Expanded(child: _content(constraints)), _footer()]));
    });
  }

  Widget _header() {
    final ThemeData themeData = Theme.of(context);
    return Semantics(
        container: true,
        child: DefaultTextStyle(
            // See https://material.io/design/components/data-tables.html#tables-within-cards
            style: _selectedRowCount > 0
                ? themeData.textTheme.subtitle2.copyWith(color: themeData.accentColor)
                : themeData.textTheme.headline5.copyWith(fontWeight: FontWeight.w400),
            child: IconTheme.merge(
                data: const IconThemeData(opacity: 0.54),
                child: Ink(
                    height: 64.0,
                    color: _selectedRowCount > 0 ? themeData.secondaryHeaderColor : null,
                    child: Padding(
                        padding: EdgeInsetsDirectional.only(start: startPadding, end: 14.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: _headerWidgets()))))));
  }

  List<Widget> _headerWidgets() {
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final List<Widget> headerWidgets = <Widget>[];
    if (_selectedRowCount == 0) {
      headerWidgets.add(Expanded(child: widget.header));
    } else {
      headerWidgets
          .add(Expanded(child: Text(localizations.selectedRowCountTitle(_selectedRowCount))));
    }
    if (widget.actionsHeader != null) {
      headerWidgets.add(widget.actionsHeader);
    } else if (widget.actions != null) {
      headerWidgets.addAll(widget.actions.map<Widget>((Widget action) {
        if (action is SizedBox) {
          return action;
        } else {
          return TableActionIcon(action);
        }
      }).toList());
    }
    return headerWidgets;
  }

  Widget _content(BoxConstraints constraints) {
    if (widget.source.rowCount == 0) {
      return widget.emptyList;
    }
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        dragStartBehavior: widget.dragStartBehavior,
        child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: DataTable(
                key: _tableKey,
                columns: widget.columns,
                sortColumnIndex: widget.sortColumnIndex,
                sortAscending: widget.sortAscending,
                onSelectAll: widget.onSelectAll,
                dataRowHeight: widget.dataRowHeight,
                headingRowHeight: widget.headingRowHeight,
                horizontalMargin: widget.horizontalMargin,
                columnSpacing: widget.columnSpacing,
                rows: _getRows(_firstRowIndex, widget.rowsPerPage))));
  }

  Widget _footer() {
    return DefaultTextStyle(
        style: Theme.of(context).textTheme.caption,
        child: IconTheme.merge(
            data: const IconThemeData(opacity: 0.54),
            child: SizedBox(
                // TODO(bkonyi): this won't handle text zoom correctly, https://github.com/flutter/flutter/issues/48522
                height: 56.0,
                child: SingleChildScrollView(
                    dragStartBehavior: widget.dragStartBehavior,
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Row(children: _footerWidgets())))));
  }

  List<Widget> _footerWidgets() {
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final List<Widget> footerWidgets = <Widget>[];
    if (widget.onRowsPerPageChanged != null) {
      final List<Widget> availableRowsPerPage = widget.availableRowsPerPage
          .where((int value) => value <= _rowCount || value == widget.rowsPerPage)
          .map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(value: value, child: Text('$value'));
      }).toList();
      footerWidgets.addAll(<Widget>[
        Container(width: 14.0),
        Text(localizations.rowsPerPageTitle),
        ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 64.0),
            child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                        items: availableRowsPerPage.cast<DropdownMenuItem<int>>(),
                        value: widget.rowsPerPage,
                        onChanged: widget.onRowsPerPageChanged,
                        style: Theme.of(context).textTheme.caption))))
      ]);
    }
    footerWidgets.addAll(<Widget>[
      Container(width: 32.0),
      Text(localizations.pageRowsInfoTitle(_firstRowIndex + 1, _firstRowIndex + widget.rowsPerPage,
          _rowCount, _rowCountApproximate)),
      Container(width: 32.0),
      IconButton(
          icon: const Icon(Icons.chevron_left),
          padding: EdgeInsets.zero,
          tooltip: localizations.previousPageTooltip,
          onPressed: _firstRowIndex <= 0 ? null : _handlePrevious),
      Container(width: 24.0),
      IconButton(
          icon: const Icon(Icons.chevron_right),
          padding: EdgeInsets.zero,
          tooltip: localizations.nextPageTooltip,
          onPressed: (!_rowCountApproximate && (_firstRowIndex + widget.rowsPerPage >= _rowCount))
              ? null
              : _handleNext),
      Container(width: 14.0)
    ]);
    return footerWidgets;
  }
}

class TableActionIcon extends StatelessWidget {
  final Widget action;

  const TableActionIcon(this.action);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsetsDirectional.only(start: 24.0 - 8.0 * 2.0), child: action);
  }
}
