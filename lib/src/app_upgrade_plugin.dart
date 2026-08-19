import 'dart:async';

import 'package:flutter/services.dart';

import 'app_market.dart';
import 'app_upgrade.dart';

class AppUpgradePlugin {
  static const MethodChannel _channel = MethodChannel('app_upgrade');

  ///
  /// 获取app信息
  ///
  static Future<AppInfo> get appInfo async {
    final Map<Object?, Object?> result =
        await _channel.invokeMethod('getAppInfo') as Map<Object?, Object?>;
    return AppInfo(
      versionName: result['versionName'].toString(),
      versionCode: result['versionCode'].toString(),
      packageName: result['packageName'].toString(),
    );
  }

  ///
  /// 获取apk下载路径
  ///
  static Future<String> get apkDownloadPath async {
    // 注意必须先 await 再 toString，否则拿到的是 Future 对象的 toString，
    // 下载路径变成 "Instance of 'Future<dynamic>'" 导致写文件失败
    final dynamic path = await _channel.invokeMethod('getApkDownloadPath');
    return path?.toString() ?? '';
  }

  ///
  /// Android 安装app
  ///
  static Future<String> installAppForAndroid(String path) async {
    final Map<String, String> map = <String, String>{'path': path};
    final dynamic result = await _channel.invokeMethod('install', map);
    return result?.toString() ?? '';
  }

  ///
  /// 跳转到ios app store
  ///
  static Future<String> toAppStore(String id) async {
    final Map<String, String> map = <String, String>{'id': id};
    final dynamic result = await _channel.invokeMethod('toAppStore', map);
    return result?.toString() ?? '';
  }

  ///
  /// 获取android手机上安装的应用商店
  ///
  static Future<List<String>> getInstallMarket(
      {List<String>? marketPackageNames}) async {
    final List<String> packageNameList = AppMarket.buildInPackageNameList;
    if (marketPackageNames != null && marketPackageNames.isNotEmpty) {
      packageNameList.addAll(marketPackageNames);
    }
    final Map<String, List<String>> map = <String, List<String>>{
      'packages': packageNameList
    };
    final List<dynamic> result =
        await _channel.invokeMethod('getInstallMarket', map) as List<dynamic>;
    final List<String> resultList = result.map((dynamic f) {
      return '$f';
    }).toList();
    return resultList;
  }

  ///
  /// 跳转到应用商店
  ///
  static Future<String> toMarket({AppMarketInfo? appMarketInfo}) async {
    final Map<String, String> map = <String, String>{
      'marketPackageName':
          appMarketInfo != null ? appMarketInfo.packageName : '',
      'marketClassName': appMarketInfo != null ? appMarketInfo.className : ''
    };
    return _channel.invokeMethod('toMarket', map).toString();
  }
}
