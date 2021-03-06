import 'dart:async';
import 'dart:convert';

import 'package:flutter_common/errors/error.dart';
import 'package:http/http.dart';

Future<Response> handleResponse(Future<Response> future, List<int> statusCodes) {
  return handleBaseResponse<Response>(future, statusCodes);
}

Future<StreamedResponse> handleStreamedResponse(
    Future<StreamedResponse> future, List<int> statusCodes) {
  return handleBaseResponse<StreamedResponse>(future, statusCodes);
}

Future<T> handleBaseResponse<T extends BaseResponse>(Future<T> future, List<int> statusCodes) {
  final completer = Completer<T>();
  future.then((resp) {
    final bool _checkCode = _checkStatusCode(resp.statusCode, statusCodes);
    if (_checkCode) {
      return completer.complete(resp);
    }
    final ErrorExHttp errorHttp = _makeError(resp);
    return completer.completeError(errorHttp);
  }, onError: (e) {
    final ErrorEx error = ErrorEx(e.toString());
    return completer.completeError(error);
  });

  return completer.future;
}

// private:
ErrorExHttp _errorFromResponse(Response resp) {
  Map<String, dynamic> data = {};
  try {
    data = json.decode(resp.body);
  } catch (e) {
    data['error'] = resp.body;
  }
  final ErrorExHttp errorHttp = ErrorExHttp(resp.statusCode, resp.reasonPhrase, data['error']);
  return errorHttp;
}

ErrorExHttp _errorFromStreamedResponse(StreamedResponse resp) {
  final ErrorExHttp errorHttp = ErrorExHttp(resp.statusCode, resp.reasonPhrase, '');
  return errorHttp;
}

bool _checkStatusCode(int current, List<int> allowed) {
  for (final int code in allowed) {
    if (code == current) {
      return true;
    }
  }

  return false;
}

ErrorExHttp _makeError(BaseResponse resp) {
  if (resp is StreamedResponse) {
    return _errorFromStreamedResponse(resp);
  }
  return _errorFromResponse(resp);
}
