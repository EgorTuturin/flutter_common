import 'package:flutter/material.dart';
import 'package:flutter_common/errors/error.dart';

mixin IErrorListener<T extends StatefulWidget> on State<T> {
  void onError(ErrorEx error) {}
}
