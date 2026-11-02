import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app_market.dart';
import 'app_upgrade_plugin.dart';
import 'download_status.dart';
import 'simple_app_upgrade.dart';

///
/// 升级框主题：classic 为原样式，card 为自适应高度卡片 + 水波纹进度条
///
enum AppUpgradeTheme { classic, card }

///
/// des:App 升级组件
///
class AppUpgrade {
  ///
  /// App 升级组件入口函数，在`initState`方法中调用此函数即可。不要在[MaterialApp]控件的`initState`方法中调用，
  /// 需要在[Scaffold]的`body`控件内调用。
  ///
  /// `context`: 用于`showDialog`时使用。
  ///
  /// `future`：返回Future<AppUpgradeInfo>，通常情况下访问后台接口获取更新信息
  ///
  /// `titleStyle`：title 文字的样式
  ///
  /// `contentStyle`：版本信息内容文字样式
  ///
  /// `cancelText`：取消按钮文字，默认"以后再说"
  ///
  /// `cancelTextStyle`：取消按钮文字样式
  ///
  /// `cancelWidget`：取消的 Widget 可以自定义
  ///
  /// `cancelBgColor`：取消的 背景颜色
  ///
  /// `okText`：升级按钮文字，默认"立即体验"
  ///
  /// `okTextStyle`：升级按钮文字样式
  ///
  /// `okWidget`：升级按钮的Widget 可以自定义
  ///
  /// `okBgColor`：升级背景颜色
  ///
  /// `progressBar`：自定义下载进度条
  ///
  /// `progressBarColor`：下载进度条颜色
  ///
  /// `borderRadius`：圆角半径，默认20
  ///
  /// `backgroundColor`：升级框背景色，默认白色
  ///
  /// `iosAppId`：ios app id,用于跳转app store,格式：idxxxxxxxx
  ///
  /// `appMarketInfo`：指定Android平台跳转到第三方应用市场更新，如果不指定将会弹出提示框，让用户选择哪一个应用市场。
  ///
  /// `onCancel`：点击取消按钮回调
  ///
  /// `onOk`：点击更新按钮回调
  ///
  /// `okIntercept`：true 时点击升级只回调 onOk，内置的下载 apk / 跳应用市场都不执行，
  /// 升级动作由宿主自行处理（如打开自定义分发页面）
  ///
  /// `theme`：升级框主题，默认 [AppUpgradeTheme.classic]，card 为自适应高度卡片 + 水波纹进度条
  ///
  /// `downloadProgress`：下载进度回调
  ///
  /// `downloadStatusChange`：下载状态变化回调
  ///
  static void appUpgrade({
    required BuildContext context,
    required Future<AppUpgradeInfo> future,
    TextStyle? titleStyle,
    TextStyle? contentStyle,
    String? cancelText,
    TextStyle? cancelTextStyle,
    Widget? cancelWidget,
    Color? cancelBgColor,
    String? okText,
    TextStyle? okTextStyle,
    Widget? okWidget,
    Color? okBgColor,
    Widget? progressBar,
    Color? progressBarColor,
    double borderRadius = 20.0,
    Color backgroundColor = Colors.white,
    String? iosAppId,
    AppMarketInfo? appMarketInfo,
    VoidCallback? onCancel,
    VoidCallback? onOk,
    bool okIntercept = false,
    AppUpgradeTheme theme = AppUpgradeTheme.classic,
    DownloadProgressCallback? downloadProgress,
    DownloadStatusChangeCallback? downloadStatusChange,
  }) {
    future.then((AppUpgradeInfo appUpgradeInfo) {
      if (!context.mounted) {
        return;
      }
      _showUpgradeDialog(
        context,
        appUpgradeInfo.title,
        appUpgradeInfo.contents,
        titleStyle: titleStyle,
        contentStyle: contentStyle,
        cancelText: cancelText,
        cancelTextStyle: cancelTextStyle,
        cancelBgColor: cancelBgColor,
        cancelWidget: cancelWidget,
        onCancel: onCancel,
        okText: okText,
        okTextStyle: okTextStyle,
        okBgColor: okBgColor,
        okWidget: okWidget,
        onOk: onOk,
        okIntercept: okIntercept,
        theme: theme,
        progressBar: progressBar,
        progressBarColor: progressBarColor,
        borderRadius: borderRadius,
        backgroundColor: backgroundColor,
        apkDownloadUrl: appUpgradeInfo.apkDownloadUrl,
        force: appUpgradeInfo.force,
        iosAppId: iosAppId,
        appMarketInfo: appMarketInfo,
        downloadProgress: downloadProgress,
        downloadStatusChange: downloadStatusChange,
      );
    }).catchError((Object onError) {
      debugPrint('$onError');
    });
  }

