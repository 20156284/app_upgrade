import 'dart:async';

import 'package:app_upgrade/app_upgrade.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

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
  const Home({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AppInfo? _appInfo;
  String _installMarkets = '';

  @override
  void initState() {
    _checkAppUpgrade();
    _getInstallMarket();
    _getAppInfo();
    super.initState();
  }

  Future<void> _checkAppUpgrade() async {
    // final isUp = await AppUpgrade.checkUpdateVersion(targetVersion: 'v1.1.1+1000');
    // final isUp = await AppUpgrade.checkUpdateVersion(targetVersion: 'V1.1.1+1000');
    final bool isUp =
        await AppUpgrade.checkUpdateVersion(targetVersion: 'V1.1.1');
    if (isUp) {
      AppUpgrade.appUpgrade(
        context: context,
        future: _checkAppInfo(),
        cancelText: '以后再说',
        okText: '马上升级',
        // okBgColor: Colors.red,
        // cancelBgColor: Colors.deepPurple,
        iosAppId: 'id88888888',
        // appMarketInfo: AppMarket.huaWei,
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
    // return Future.delayed(const Duration(seconds: 1), () {
    //
    // });
    return AppUpgradeInfo(
        title: '新版本V1.1.1',
        contents: <String>[
          '1、支持立体声蓝牙耳机，同时改善配对性能',
          '2、提供屏幕虚拟键盘',
          '3、更简洁更流畅，使用起来更快',
          '4、修复一些软件在使用时自动退出bug',
          '5、新增加了分类查看功能'
        ],
        apkDownloadUrl:
            'https://d-03.winudf.com/custom/com.apkpure.aegon-3198667.apk?_fn=QVBLUHVyZV92My4xOS44NjA2X2Fwa3B1cmUuY29tLmFwaw&_p=Y29tLmFwa3B1cmUuYWVnb24&am=2coSICGa7h3SGogHe5c9jQ&arg=apkpure%3A%2F%2Fcampaign%2F%3Futm_medium%3Dapkpure%26utm_source%3Dtext_home-m%26report_context%3D%7B%22channel_id%22%3A%221006%22%7D&at=1712131620&download_id=no_1072302033432695&k=a6f0a63f25b120d11c036be863452f88660e5fa8&r=https%3A%2F%2Fapkpure.com%2Fcn%2F&uu=http%3A%2F%2F172.16.73.1%2Fcustom%2Fcom.apkpure.aegon-3198667.apk%3Fk%3De084e669a136b86b01e4568062dfe0ab660e5fa8');
  }

  Future<void> _getAppInfo() async {
    final AppInfo appInfo = await AppUpgradePlugin.appInfo;
    setState(() {
      _appInfo = appInfo;
    });
  }

  Future<void> _getInstallMarket() async {
    final StringBuffer buffer = StringBuffer();
    final List<String> marketList = await AppUpgradePlugin.getInstallMarket();
    for (final String f in marketList) {
      // _installMarkets += '$f,';

      buffer.write('$f,');
    }

    _installMarkets = buffer.toString();

    // for (int i = 0; i < 10; i++) {
    //   buffer.write('a');
    // }
    // return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('packageName:${_appInfo?.packageName}'),
        Text('versionName:${_appInfo?.versionName}'),
        Text('versionCode:${_appInfo?.versionCode}'),
        Text('安装的应用商店:$_installMarkets'),
      ],
    );
  }
}
