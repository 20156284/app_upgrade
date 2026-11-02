import 'dart:io';

import 'package:app_upgrade/app_upgrade.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('App 升级测试'),
        ),
        body: const Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AppInfo? _appInfo;
  String _installMarkets = '';

  @override
  void initState() {
    super.initState();
    _checkAppUpgrade();
    _getInstallMarket();
    _getAppInfo();
  }

  Future<void> _checkAppUpgrade(
      [AppUpgradeTheme theme = AppUpgradeTheme.classic]) async {
    final bool isUp =
        await AppUpgrade.checkUpdateVersion(targetVersion: 'V1.1.1');
    if (isUp && mounted) {
      AppUpgrade.appUpgrade(
        context: context,
        future: _checkAppInfo(),
        theme: theme,
        cancelText: '以后再说',
        okText: '马上升级',
        iosAppId: 'id88888888',
        onCancel: () {
          debugPrint('onCancel');
        },
        onOk: () {
          debugPrint('onOk');
        },
        downloadProgress: (int count, int total) {
          debugPrint('count:$count,total:$total');
        },
        downloadStatusChange: (DownloadStatus status, {dynamic error}) {
          debugPrint('status:$status,error:$error');
        },
      );
    }
  }

  Future<AppUpgradeInfo> _checkAppInfo() async {
    //这里一般访问网络接口，将返回的数据解析成如下格式
    return AppUpgradeInfo(
        title: '新版本V1.1.1',
        contents: <String>[
          '1、支持立体声蓝牙耳机，同时改善配对性能',
          '2、提供屏幕虚拟键盘',
          '3、更简洁更流畅，使用起来更快',
          '4、修复一些软件在使用时自动退出bug',
          '5、新增加了分类查看功能'
        ],
        apkDownloadUrl: 'https://example.com/app-release.apk');
  }

  Future<void> _getAppInfo() async {
    final AppInfo appInfo = await AppUpgradePlugin.appInfo;
    if (!mounted) {
      return;
    }
    setState(() {
      _appInfo = appInfo;
    });
  }

  Future<void> _getInstallMarket() async {
    if (!Platform.isAndroid) {
      return;
    }
    final List<String> marketList = await AppUpgradePlugin.getInstallMarket();
    if (!mounted) {
      return;
    }
    setState(() => _installMarkets = marketList.join(','));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('packageName:${_appInfo?.packageName}'),
        Text('versionName:${_appInfo?.versionName}'),
        Text('versionCode:${_appInfo?.versionCode}'),
        Text('安装的应用商店:$_installMarkets'),
        TextButton(
          onPressed: _checkAppUpgrade,
          child: const Text('弹出升级框：classic'),
        ),
        TextButton(
          onPressed: () => _checkAppUpgrade(AppUpgradeTheme.card),
          child: const Text('弹出升级框：card'),
        ),
      ],
    );
  }
}