  ///
  /// 展示app升级提示框
  ///
  static void _showUpgradeDialog(
    BuildContext context,
    String title,
    List<String> contents, {
    TextStyle? titleStyle,
    TextStyle? contentStyle,
    String? cancelText,
    TextStyle? cancelTextStyle,
    Color? cancelBgColor,
    Widget? cancelWidget,
    VoidCallback? onCancel,
    String? okText,
    TextStyle? okTextStyle,
    Color? okBgColor,
    Widget? okWidget,
    VoidCallback? onOk,
    bool okIntercept = false,
    AppUpgradeTheme theme = AppUpgradeTheme.classic,
    Widget? progressBar,
    Color? progressBarColor,
    double borderRadius = 20.0,
    Color backgroundColor = Colors.white,
    String? apkDownloadUrl,
    bool force = false,
    String? iosAppId,
    AppMarketInfo? appMarketInfo,
    DownloadProgressCallback? downloadProgress,
    DownloadStatusChangeCallback? downloadStatusChange,
  }) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return PopScope(
            canPop: false,
            child: Dialog(
              // 显式背景色，不依赖宿主 DialogTheme（宿主可能定制成透明）
              backgroundColor: backgroundColor,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(borderRadius))),
              child: SimpleAppUpgradeWidget(
                title: title,
                titleStyle: titleStyle,
                contents: contents,
                contentStyle: contentStyle,
                cancelText: cancelText,
                cancelTextStyle: cancelTextStyle,
                cancelBgColor: cancelBgColor,
                cancelWidget: cancelWidget,
                onCancel: onCancel,
                onOk: onOk,
                okIntercept: okIntercept,
                theme: theme,
                okText: okText,
                okTextStyle: okTextStyle,
                okBgColor: okBgColor,
                okWidget: okWidget,
                progressBar: progressBar,
                progressBarColor: progressBarColor,
                borderRadius: borderRadius,
                downloadUrl: apkDownloadUrl,
                force: force,
                iosAppId: iosAppId,
                appMarketInfo: appMarketInfo,
                downloadProgress: downloadProgress,
                downloadStatusChange: downloadStatusChange,
              ),
            ),
          );
        });
  }

  ///
  ///
  ///检查本地版本 和线上版本对比 判定是否可以升级
  ///
  /// `targetVersion`: 服务器后台返回的 版本 比如在 yaml 文件 配置的  version: 1.0.0+1   前面的 是服务器返回的 1.0.0 填写 targetVersion 字符长输入
  ///
  /// `targetCode`: 服务器后台返回的 code 比如上面的 +1 但是要注意 一般 flutter 打包之后 和本地 +1 里面他会默认 1000 比如上面的版本号 最后打包之后 变成 1002后台要注意上传
  static Future<bool> checkUpdateVersion(
      {required String targetVersion, String? targetCode}) async {
    try {
      // 兼容 v1.1.1+1001、V1.1.1+1001、1.1.1+1001、1.1.1
      final List<String> target =
          targetVersion.replaceAll(RegExp('[vV]'), '').split('+');
      final AppInfo appInfo = await AppUpgradePlugin.appInfo;
      final int compared = _compareVersion(target[0], appInfo.versionName!);
      if (compared != 0) {
        return compared > 0;
      }
      final String? code = target.length > 1 ? target[1] : targetCode;
      // iOS 的 versionCode 固定为 0，不参与比较
      return defaultTargetPlatform == TargetPlatform.android &&
          code != null &&
          int.parse(code) > int.parse(appInfo.versionCode!);
    } catch (error) {
      debugPrint(
          'you target version has some error please confirm targetVersion look like this v1.1.1+1001  or V1.1.1+1001  maybe this 1.1.1+1001 and 1.1.1');
      debugPrint('$error');
      return false;
    }
  }

  ///
  /// 按段比较版本号，缺的段按 0 算：1.10.0 > 1.9.0，1.2 == 1.2.0
  ///
  static int _compareVersion(String a, String b) {
    final List<int> left = a.split('.').map(int.parse).toList();
    final List<int> right = b.split('.').map(int.parse).toList();
    for (int i = 0; i < math.max(left.length, right.length); i++) {
      final int compared = (i < left.length ? left[i] : 0)
          .compareTo(i < right.length ? right[i] : 0);
      if (compared != 0) {
        return compared;
      }
    }
    return 0;
  }
}

class AppInfo {
  AppInfo({this.versionName, this.versionCode, this.packageName});

  String? versionName;
  String? versionCode;
  String? packageName;
}

class AppUpgradeInfo {
  AppUpgradeInfo(
      {required this.title,
      required this.contents,
      this.apkDownloadUrl,
      this.force = false});

  ///
  /// title,显示在提示框顶部
  ///
  final String title;

  ///
  /// 升级内容
  ///
  final List<String> contents;

  ///
  /// apk下载url
  ///
  final String? apkDownloadUrl;

  ///
  /// 是否强制升级
  ///
  final bool force;
}

///
/// 下载进度回调
///
typedef DownloadProgressCallback = Function(int count, int total);

///
/// 下载状态变化回调
///
typedef DownloadStatusChangeCallback = Function(DownloadStatus downloadStatus,
    {dynamic error});
