import 'package:flutter/material.dart';

import 'app_market.dart';
import 'app_upgrade_plugin.dart';
import 'download_status.dart';
import 'simple_app_upgrade.dart';

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
  /// `cancelText`：取消按钮文字，默认"取消"
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
  /// `progressBarColor`：下载进度条颜色
  ///
  /// `borderRadius`：圆角半径，默认20
  ///
  /// `iosAppId`：ios app id,用于跳转app store,格式：idxxxxxxxx
  ///
  /// `appMarketInfo`：指定Android平台跳转到第三方应用市场更新，如果不指定将会弹出提示框，让用户选择哪一个应用市场。
  ///
  /// `onCancel`：点击取消按钮回调
  ///
  /// `onOk`：点击更新按钮回调
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
    String? iosAppId,
    AppMarketInfo? appMarketInfo,
    VoidCallback? onCancel,
    VoidCallback? onOk,
    DownloadProgressCallback? downloadProgress,
    DownloadStatusChangeCallback? downloadStatusChange,
  }) {
    future.then((AppUpgradeInfo appUpgradeInfo) {
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
        progressBar: progressBar,
        progressBarColor: progressBarColor,
        borderRadius: borderRadius,
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
    Widget? progressBar,
    Color? progressBarColor,
    double borderRadius = 20.0,
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
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Dialog(
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
    const bool isUpdate = false;

    try {
      //大致有三个 条件
      //对接入的字段进行 判断 如果 是后台返回的是 v1.1.1+1001
      if (targetVersion.contains('v') || targetVersion.contains('V')) {
        targetVersion = targetVersion.replaceAll('v', '');
        targetVersion = targetVersion.replaceAll('V', '');
      }

      //如果是后台 返回的  1.1.1+1001
      if (targetVersion.contains('+')) {
        final List<String> list = targetVersion.split('+');
        targetVersion = list[0];
        targetCode = list[1];
      }

      final AppInfo appInfo = await AppUpgradePlugin.appInfo;

      ///这样的情况是 假如后台返回的是 1.2.1 本地的是 1.1.12 长度不一致给目标添加几个0
      if (targetVersion.length < appInfo.versionName!.length) {
        final int targetVersionLength = targetVersion.length;
        String buffer = '';
        for (int i = 0;
            i < appInfo.versionName!.length - targetVersionLength;
            i++) {
          buffer = '${targetVersion}0';
        }
        targetVersion = buffer;
      }

      //如果是后台返回的   1.1.1
      final num targetVersionNum = num.parse(targetVersion.replaceAll('.', ''));
      final num localVersionNum =
          num.parse(appInfo.versionName!.replaceAll('.', ''));

      if (targetVersionNum > localVersionNum) {
        return true;
      }

      final num localCodeNum = num.parse(appInfo.versionCode!);

      if (targetCode != null) {
        final num targetCodeNum = num.parse(targetCode);
        if (targetCodeNum > localCodeNum &&
            targetVersionNum >= localVersionNum) {
          return true;
        }
      }
    } catch (error) {
      debugPrint(
          'you target version has some error please confirm targetVersion look like this v1.1.1+1001  or V1.1.1+1001  maybe this 1.1.1+1001 and 1.1.1');
      debugPrint('$error');
    }

    return isUpdate;
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
