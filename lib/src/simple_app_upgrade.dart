import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
    super.key,
    required this.title,
    this.titleStyle,
    required this.contents,
    this.contentStyle,
    this.cancelText,
    this.cancelTextStyle,
    this.cancelWidget,
    this.cancelBgColor,
    this.okText,
    this.okTextStyle,
    this.okWidget,
    this.okBgColor,
    this.progressBar,
    this.progressBarColor,
    this.borderRadius = 10,
    this.downloadUrl,
    this.force = false,
    this.iosAppId,
    this.appMarketInfo,
    this.onCancel,
    this.onOk,
    this.okIntercept = false,
    this.theme = AppUpgradeTheme.classic,
    this.downloadProgress,
    this.downloadStatusChange,
  });

  ///
  /// true 时点击升级只回调 onOk，不执行内置的下载 apk / 跳应用市场，
  /// 升级动作完全由宿主自行处理（如打开自定义的分发页面）
  ///
  final bool okIntercept;

  ///
  /// 升级框主题，默认 classic
  ///
  final AppUpgradeTheme theme;

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
  /// OK按钮的背景颜色
  ///
  final Color? okBgColor;

  ///
  /// 确认控件样式
  ///
  final TextStyle? okTextStyle;

  ///
  /// 取消控件
  ///
  final String? cancelText;

  ///
  /// 取消Widget 可以指定以
  ///
  final Widget? cancelWidget;

  ///
  /// 取消按钮的背景颜色
  ///
  final Color? cancelBgColor;

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
  /// 是否强制升级,设置true没有取消按钮,下载安装后也不关框
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
  static const String _defaultCancelText = '以后再说';
  static const String _defaultOkText = '立即体验';
  static const double _cardActionHeight = 44;

  ///
  /// 下载进度
  ///
  double _downloadProgress = 0.0;

  DownloadStatus _downloadStatus = DownloadStatus.none;

  ///
  /// 服务端未返回总长度，无法计算真实百分比
  ///
  bool _totalUnknown = false;

  final CancelToken _cancelToken = CancelToken();

  @override
  void dispose() {
    _cancelToken.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return switch (widget.theme) {
      AppUpgradeTheme.card => _buildCard(),
      AppUpgradeTheme.classic => _buildClassic(context),
    };
  }

  ///
  /// classic 主题：固定高度弹窗，下载时进度铺满整个弹窗
  ///
  Widget _buildClassic(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildInfoWidget(context),
        if (_downloadProgress > 0)
          Positioned.fill(child: _buildDownloadProgress())
        else
          Container(
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
  Widget _buildTitle() {
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
  Widget _buildAppInfo() {
    return Container(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 30),
        height: 200,
        child: ListView(
          children: widget.contents.map((String f) {
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
  Widget _buildAction() {
    return Column(
      children: <Widget>[
        const Divider(
          height: 1,
          color: Colors.grey,
        ),
        Row(
          children: <Widget>[
            if (widget.force)
              Container()
            else
              Expanded(
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
  Widget _buildCancelActionButton() {
    return InkWell(
      onTap: _clickCancel,
      child: widget.cancelWidget ??
          Container(
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(widget.borderRadius),
              ),
              color: widget.cancelBgColor,
            ),
            alignment: Alignment.center,
            child: Text(
              widget.cancelText ?? _defaultCancelText,
              style: widget.cancelTextStyle ??
                  const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
    );
  }

  ///
  /// 确定按钮
  ///
  Widget _buildOkActionButton() {
    BorderRadius borderRadius =
        BorderRadius.only(bottomRight: Radius.circular(widget.borderRadius));
    if (widget.force) {
      borderRadius = BorderRadius.only(
          bottomRight: Radius.circular(widget.borderRadius),
          bottomLeft: Radius.circular(widget.borderRadius));
    }
    return InkWell(
      onTap: _clickOk,
      child: widget.okWidget ??
          Container(
            height: 45,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: widget.okBgColor,
              gradient: widget.okBgColor == null
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        Colors.blue,
                        Colors.blue,
                      ],
                    )
                  : null,
            ),
            alignment: Alignment.center,
            child: Text(
              widget.okText ?? _defaultOkText,
              style: widget.okTextStyle ??
                  const TextStyle(
                      fontSize: 16, color: CupertinoColors.systemBackground),
            ),
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
          valueColor: AlwaysStoppedAnimation<Color>(
              widget.progressBarColor ?? Colors.blue.withValues(alpha: 0.4)),
          borderRadius: widget.borderRadius,
          borderColor: widget.progressBarColor ??
              Theme.of(context).primaryColor.withValues(alpha: 0.4),
          borderWidth: 0.5,
        );
  }

  ///
  /// card 主题：内容自适应高度，下载时在卡片内显示水波纹进度条
  ///
  Widget _buildCard() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.title,
            style: widget.titleStyle ??
                const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Flexible(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 240),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.contents
                      .map((String f) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              f,
                              style: widget.contentStyle ??
                                  const TextStyle(
                                    fontSize: 14,
                                    height: 1.5,
                                    color: Colors.black87,
                                  ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_isDownloading())
            _buildCardProgress()
          else
            Row(
              children: <Widget>[
                if (!widget.force) ...<Widget>[
                  Expanded(
                    child: _buildCardButton(
                      widget.cancelWidget,
                      widget.cancelText ?? _defaultCancelText,
                      widget.cancelTextStyle ??
                          const TextStyle(fontSize: 16, color: Colors.black87),
                      widget.cancelBgColor ?? const Color(0xFFF2F3F5),
                      _clickCancel,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: _buildCardButton(
                    widget.okWidget,
                    widget.okText ?? _defaultOkText,
                    widget.okTextStyle ??
                        const TextStyle(fontSize: 16, color: Colors.white),
                    widget.okBgColor ?? Colors.blue,
                    _clickOk,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  ///
  /// card 主题按钮：圆角、与卡片边缘留距
  ///
  Widget _buildCardButton(Widget? custom, String text, TextStyle style,
      Color color, VoidCallback onTap) {
    final BorderRadius radius = BorderRadius.circular(12);
    return Material(
      color: custom == null ? color : Colors.transparent,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: custom ??
            Container(
              constraints: const BoxConstraints(minHeight: _cardActionHeight),
              alignment: Alignment.center,
              child: Text(text, style: style, textAlign: TextAlign.center),
            ),
      ),
    );
  }

  ///
  /// card 主题进度：粗水波纹进度条 + 百分比
  ///
  Widget _buildCardProgress() {
    //默认字号下与按钮同高，切换时卡片不跳动
    return SizedBox(
        height: _cardActionHeight,
        child: Row(
          children: <Widget>[
            Expanded(
              child: SizedBox(
                height: 24,
                child: widget.progressBar ??
                    LiquidLinearProgressIndicator(
                      value: _downloadProgress.clamp(0.04, 1.0),
                      amplitude: 3,
                      frequency: 15,
                      backgroundColor: (widget.okBgColor ?? Colors.blue)
                          .withValues(alpha: 0.12),
                      valueColor: AlwaysStoppedAnimation<Color>(
                          widget.progressBarColor ??
                              (widget.okBgColor ?? Colors.blue)
                                  .withValues(alpha: 0.4)),
                      borderRadius: 12,
                      borderColor: (widget.okBgColor ?? Colors.blue)
                          .withValues(alpha: 0.4),
                      borderWidth: 0.5,
                    ),
              ),
            ),
            if (!_totalUnknown) ...<Widget>[
              const SizedBox(width: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 44),
                child: Text(
                  '${(_downloadProgress * 100).floor()}%',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: widget.okBgColor ?? Colors.blue),
                ),
              ),
            ],
          ],
        ));
  }

  ///
  /// 点击取消按钮
  ///
  void _clickCancel() {
    widget.onCancel?.call();
    Navigator.of(context).pop();
  }

  bool _isDownloading() =>
      _downloadStatus == DownloadStatus.start ||
      _downloadStatus == DownloadStatus.downloading ||
      _downloadStatus == DownloadStatus.done;

  ///
  /// 点击确定按钮
  ///
  Future<void> _clickOk() async {
    if (_isDownloading()) {
      return;
    }
    widget.onOk?.call();
    if (widget.okIntercept) {
      return;
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      //ios 需要跳转到app store更新，原生实现
      final String? iosAppId = widget.iosAppId;
      if (iosAppId == null) {
        debugPrint('iosAppId 为空，无法跳转 App Store');
        return;
      }
      await AppUpgradePlugin.toAppStore(iosAppId);
      return;
    }
    if (widget.downloadUrl == null || widget.downloadUrl!.isEmpty) {
      //没有下载地址，跳转到第三方渠道更新，原生实现
      await AppUpgradePlugin.toMarket(appMarketInfo: widget.appMarketInfo);
      return;
    }
    await _downloadApk(widget.downloadUrl!);
  }

  ///
  /// 下载apk包
  ///
  Future<void> _downloadApk(String url) async {
    _updateDownloadStatus(DownloadStatus.start);
    setState(() {});
    //超时让网络停滞走 catch，回到重试按钮
    final Dio dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
    ));
    try {
      final String path =
          '${await AppUpgradePlugin.apkDownloadPath}/$_downloadApkName';
      await dio.download(url, path, cancelToken: _cancelToken,
          onReceiveProgress: (int count, int total) {
        if (_downloadStatus == DownloadStatus.start) {
          _updateDownloadStatus(DownloadStatus.downloading);
        }
        if (total != -1) {
          widget.downloadProgress?.call(count, total);
        }
        if (!mounted) {
          return;
        }
        setState(() {
          _totalUnknown = total == -1;
          //总长度未知时按已收字节渐近填充示意
          _downloadProgress = _totalUnknown
              ? (count / (count + 1048576)).clamp(0.01, 1.0)
              : count / total;
        });
      });
      //下载完成，跳转到程序安装界面
      _updateDownloadStatus(DownloadStatus.done);
      await AppUpgradePlugin.installAppForAndroid(path);
      if (!mounted) {
        return;
      }
      if (widget.force) {
        //强制升级不关框：用户退出安装界面后仍须重新安装
        _updateDownloadStatus(DownloadStatus.none);
        _resetDownload();
      } else {
        //上面可能盖着别的路由，只移除升级框自身
        Navigator.of(context).removeRoute(ModalRoute.of(context)!);
      }
    } catch (e) {
      debugPrint('$e');
      _updateDownloadStatus(DownloadStatus.error, error: e);
      if (mounted) {
        _resetDownload();
      }
    } finally {
      dio.close();
    }
  }

  void _resetDownload() {
    setState(() {
      _downloadProgress = 0;
      _totalUnknown = false;
    });
  }

  void _updateDownloadStatus(DownloadStatus downloadStatus, {dynamic error}) {
    _downloadStatus = downloadStatus;
    widget.downloadStatusChange?.call(_downloadStatus, error: error);
  }
}
