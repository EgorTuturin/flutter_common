import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_common/errors/error.dart';
import 'package:flutter_common/errors/handler.dart';
import 'package:flutter_common/errors/listener.dart';

abstract class IFetcher{
  String getBackendEndpoint();
  String _accessToken;

  Fetcher();

  List<IErrorListener> _listeners = [];

  void addListener(IErrorListener listener) {
    _listeners.add(listener);
  }

  void removeListener(IErrorListener listener) {
    _listeners.remove(listener);
  }

  Future<http.Response> login(String path, Map<String, dynamic> data) {
    final response = fetchPost(path, data);
    return _handleError(response, [200], (value) {
      final data = json.decode(value.body);
      _accessToken = data['access_token'];
    });
  }

  Future<http.Response> fetchGet(String path, [List<int> successCodes = const [200]]) {
    final Map<String, String> headers = _getHeaders();
    final response = http.get(_generateBackendApiEndpoint(path), headers: headers);
    return _handleError(response, successCodes);
  }

  Future<http.Response> fetchPost(String path, Map<String, dynamic> data, [List<int> successCodes = const [200]]) {
    final Map<String, String> headers = _getJsonHeaders();
    final body = json.encode(data);
    final response = http.post(_generateBackendApiEndpoint(path), headers: headers, body: body);
    return _handleError(response, successCodes);
  }

  Future<http.Response> fetchPatch(String path, Map<String, dynamic> data, [List<int> successCodes = const [200]]) {
    final Map<String, String> headers = _getJsonHeaders();
    final body = json.encode(data);
    final response = http.patch(_generateBackendApiEndpoint(path), headers: headers, body: body);
    return _handleError(response, successCodes);
  }

  Future<http.Response> fetchDelete(String path, [List<int> successCodes = const [200]]) {
    final Map<String, String> headers = _getJsonHeaders();
    final response = http.delete(_generateBackendApiEndpoint(path), headers: headers);
    return _handleError(response, successCodes);
  }

  Future<bool> launchUrl(String path) {
    Map<String, String> headers = {};
    if (_accessToken != null) {
      headers['authorization'] = 'Bearer $_accessToken';
    }

    return launch(_generateBackendApiEndpoint(path), headers: headers);
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

  String _getBackendApiEndpoint() {
    final base = getBackendEndpoint();
    return '$base/api';
  }

  String _generateBackendApiEndpoint(String path) {
    final base = _getBackendApiEndpoint();
    return '$base$path';
  }

  Future<http.Response> _handleError(Future<http.Response> response, List<int> successCodes, [void Function(http.Response) onSuccess]) {
    return ResponseParser.handleResponse(response, successCodes).then(onSuccess,
        onError: (ErrorExHttp error) {
      _listeners.forEach((listener) {
        listener.onError.call(error);
      });
    });
  }
}
