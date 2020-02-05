import 'dart:async';
import 'package:package_info/package_info.dart';

// https://medium.com/@ralphbergmann/versioning-with-flutter-299869e68af4

class PackageManager {
  static PackageManager _instance;
  PackageInfo _packageInfo;

  static Future<PackageManager> getInstance() async {
    if (_instance == null) {
      _instance = PackageManager();
      _instance._init();
    }

    return _instance;
  }

  String appName() {
    return _packageInfo.appName;
  }

  String packageName() {
    return _packageInfo.packageName;
  }

  String version() {
    return _packageInfo.version;
  }

  String buildNumber() {
    return _packageInfo.buildNumber;
  }

  String fullVersion() {
    final ver = version();
    final number = buildNumber();
    return '$ver.$number';
  }

  // private:
  Future<void> _init() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }
}
