import 'dart:async';
import 'dart:io' show Platform;

import 'package:device_info/device_info.dart';
import 'package:fastotv_device_info/device.dart';
import 'package:fastotv_device_info/devices.dart';

class RuntimeDevice {
  static RuntimeDevice _instance;
  AndroidDeviceInfo _android;
  IosDeviceInfo _ios;
  bool _hasTouch;
  bool _registeredInOurDB = false;

  static Future<RuntimeDevice> getInstance() async {
    if (_instance == null) {
      _instance = RuntimeDevice();
      _instance._init();
    }
    return _instance;
  }

  String arch = 'unknown';
  String cpuBrand = 'unknown';
  String version = 'unknown';
  Device _currentDevice;

  AndroidDeviceInfo get androidDetails {
    return _android;
  }

  bool isRegisteredInOurDB() {
    return _registeredInOurDB;
  }

  IosDeviceInfo get iosDetails {
    return _ios;
  }

  String get os {
    if (Platform.isAndroid) {
      return 'Android';
    } else if (Platform.isIOS) {
      return 'iOS';
    }
    return 'Unknown';
  }

  bool get hasTouch {
    return _hasTouch;
  }

  Future<bool> get futureTouch {
    return _currentDevice.hasTouch();
  }

  String get name {
    return _currentDevice.name;
  }

  Future<void> _init() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isIOS) {
      _ios = await deviceInfoPlugin.iosInfo;
      arch = _ios.utsname.machine;
      cpuBrand = APPLE_BRAND;
      version = _ios.systemVersion;
    } else if (Platform.isAndroid) {
      _android = await deviceInfoPlugin.androidInfo;
      arch = _android.model;
      cpuBrand = _android.manufacturer;
      version = _android.version.sdkInt.toString();
    }
    if (Devices.all.containsKey(cpuBrand)) {
      final devices = Devices.all[cpuBrand];
      for (Device device in devices) {
        if (device.model == arch) {
          _currentDevice = device;
          _registeredInOurDB = true;
          break;
        }
      }
    }

    if (_currentDevice == null) {
      if (Platform.isIOS) {
        _currentDevice = IOSDevice(name: arch, model: arch);
      } else if (Platform.isAndroid) {
        _currentDevice = AndroidDevice(name: arch, model: arch);
      } else {
        assert(false);
      }
    }
    _hasTouch = await _currentDevice.hasTouch();
  }
}
