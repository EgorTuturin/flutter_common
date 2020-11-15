import 'dart:async';

class ItemState<T> {}

class ItemInitState<T> extends ItemState<T> {}

class ItemLoadingState<T> extends ItemState<T> {}

class ItemErrorState<T> extends ItemState<T> {
  ItemErrorState(this.error);

  final Object error;
}

class ItemDataState<T> extends ItemState<T> {
  ItemDataState(this.data);

  final T data;
}

abstract class ItemBloc<T> {
  final StreamController<ItemState> _itemStreamController = StreamController<ItemState>.broadcast();
  ItemState _init = ItemInitState();

  ItemBloc();

  ItemState init() {
    return _init;
  }

  Stream<ItemState> stream() {
    return _itemStreamController.stream;
  }

  void load() {
    publishState(loading());
    loadDataRoute().then((value) {
      publishState(value);
    }, onError: (error) {
      _handleError(error);
    });
  }

  void dispose() {
    _itemStreamController.close();
  }

  ItemLoadingState loading() {
    return ItemLoadingState();
  }

  Future<ItemDataState> loadDataRoute();

  void publishState(ItemState state) {
    _itemStreamController.add(state);
    _init = state;
  }

  void _handleError(Object error) {
    publishState(ItemErrorState(error));
  }
}
