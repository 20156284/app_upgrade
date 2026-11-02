import 'package:flutter/services.dart';

import 'app_market.dart';
import 'app_upgrade.dart';

class AppUpgradePlugin {
  static const MethodChannel _channel = MethodChannel('app_upgrade');

  ///
  /// 调用原生方法，结果转字符串，无结果时返回空串
  ///
  static Future<String> _invokeString(String method,
      [Map<String, String>? arguments]) async {
    return (await _channel.invokeMethod<Object>(method, arguments))
            ?.toString() ??
        '';
  }

  ///
  /// 获取app信息
  ///
  static Future<AppInfo> get appInfo async {
    final Map<Object?, Object?> result =
        await _channel.invokeMethod('getAppInfo') as Map<Object?, Object?>;
    return AppInfo(
      versionName: result['versionName']?.toString(),
      versionCode: result['versionCode']?.toString(),
      packageName: result['packageName']?.toString(),
    );
  }

  ///
  /// 获取apk下载路径
  ///
  static Future<String> get apkDownloadPath =>
      _invokeString('getApkDownloadPath');

  ///
  /// Android 安装app
  ///
  static Future<String> installAppForAndroid(String path) {
    return _invokeString('install', <String, String>{'path': path});
  }

  ///
  /// 跳转到ios app store
  ///
  static Future<String> toAppStore(String id) {
    return _invokeString('toAppStore', <String, String>{'id': id});
  }

  ///
  /// 获取android手机上安装的应用商店
  ///
  static Future<List<String>> getInstallMarket(
      {List<String>? marketPackageNames}) async {
    final List<dynamic> result =
        await _channel.invokeMethod('getInstallMarket', <String, List<String>>{
      'packages': <String>[
        ...AppMarket.buildInPackageNameList,
        ...?marketPackageNames,
      ],
    }) as List<dynamic>;
    return result.map((dynamic f) => '$f').toList();
  }

  ///
  /// 跳转到应用商店
  ///
  static Future<String> toMarket({AppMarketInfo? appMarketInfo}) {
    return _invokeString('toMarket', <String, String>{
      'marketPackageName': appMarketInfo?.packageName ?? '',
      'marketClassName': appMarketInfo?.className ?? '',
    });
  }
}
