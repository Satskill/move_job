import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:move_job/Widgets/MainWidgets/CustomerPage/QRPage.dart';
import 'package:move_job/Widgets/MainWidgets/DeliveryGuyPage/MapTrackingPage.dart';

class Routes {
  static _route(Widget widget, RouteSettings settings) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return MaterialPageRoute(
          builder: (context) => widget, settings: settings);
    } else {
      return CupertinoPageRoute(
          builder: (context) => widget, settings: settings);
    }
  }

  static Route? routes(RouteSettings settings) {
    switch (settings.name) {
      case '/QRPage':
        final data = settings.arguments;
        return _route(
            QRPage(
              data: data,
            ),
            settings);
      case '/MapTrackingPage':
        final data = settings.arguments;
        return _route(
            MapTrackingPage(
              data: data,
            ),
            settings);
      default:
        return _route(Container(), settings);
    }
  }
}
