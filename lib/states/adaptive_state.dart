import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

abstract class IAdaptiveState<T extends StatefulWidget> extends State<T> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizingInformation) {
      if (sizingInformation.deviceScreenType == DeviceScreenType.mobile) {
        return mobile();
      }
      return desktop();
    });
  }

  @protected
  Widget mobile();

  @protected
  Widget desktop();
}
