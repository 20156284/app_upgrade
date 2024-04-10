

class AppMarket {
  ///
  /// 获取所有内置的应用商店的包名
  ///
  static List<String> get buildInPackageNameList {
    return buildInMarketList.map((AppMarketInfo f) {
      return f.packageName;
    }).toList();
  }

  ///
  /// 通过包名获取内置应用商店
  ///
  static List<AppMarketInfo> getBuildInMarketList(List<String> packageNames) {
    final List<AppMarketInfo> marketList = <AppMarketInfo>[];
    for (final String packageName in packageNames) {
      for (final AppMarketInfo f in buildInMarketList) {
        if (f.packageName == packageName) {
          marketList.add(f);
        }
      }
    }
    return marketList;
  }

  static AppMarketInfo getBuildInMarket(String packageName) {
   late AppMarketInfo info;
    for (final AppMarketInfo f in buildInMarketList) {
      if (f.packageName == packageName) {
        info = f;
      }
    }
    return info;
  }

  ///
  /// 获取所有内置的应用商店
  ///
  static List<AppMarketInfo> get buildInMarketList {
    return <AppMarketInfo>[
      xiaoMi,
      meiZu,
      vivo,
      oppo,
      huaWei,
      zte,
      qiHoo,
      tencent,
      pp,
      wanDouJia
    ];
  }

  ///
  /// 小米
  ///
  static const AppMarketInfo xiaoMi = AppMarketInfo(
      'xiaoMi', 'com.xiaomi.market', 'com.xiaomi.market.ui.AppDetailActivity');

  ///
  /// 魅族
  ///
  static const AppMarketInfo meiZu = AppMarketInfo('meiZu', 'com.meizu.mstore',
      'com.meizu.flyme.appcenter.activitys.AppMainActivity');

  ///
  /// vivo
  ///
  static const AppMarketInfo vivo = AppMarketInfo(
      'vivo', 'com.bbk.appstore', 'com.bbk.appstore.ui.AppStoreTabActivity');

  ///
  /// oppo
  ///
  static const AppMarketInfo oppo = AppMarketInfo('oppo', 'com.oppo.market', 'a.a.a.aoz');

  ///
  /// 华为
  ///
  static const AppMarketInfo huaWei = AppMarketInfo('huaWei', 'com.huawei.appmarket',
      'com.huawei.appmarket.service.externalapi.view.ThirdApiActivity');

  ///
  /// zte
  ///
  static const AppMarketInfo zte = AppMarketInfo('zte', 'zte.com.market',
      'zte.com.market.view.zte.drain.ZtDrainTrafficActivity');

  ///
  /// 360
  ///
  static const AppMarketInfo qiHoo = AppMarketInfo('qiHoo', 'com.qihoo.appstore',
      'com.qihoo.appstore.distribute.SearchDistributionActivity');

  ///
  /// 应用宝
  ///
  static const AppMarketInfo tencent = AppMarketInfo(
      'tencent',
      'com.tencent.android.qqdownloader',
      'com.tencent.pangu.link.LinkProxyActivity');

  ///
  /// pp助手
  ///
  static const AppMarketInfo pp = AppMarketInfo(
      'pp', 'com.pp.assistant', 'com.pp.assistant.activity.MainActivity');

  ///
  /// 豌豆荚
  ///
  static const AppMarketInfo wanDouJia = AppMarketInfo('wanDouJia', 'com.wandoujia.phoenix2',
      'com.pp.assistant.activity.PPMainActivity');
}

class AppMarketInfo {
  const AppMarketInfo(this.marketName, this.packageName, this.className);

  final String marketName;
  final String packageName;
  final String className;
}
