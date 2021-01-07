import 'package:flutter/material.dart';
import 'package:flutter_common/data_table/search.dart';

class DataEntry<S> {
  bool selected;
  bool isVisible;
  S entry;

  DataEntry({@required this.entry, this.selected = false, this.isVisible = true});
}

abstract class DataSource<S> extends DataTableSource {
  final List<DataEntry<S>> _items;

  bool _isSearch = false;

  final bool _selectable;

  String get itemsName;

  DataSource({@required List<DataEntry<S>> items, bool selectable})
      : _items = items,
        _selectable = selectable ?? true;

  List<DataEntry<S>> get currentList {
    final List<DataEntry<S>> result = [];
    for (int i = 0; i < _items.length; i++) {
      final value = _items[i];
      if (value.isVisible) {
        result.add(value);
      }
    }
    return result;
  }

  @override
  bool get isRowCountApproximate {
    return false;
  }

  @override
  int get rowCount {
    return currentList.length;
  }

  @override
  int get selectedRowCount {
    int count = 0;
    for (int i = 0; i < currentList.length; i++) {
      if (currentList[i].selected) {
        ++count;
      }
    }
    return count;
  }

  int get sortColumnIndex {
    return 0;
  }

  bool get sortAscending {
    return false;
  }

  Widget get noItems;

  Widget get noItemsFound => NoItemsFound(itemsName);

  List<Widget> headers();

  List<Widget> tiles(S item);

  List<S> selectedItems() {
    final List<S> result = [];
    for (int i = 0; i < currentList.length; i++) {
      final stream = currentList[i];
      if (stream.selected) {
        result.add(stream.entry);
      }
    }
    return result;
  }

  // table widgets
  List<DataColumn> columns() {
    const _index = [DataColumn(label: Text('№'))];
    final _headers = List<DataColumn>.generate(headers().length, (index) {
      return DataColumn(label: headers()[index]);
    });
    return _index + _headers;
  }

  @override
  DataRow getRow(int index) {
    final s = currentList[index];
    final _infoTiles = tiles(s.entry);
    final cells = [DataCell(Text('${index + 1}'))] +
        List<DataCell>.generate(headers().length, (index) => DataCell(_infoTiles[index]));
    return DataRow(
        key: UniqueKey(),
        selected: s.selected,
        onSelectChanged: _selectable ? (selected) => selectItem(index, selected) : null,
        cells: cells);
  }

  void showTilesDialog(BuildContext context, S item) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return _InfoDialog(this, item);
        });
  }

  // list manipulations
  bool equalItemsCondition(S item, S listItem);

  void addItem(S item, [bool notify = true]) {
    if (item == null) {
      return;
    }

    _items.add(DataEntry<S>(entry: item));
    if (notify) notifyListeners();
  }

  void addItems(List<S> toAdd) {
    for (final S item in toAdd) {
      if (item != null) {
        _items.add(DataEntry<S>(entry: item));
      }
    }

    notifyListeners();
  }

  void updateItem(S item, [bool notify = true]) {
    if (item == null) {
      return;
    }

    for (int i = 0; i < _items.length; i++) {
      if (equalItemsCondition(item, _items[i].entry)) {
        _items[i].entry = item;
        if (notify) notifyListeners();
        break;
      }
    }
  }

  void removeItem(S item) {
    if (item == null) {
      return;
    }

    for (int i = 0; i < _items.length; i++) {
      if (equalItemsCondition(item, _items[i].entry)) {
        _items.removeAt(i);
        notifyListeners();
        break;
      }
    }
  }

  void clearItems() {
    _items.clear();
    notifyListeners();
  }

  void refresh() {
    notifyListeners();
  }

  // selections
  void toggleSelection(int index) {
    if (index < currentList.length) {
      selectItem(index, !currentList[index].selected);
    }
  }

  void selectItem(int index, bool selected) {
    if (index < currentList.length) {
      currentList[index].selected = selected;
      notifyListeners();
    }
  }

  bool isSelectedItem(int index) {
    if (index < currentList.length) {
      return currentList[index].selected;
    }
    return false;
  }

  void selectAllItems() {
    _selectAllItems(true);
    notifyListeners();
  }

  void unSelectAllItems() {
    _selectAllItems(false);
    notifyListeners();
  }

  // search
  bool searchCondition(String text, S item);

  bool get searching {
    return _isSearch;
  }

  void search(String searchText) {
    _isSearch = searchText.isNotEmpty;
    for (int i = 0; i < _items.length; i++) {
      final value = _items[i];
      final bool isInSearch = searchText.isEmpty || searchCondition(searchText, value.entry);
      value.isVisible = isInSearch;
    }

    notifyListeners();
  }

  // private:
  void _selectAllItems(bool selected) {
    for (int i = 0; i < _items.length; i++) {
      _items[i].selected = selected;
    }
  }
}

abstract class SortableDataSource<S> extends DataSource<S> {
  int _sortColumn = 0;

  bool _sortAccending = false;

  SortableDataSource({@required List<DataEntry<S>> items, bool selectable})
      : super(items: items, selectable: selectable);

  @override
  int get sortColumnIndex {
    return _sortColumn;
  }

  @override
  bool get sortAscending {
    return _sortAccending;
  }

  @override
  List<DataColumn> columns() {
    const _index = [DataColumn(label: Text('№'))];
    final _headers = List<DataColumn>.generate(headers().length, (index) {
      return DataColumn(label: headers()[index], onSort: _onSort);
    });
    return _index + _headers;
  }

  // sort

  /// [index] represents nubmer of the column from [columns()]
  /// * a negative integer if [a] is smaller than [b],
  /// * zero if [a] is equal to [b], and
  /// * a positive integer if [a] is greater than [b].
  int compareItems(S a, S b, int index);

  void _onSort(int index, bool ascending) {
    if (_sortColumn != index || _sortAccending != ascending) {
      _sortColumn = index;
      _sortAccending = ascending;
      _sort(_sortColumn, _sortAccending);
      notifyListeners();
    }
  }

  int compareStrings(String a, String b) {
    return a.compareTo(b);
  }

  // private
  void _sort(int index, bool ascending) {
    _items.sort((a, b) {
      if (ascending) {
        return compareItems(a.entry, b.entry, index);
      } else {
        return compareItems(b.entry, a.entry, index);
      }
    });
  }
}

class _InfoDialog<S> extends StatelessWidget {
  final S item;
  final DataSource<S> source;

  const _InfoDialog(this.source, this.item);

  @override
  Widget build(BuildContext context) {
    final _headers = source.headers();
    final _tiles = source.tiles(item);
    return SimpleDialog(
        title: _tiles.first,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        children: List<Widget>.generate(_tiles.length - 1, (index) {
          return ListTile(title: _headers[index + 1], trailing: _tiles[index + 1]);
        }));
  }
}
