## [1.0.0] Flutter App Upgrade

* Flutter app 升级功能，支持Android和iOS。

## [1.0.2]

* 修复bug。

## [1.1.0]

* 1、修复一些情况下无法弹出提示框的bug。
* 2、修复Android 平台弹出升级框后，点击返回键，升级框消失bug。
* 3、下载完成后关闭升级框。
* 4、修复多次点击“立即更新”重复下载bug。
* 5、新增点击取消和立即更新按钮回调。
* 6、新增下载进度和下载状态变化回调。

## [1.2.0]

* 1、适配 AGP 8：android 模块补 namespace，AndroidManifest 移除 package 属性。
* 2、适配新版 Flutter：WillPopScope 迁移 PopScope，withOpacity 迁移 withValues，移除已删除的 v1 embedding 残留 import。
* 3、compileSdk 升 34，适配 versionName 可空标注。
* 4、修复 Android 跳转应用市场无响应：原生方法名 jumpMarket 与 Dart 端 toMarket 不一致。
* 5、环境约束升级 Dart >=3.0 / Flutter >=3.16，移除未使用的 flutter_web_plugins 依赖。
* 6、修复 apk 下载必失败：apkDownloadPath/installAppForAndroid/toAppStore 未 await 通道结果，下载路径变成 "Instance of 'Future<dynamic>'"。
* 7、原生 install/toMarket 补 result 回执，修复 Dart 端 await 永不完成。
* 8、升级框新增 backgroundColor 参数（默认白色），不再依赖宿主 DialogTheme（宿主定制透明背景时弹窗内容会裸叠在页面上）。
