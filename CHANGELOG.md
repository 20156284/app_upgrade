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

## [1.3.0]

* 1、新增 okIntercept 参数：true 时点击升级只回调 onOk，内置的下载 apk / 跳应用市场都不执行，升级动作由宿主自行处理（如按机型品牌打开对应的市场或分发页面）。

## [1.3.1]

* iOS 支持 Swift Package Manager（保留 CocoaPods），原生改为纯 Swift；toAppStore 补回调，Dart 侧 await 不再挂起。

## [1.4.0]

* 新增 AppUpgradeTheme（classic / card）与 theme 参数，默认 classic，外观不变；card 为内容自适应高度的卡片，下载时在卡片内显示粗水波纹进度条与百分比；系统字体放大时按钮随文字长高、百分比不折行。
* 下载设置 connectTimeout 15 秒、receiveTimeout 30 秒，两种主题失败后都回到可重试按钮；组件销毁时取消下载，并回调 DownloadStatus.error。
* 修复服务端未返回总长度时进度停在 1%、下载完不拉起安装。
* 强制升级下载完成后不再关框，用户退出安装界面后仍须重新安装（此时回调 DownloadStatus.none）；安装拉起失败回到重试按钮，不再无提示关框；非强制下载完只移除升级框自身，不再误关盖在上面的路由。
* 修复 checkUpdateVersion 比较错误（如本地 1.10.0、目标 1.9.0 误判为可升级），iOS 不再比较固定为 0 的 versionCode。
* 修复 toMarket 未 await 通道结果；iosAppId 为空时点升级不再抛异常；下载中补发 DownloadStatus.downloading。
* Android 11+ 声明 queries，getInstallMarket 能查到内置应用市场；修复水波纹每次进度刷新泄漏动画监听。
* dio 依赖由 any 收紧为 ^5.4.2；Flutter 下限升到 3.27（withValues 自该版本起才有）。

## [1.4.1]

* 下载到 0 字节按失败处理，回到重试按钮，不再拉起安装。
* 强制升级退出安装界面后再点，直接用已下载的安装包，不用整包重下；安装包被删才重下。
* App 在后台时下载完，等回到前台再拉起安装，不再被系统拦截后无提示关框。
* dio 下限升到 ^5.10.0：该版本起响应头之后、首包之前的停滞才会超时。
* AppMarket.getBuildInMarket 查不到时返回 null，不再抛异常（返回类型变为可空）。
* Android 跳转应用市场被系统拒绝时也提示，不再抛到 Dart 端；提示文案改为「无法打开应用商店」。
* AppInfo 字段改为 final；原生缺值时为 null，不再是字符串 "null"。
* Android minSdk 与 Flutter 3.27 对齐为 21。

## [1.4.2]

* 安装包改按下载地址的文件名保存（如 1.0.26_2.apk，取不到 .apk 文件名时仍用 temp.apk），不同版本不再共用同一路径，避免部分系统（如 ColorOS）安装器沿用旧包、提示「已安装更高版本」；下载新包前清掉之前下载的 .apk。
