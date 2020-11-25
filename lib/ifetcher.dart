import 'dart:convert';
import 'dart:io';

import 'package:flutter_common/errors/handler.dart';
import 'package:flutter_common/errors/listener.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class IFetcher {
  String _accessToken;
  List<IErrorListener> _listeners = [];

  String getBackendEndpoint(String path);

  void addListener(IErrorListener listener) {
    _listeners.add(listener);
  }

  void removeListener(IErrorListener listener) {
    _listeners.remove(listener);
  }

  Future<http.StreamedResponse> sendFiles(String path, Map<String, List<int>> data, Map<String, dynamic> fields) {
    if (data == null) {
      return Future<http.StreamedResponse>(null);
    }

    final url = Uri.parse(getBackendEndpoint(path));
    http.MultipartRequest request = http.MultipartRequest('POST', url);
    if (_accessToken != null) {
      request.headers[HttpHeaders.authorizationHeader] = 'Bearer $_accessToken';
    }
    data.forEach((key, data) {
      final mf = http.MultipartFile.fromBytes('file', data,
          contentType: MediaType('application', 'octet-stream'), filename: key);
      request.files.add(mf);
    });

    final body = json.encode(fields);
    request.fields.addAll({'params': body});
    return request.send();
  }

  Future<http.Response> login(String path, Map<String, dynamic> data) {
    final Map<String, String> headers = _getJsonHeaders();
    final body = json.encode(data);
    final response = http.post(getBackendEndpoint(path), headers: headers, body: body);
    final onSuccess = (value) {
      final data = json.decode(value.body);
      _accessToken = data['access_token'];
      return Future<http.Response>.value(value);
    };
    final result = _handleError(response, [200], onSuccess);
    return result;
  }

  Future<http.Response> fetchGet(String path, [List<int> successCodes = const [200]]) {
    final Map<String, String> headers = _getHeaders();
    final response = http.get(getBackendEndpoint(path), headers: headers);
    return _handleError(response, successCodes, (value) {
      return Future<http.Response>.value(value);
    });
  }

  Future<http.Response> fetchPost(String path, Map<String, dynamic> data, [List<int> successCodes = const [200]]) {
    final Map<String, String> headers = _getJsonHeaders();
    final body = json.encode(data);
    final response = http.post(getBackendEndpoint(path), headers: headers, body: body);
    return _handleError(response, successCodes, (value) {
      return Future<http.Response>.value(value);
    });
  }

  Future<http.Response> fetchPatch(String path, Map<String, dynamic> data, [List<int> successCodes = const [200]]) {
    final Map<String, String> headers = _getJsonHeaders();
    final body = json.encode(data);
    final response = http.patch(getBackendEndpoint(path), headers: headers, body: body);
    return _handleError(response, successCodes, (value) {
      return Future<http.Response>.value(value);
    });
  }

  Future<http.Response> fetchDelete(String path, [List<int> successCodes = const [200]]) {
    final Map<String, String> headers = _getJsonHeaders();
    final response = http.delete(getBackendEndpoint(path), headers: headers);
    return _handleError(response, successCodes, (value) {
      return Future<http.Response>.value(value);
    });
  }

  Future<bool> launchUrl(String path) {
    Map<String, String> headers = {};
    if (_accessToken != null) {
      headers['authorization'] = 'Bearer $_accessToken';
    }

    return launch(getBackendEndpoint(path), headers: headers);
  }

  // private:
  Map<String, String> _getJsonHeaders() {
    Map<String, String> headers = {'content-type': 'application/json', 'accept': 'application/json'};
    if (_accessToken != null) {
      headers[HttpHeaders.authorizationHeader] = 'Bearer $_accessToken';
    }
    return headers;
  }

  Map<String, String> _getHeaders() {
    Map<String, String> headers = {};
    if (_accessToken != null) {
      headers[HttpHeaders.authorizationHeader] = 'Bearer $_accessToken';
    }
    return headers;
  }

  Future<http.Response> _handleError(
      Future<http.Response> response, List<int> successCodes, Future<http.Response> Function(http.Response) onSuccess) {
    final Future<http.Response> result = handleResponse(response, successCodes);
    return result.then((http.Response value) {
      return onSuccess(value);
    }, onError: (Object error) {
      _listeners.forEach((listener) {
        listener.onError(error);
      });
    });
  }
}
