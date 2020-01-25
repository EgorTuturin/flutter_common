import 'dart:io' show Platform;
import 'dart:async';

import 'package:device_info/device_info.dart';

import 'package:fastotv_device_info/device.dart';
import 'package:fastotv_device_info/devices.dart';

class RuntimeDevice {
  static final RuntimeDevice _instance = RuntimeDevice._internal();
  AndroidDeviceInfo _android;
  IosDeviceInfo _ios;
  bool _hasTouch = false;
  bool _registeredInOurDB = false;
  

  factory RuntimeDevice() {
    return _instance;
  }

  RuntimeDevice._internal() {
    _init();
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

  Future<bool> touch() async {
    return await _currentDevice.hasTouch();
  }

  String get name {
    return _currentDevice.name;
  }

  // private:
  void _init() async {
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
