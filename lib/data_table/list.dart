import 'package:flutter/material.dart';
import 'package:flutter_common/data_table/data_source.dart';

class DataListEx extends StatefulWidget {
  final DataSource source;
  final Widget header;
  final List<Widget> Function() actions;

  DataListEx(this.source, this.header, this.actions);

  @override
  DataListExState createState() => DataListExState();
}

class DataListExState extends State<DataListEx> {
  DataSource get _source => widget.source;

  @override
  void initState() {
    super.initState();
    _source.addListener(_handleDataSourceChanged);
  }

  @override
  void didUpdateWidget(DataListEx oldWidget) {
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
    return Column(
        children: <Widget>[_source.selectedRowCount != 0 ? _actions() : _header(), Expanded(child: _columnChild())]);
  }

  // private:
  Widget _tile(int index) {
    final _stream = _source.currentList[index];
    return ListTile(
        key: UniqueKey(),
        trailing: _checkBox(index),
        onTap: () {
          _source.selectedRowCount > 0
              ? _source.toggleSelection(index)
              : _source.showTilesDialog(context, _stream.entry);
        },
        onLongPress: () {
          _source.toggleSelection(index);
        },
        title: _source.tiles(_stream.entry).first);
  }

  Widget _columnChild() {
    if (_source.currentList.isEmpty) {
      return _source.noItems;
    }

    return ListView.builder(
        itemCount: _source.rowCount,
        itemBuilder: (context, index) {
          return _tile(index);
        });
  }

  Widget _header() {
    return Padding(padding: const EdgeInsets.fromLTRB(16, 4, 0, 4), child: widget.header);
  }

  Widget _actions() {
    return ListTile(
        title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [_selectAll()] + widget.actions()));
  }

  Widget _selectAll() {
    bool _allSelected = _source.selectedRowCount == _source.rowCount;
    return IconButton(
      icon: Icon(_allSelected ? Icons.clear_all : Icons.select_all),
      onPressed: () {
        _allSelected ? _source.unSelectAllItems() : _source.selectAllItems();
      },
    );
  }

  void _handleDataSourceChanged() {
    setState(() {});
  }

  Widget _checkBox(int index) {
    final _selected = _source.isSelectedItem(index);
    if (_selected) {
      return IgnorePointer(child: Checkbox(value: true, onChanged: (_) {}));
    }
    return SizedBox();
  }
}
