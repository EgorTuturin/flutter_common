import 'dart:io';

import 'package:flutter/services.dart';

void setStatusBar(bool status) {
  if (status) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  } else {
    SystemChrome.setEnabledSystemUIOverlays([]);
  }
}

void exitApp() {
  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
}

void killApp() {
  exit(0);
}
