import 'package:flutter/material.dart';

class ErrorEx extends Object {
  final String errorDescription;

  ErrorEx(this.errorDescription);
}

class ErrorExHttp extends ErrorEx {
  final int statusCode;
  final String reason;

  ErrorExHttp(this.statusCode, this.reason, String errorDescription) : super(errorDescription);
}

Future showError(BuildContext context, ErrorEx error) {
  String title;
  if (error is ErrorExHttp) {
    title = '${error.statusCode} ${error.reason}';
  } else {
    title = 'Error';
  }

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text(title), content: Text(error.errorDescription, softWrap: true));
      });
}
