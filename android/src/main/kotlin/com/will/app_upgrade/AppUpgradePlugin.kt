package com.will.app_upgrade

import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.widget.Toast
import androidx.core.content.FileProvider
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File

class AppUpgradePlugin : FlutterPlugin, MethodCallHandler {
  private lateinit var channel: MethodChannel
  private lateinit var mainContext: Context

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    mainContext = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "app_upgrade")
    channel.setMethodCallHandler(this)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "getAppInfo" -> {
        result.success(getAppInfo(mainContext))
      }
      "getApkDownloadPath" -> {
        result.success(mainContext.getExternalFilesDir("")?.absolutePath)
      }
      "install" -> {
        call.argument<String>("path")?.also { startInstall(mainContext, it) }
        // 必须回执，否则 Dart 端 await invokeMethod 永远不完成
        result.success("")
      }
      "getInstallMarket" -> {
        result.success(getInstallMarket(mainContext, call.argument<List<String>>("packages")))
      }
      "toMarket" -> {
        jumpMarket(mainContext, call.argument<String>("marketPackageName"), call.argument<String>("marketClassName"))
        result.success("")
      }
      else -> result.notImplemented()
    }
  }

  /**
   * 获取app信息
   */
  private fun getAppInfo(context: Context): Map<String, String> {
    val packageInfo = context.packageManager.getPackageInfo(context.packageName, 0)
    return mapOf(
      "packageName" to packageInfo.packageName,
      // compileSdk 33+ 起 versionName 标注为可空
      "versionName" to (packageInfo.versionName ?: ""),
      "versionCode" to if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
        "${packageInfo.longVersionCode}"
      } else {
        "${packageInfo.versionCode}"
      },
    )
  }

  /**
   * 直接跳转到指定应用市场
   */
  private fun jumpMarket(context: Context, marketPackageName: String?, marketClassName: String?) {
    val goToMarket = Intent(Intent.ACTION_VIEW, Uri.parse("market://details?id=${context.packageName}"))
      .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
    if (!marketPackageName.isNullOrEmpty() && !marketClassName.isNullOrEmpty()) {
      goToMarket.setClassName(marketPackageName, marketClassName)
    }
    try {
      context.startActivity(goToMarket)
    } catch (e: RuntimeException) {
      // 没有市场，或指定的市场页面不对外开放
      Toast.makeText(context, "无法打开应用商店", Toast.LENGTH_SHORT).show()
    }
  }

  /**
   * 获取已安装应用商店的包名列表
   */
  private fun getInstallMarket(context: Context, packages: List<String>?): List<String> {
    return packages.orEmpty().filter { isPackageExist(context, it) }
  }

  /**
   * 是否存在当前应用市场
   */
  private fun isPackageExist(context: Context, packageName: String): Boolean {
    val intent = Intent().setPackage(packageName)
    return context.packageManager.queryIntentActivities(intent, PackageManager.GET_RESOLVED_FILTER).isNotEmpty()
  }

  /**
   * 安装app，android 7.0及以上和以下方式不同
   */
  private fun startInstall(context: Context, path: String) {
    val file = File(path)
    if (!file.exists()) {
      return
    }
    val uri = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
      FileProvider.getUriForFile(context, "${context.packageName}.fileprovider", file)
    } else {
      Uri.fromFile(file)
    }
    context.startActivity(
      Intent(Intent.ACTION_VIEW)
        .setDataAndType(uri, "application/vnd.android.package-archive")
        .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_GRANT_READ_URI_PERMISSION)
    )
  }
}
