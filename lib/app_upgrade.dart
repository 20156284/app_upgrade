
import 'dart:async';

import 'package:flutter/services.dart';

class AppUpgrade {
  static const MethodChannel _channel =
      const MethodChannel('app_upgrade');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
