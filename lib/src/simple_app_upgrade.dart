import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_market.dart';
import 'app_upgrade.dart';
import 'app_upgrade_plugin.dart';
import 'download_status.dart';
import 'liquid_progress_indicator.dart';

///
/// des:app升级提示控件
///
class SimpleAppUpgradeWidget extends StatefulWidget {
  const SimpleAppUpgradeWidget({
    required this.title,
    this.titleStyle,
    required this.contents,
    this.contentStyle,
    this.cancelText,
    this.cancelTextStyle,
    this.cancelWidget,
    this.okText,
    this.okTextStyle,
    this.okBackgroundColors,
    this.okWidget,
    this.progressBar,
    this.progressBarColor,
    this.borderRadius = 10,
    this.downloadUrl,
    this.force = false,
    this.iosAppId,
    this.appMarketInfo,
    this.onCancel,
    this.onOk,
    this.downloadProgress,
    this.downloadStatusChange,
  });

  ///
  /// 升级标题
  ///
  final String title;

  ///
  /// 标题样式
  ///
  final TextStyle? titleStyle;

  ///
  /// 升级提示内容
  ///
  final List<String> contents;

  ///
  /// 提示内容样式
  ///
  final TextStyle? contentStyle;

  ///
  /// 下载进度条
  ///
  final Widget? progressBar;

  ///
  /// 进度条颜色
  ///
  final Color? progressBarColor;

  ///
  /// 确认控件
  ///
  final String? okText;

  ///
  /// 确认控件Widget 可以指定以
  ///
  final Widget? okWidget;

  ///
  /// 确认控件样式
  ///
  final TextStyle? okTextStyle;

  ///
  /// 确认控件背景颜色,2种颜色左到右线性渐变
  ///
  final List<Color>? okBackgroundColors;

  ///
  /// 取消控件
  ///
  final String? cancelText;

  ///
  /// 取消Widget 可以指定以
  ///
  final Widget? cancelWidget;

  ///
  /// 取消控件文字样式样式
  ///
  final TextStyle? cancelTextStyle;

  ///
  /// app安装包下载url,没有下载跳转到应用宝等渠道更新
  ///
  final String? downloadUrl;

  ///
  /// 圆角半径
  ///
  final double borderRadius;

  ///
  /// 是否强制升级,设置true没有取消按钮
  ///
  final bool force;

  ///
  /// ios app id,用于跳转app store
  ///
  final String? iosAppId;

  ///
  /// 指定跳转的应用市场，
  /// 如果不指定将会弹出提示框，让用户选择哪一个应用市场。
  ///
  final AppMarketInfo? appMarketInfo;

  final VoidCallback? onCancel;
  final VoidCallback? onOk;
  final DownloadProgressCallback? downloadProgress;
  final DownloadStatusChangeCallback? downloadStatusChange;

  @override
  State<StatefulWidget> createState() => _SimpleAppUpgradeWidget();
}

class _SimpleAppUpgradeWidget extends State<SimpleAppUpgradeWidget> {
  static const String _downloadApkName = 'temp.apk';

  ///
  /// 下载进度
  ///
  double _downloadProgress = 0.0;

