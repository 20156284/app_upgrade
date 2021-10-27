///
/// des:
///

class AppMarket {
  ///
  /// 获取所有内置的应用商店的包名
  ///
  static List<String> get buildInPackageNameList {
    return buildInMarketList.map((f) {
      return f.packageName;
    }).toList();
  }

  ///
  /// 通过包名获取内置应用商店
  ///
  static List<AppMarketInfo> getBuildInMarketList(List<String> packageNames) {
    List<AppMarketInfo> marketList = [];
    for (var packageName in packageNames) {
      for (var f in buildInMarketList) {
        if (f.packageName == packageName) {
          marketList.add(f);
        }
      }
    }
    return marketList;
  }

  static AppMarketInfo getBuildInMarket(String packageName) {
   late AppMarketInfo _info;
    for (var f in buildInMarketList) {
      if (f.packageName == packageName) {
        _info = f;
      }
    }
    return _info;
  }

  ///
  /// 获取所有内置的应用商店
  ///
  static List<AppMarketInfo> get buildInMarketList {
    return [
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
  static const xiaoMi = AppMarketInfo(
      'xiaoMi', "com.xiaomi.market", "com.xiaomi.market.ui.AppDetailActivity");

  ///
  /// 魅族
  ///
  static const meiZu = AppMarketInfo('meiZu', "com.meizu.mstore",
      "com.meizu.flyme.appcenter.activitys.AppMainActivity");

  ///
  /// vivo
  ///
  static const vivo = AppMarketInfo(
      'vivo', "com.bbk.appstore", "com.bbk.appstore.ui.AppStoreTabActivity");

  ///
  /// oppo
  ///
  static const oppo = AppMarketInfo('oppo', "com.oppo.market", "a.a.a.aoz");

  ///
  /// 华为
  ///
  static const huaWei = AppMarketInfo('huaWei', "com.huawei.appmarket",
      "com.huawei.appmarket.service.externalapi.view.ThirdApiActivity");

  ///
  /// zte
  ///
  static const zte = AppMarketInfo('zte', "zte.com.market",
      "zte.com.market.view.zte.drain.ZtDrainTrafficActivity");

  ///
  /// 360
  ///
  static const qiHoo = AppMarketInfo('qiHoo', "com.qihoo.appstore",
      "com.qihoo.appstore.distribute.SearchDistributionActivity");

  ///
  /// 应用宝
  ///
  static const tencent = AppMarketInfo(
      'tencent',
      "com.tencent.android.qqdownloader",
      "com.tencent.pangu.link.LinkProxyActivity");

  ///
  /// pp助手
  ///
  static const pp = AppMarketInfo(
      'pp', "com.pp.assistant", "com.pp.assistant.activity.MainActivity");

  ///
  /// 豌豆荚
  ///
  static const wanDouJia = AppMarketInfo('wanDouJia', "com.wandoujia.phoenix2",
      "com.pp.assistant.activity.PPMainActivity");
}

class AppMarketInfo {
  const AppMarketInfo(this.marketName, this.packageName, this.className);

  final String marketName;
  final String packageName;
  final String className;
}
