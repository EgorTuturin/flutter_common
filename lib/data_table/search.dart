import 'package:flutter/material.dart';
import 'package:flutter_common/base/controls/no_channels.dart';
import 'package:flutter_common/data_table/data_source.dart';
import 'package:responsive_builder/responsive_builder.dart';

class DataTableSearchHeader extends StatefulWidget {
  final DataSource source;
  final List<Widget> rightSearchActions;

  DataTableSearchHeader({@required this.source, List<Widget> actions})
      : this.rightSearchActions = actions ?? [];

  @override
  _DataTableSearchHeaderState createState() => _DataTableSearchHeaderState();
}

class _DataTableSearchHeaderState extends State<DataTableSearchHeader> {
  DataSource get _dataSource => widget.source;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dataSource.addListener(_handleDataSourceChanged);
  }

  @override
  void didUpdateWidget(DataTableSearchHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.source != widget.source) {
      oldWidget.source.removeListener(_handleDataSourceChanged);
      widget.source.addListener(_handleDataSourceChanged);
      _handleDataSourceChanged();
    }
  }

  @override
  void dispose() {
    _dataSource.removeListener(_handleDataSourceChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(mobile: _mobile(), tablet: _tablet(), desktop: _desktop());
  }

  Widget _mobile() {
    return Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Row(children: [_searchTextField()] + widget.rightSearchActions));
  }

  Widget _tablet() {
    return Row(children: [_searchTextField(), Spacer()] + widget.rightSearchActions);
  }

  Widget _desktop() {
    return Row(children: [_searchTextField(), Spacer(flex: 2)] + widget.rightSearchActions);
  }

  Widget _searchTextField() {
    return Expanded(
        child: ListTile(
            leading: Icon(Icons.search),
            title: TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: 'Search', border: InputBorder.none),
              onChanged: onSearchTextChanged,
            ),
            trailing: _dataSource.searching
                ? IconButton(
                    icon: Icon(Icons.cancel),
                    color: Theme.of(context).accentColor,
                    onPressed: () {
                      _controller.clear();
                      onSearchTextChanged('');
                    })
                : null));
  }

  void onSearchTextChanged(String text) async {
    _dataSource.search(text);
  }

  void _handleDataSourceChanged() {
    setState(() {});
  }
}

class NoItemsFound extends StatelessWidget {
  final String itemName;

  NoItemsFound(this.itemName);

  @override
  Widget build(BuildContext context) {
    return NonAvailableBuffer(icon: Icons.search, message: 'No $itemName found');
  }
}