  DownloadStatus _downloadStatus = DownloadStatus.none;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildInfoWidget(context),
        _downloadProgress > 0
            ? Positioned.fill(child: _buildDownloadProgress())
            : Container(
                height: 10,
              )
      ],
    );
  }

  ///
  /// 信息展示widget
  ///
  Widget _buildInfoWidget(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        //标题
        _buildTitle(),
        //更新信息
        _buildAppInfo(),
        //操作按钮
        _buildAction()
      ],
    );
  }

  ///
  /// 构建标题
  ///
  _buildTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 30),
      child: Text(
        widget.title,
        style: widget.titleStyle ??
            const TextStyle(
              fontSize: 22,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  ///
  /// 构建版本更新信息
  ///
  _buildAppInfo() {
    return Container(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 30),
        height: 200,
        child: ListView(
          children: widget.contents.map((f) {
            return Text(
              f,
              style: widget.contentStyle ??
                  const TextStyle(fontSize: 14, color: Colors.black),
            );
          }).toList(),
        ));
  }

  ///
  /// 构建取消或者升级按钮
  ///
  _buildAction() {
    return Column(
      children: <Widget>[
        const Divider(
          height: 1,
          color: Colors.grey,
        ),
        Row(
          children: <Widget>[
            widget.force
                ? Container()
                : Expanded(
                    child: _buildCancelActionButton(),
                  ),
            Expanded(
              child: _buildOkActionButton(),
            ),
          ],
        ),
      ],
    );
  }

  ///
  /// 取消按钮
  ///
  _buildCancelActionButton() {
    return Ink(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(widget.borderRadius))),
      child: InkWell(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(widget.borderRadius)),
          child: widget.cancelWidget ??
              Container(
                height: 45,
                alignment: Alignment.center,
                child: Text(
                  widget.cancelText ?? '以后再说',
                  style: widget.cancelTextStyle ??
                      const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
          onTap: () {
            widget.onCancel?.call();
            Navigator.of(context).pop();
          }),
    );
  }

  ///
  /// 确定按钮
  ///
  _buildOkActionButton() {
    var borderRadius =
        BorderRadius.only(bottomRight: Radius.circular(widget.borderRadius));
    if (widget.force) {
      borderRadius = BorderRadius.only(
          bottomRight: Radius.circular(widget.borderRadius),
          bottomLeft: Radius.circular(widget.borderRadius));
    }
    var _okBackgroundColors = widget.okBackgroundColors;
    if (widget.okBackgroundColors == null ||
        widget.okBackgroundColors!.length != 2) {
      _okBackgroundColors = [Colors.blue, Colors.blue];
    }
    return Ink(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_okBackgroundColors![0], _okBackgroundColors[1]]),
          borderRadius: borderRadius),
      child: InkWell(
        borderRadius: borderRadius,
        child: widget.okWidget ??
            Container(
              height: 45,
              alignment: Alignment.center,
              child: Text(
                widget.okText ?? '立即体验',
                style: widget.okTextStyle ??
                    const TextStyle(
                        fontSize: 16, color: CupertinoColors.systemBackground),
              ),
            ),
        onTap: () {
          _clickOk();
        },
      ),
    );
  }

  ///
  /// 下载进度widget
  ///
  Widget _buildDownloadProgress() {
    return widget.progressBar ??
        LiquidLinearProgressIndicator(
          value: _downloadProgress,
          direction: Axis.vertical,
          valueColor: AlwaysStoppedAnimation(
              widget.progressBarColor ?? Colors.blue.withOpacity(0.4)),
          borderRadius: widget.borderRadius,
          borderColor: widget.progressBarColor ??
              Theme.of(context).primaryColor.withOpacity(0.4),
          borderWidth: 0.5,
        );
  }

  ///
  /// 点击确定按钮
  ///
  _clickOk() async {
    widget.onOk?.call();
    if (Platform.isIOS) {
      //ios 需要跳转到app store更新，原生实现
      AppUpgradePlugin.toAppStore(widget.iosAppId!);
      return;
    }
    if (widget.downloadUrl == null || widget.downloadUrl!.isEmpty) {
      //没有下载地址，跳转到第三方渠道更新，原生实现
      AppUpgradePlugin.toMarket(appMarketInfo: widget.appMarketInfo);
      return;
    }
    String path = await AppUpgradePlugin.apkDownloadPath;
    _downloadApk(widget.downloadUrl!, '$path/$_downloadApkName');
  }

  ///
  /// 下载apk包
  ///
  _downloadApk(String url, String path) async {
    if (_downloadStatus == DownloadStatus.start ||
        _downloadStatus == DownloadStatus.downloading ||
        _downloadStatus == DownloadStatus.done) {
      debugPrint('当前下载状态：$_downloadStatus,不能重复下载。');
      return;
    }

    _updateDownloadStatus(DownloadStatus.start);
    try {
      var dio = Dio();
      await dio.download(url, path, onReceiveProgress: (int count, int total) {
        if (total == -1) {
          _downloadProgress = 0.01;
        } else {
          widget.downloadProgress?.call(count, total);
          _downloadProgress = count / total.toDouble();
        }
        setState(() {});
        if (_downloadProgress == 1) {
          //下载完成，跳转到程序安装界面
          _updateDownloadStatus(DownloadStatus.done);
          Navigator.pop(context);
          AppUpgradePlugin.installAppForAndroid(path);
        }
      });
    } catch (e) {
      debugPrint('$e');
      _downloadProgress = 0;
      _updateDownloadStatus(DownloadStatus.error, error: e);
    }
  }

  _updateDownloadStatus(DownloadStatus downloadStatus, {dynamic error}) {
    _downloadStatus = downloadStatus;
    widget.downloadStatusChange?.call(_downloadStatus, error: error);
  }
}
