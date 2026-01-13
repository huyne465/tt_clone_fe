import 'package:flutter/widgets.dart';
import 'dart:ui';

class DeviceValue {
  // Using PlatformDispatcher to get view data without context initially if needed,
  // but standard MediaQuery is safesty in widget build.
  // For static access without context, we rely on the primary view.
  static double get deviceWidth { // physical / pixelRatio
    return PlatformDispatcher.instance.views.first.physicalSize.width /
        PlatformDispatcher.instance.views.first.devicePixelRatio;
  }

  static double get deviceHeight {
    return PlatformDispatcher.instance.views.first.physicalSize.height /
        PlatformDispatcher.instance.views.first.devicePixelRatio;
  }
}
