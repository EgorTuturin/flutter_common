import 'package:flutter/material.dart';
import 'package:flutter_common/errors/error.dart';
import 'package:flutter_common/loader/item_bloc.dart';

typedef LoaderBuilder<T extends ItemDataState> = Widget Function(BuildContext, T);

class LoaderWidget<S extends ItemDataState> extends StatelessWidget {
  final ItemBloc loader;
  final LoaderBuilder<S> builder;
  final Widget Function(BuildContext) loadingBuilder;
  final Widget Function(BuildContext) errorBuilder;

  const LoaderWidget({Key key, @required this.loader, @required this.builder, this.loadingBuilder, this.errorBuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ItemState>(
        stream: loader.stream(),
        initialData: loader.init(),
        builder: (context, snapshot) {
          if (snapshot.data is S) {
            final S state = snapshot.data;
            return builder(context, state);
          } else if (snapshot.data is ItemErrorState) {
            final ItemErrorState state = snapshot.data;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              return showError(context, state.error);
            });
            return errorBuilder != null ? errorBuilder(context) : _reload();
          }
          return loadingBuilder != null ? loadingBuilder(context) : Center(child: CircularProgressIndicator());
        });
  }

  Widget _reload() {
    return Center(child: IconButton(tooltip: 'Reload', icon: Icon(Icons.sync), onPressed: loader.load));
  }
}
