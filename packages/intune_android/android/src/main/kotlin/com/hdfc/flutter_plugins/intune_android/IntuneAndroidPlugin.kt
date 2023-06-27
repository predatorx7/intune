package com.hdfc.flutter_plugins.intune_android

import android.content.Context
import android.util.Log

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** IntuneAndroidPlugin */
class IntuneAndroidPlugin : FlutterPlugin, IntuneApi {
  companion object {
    const val TAG = "IntuneAndroidPlugin"
  }

  private lateinit var context : Context

  private fun setup(messenger: BinaryMessenger, context: Context) {
    try {
        IntuneApi.setUp(messenger, this)
    } catch (ex: Error) {
      Log.e(TAG, "Received exception while setting up IntuneAndroidPlugin", ex);
    }

    this.context = context;
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    setup(flutterPluginBinding.binaryMessenger, flutterPluginBinding.applicationContext);
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    IntuneApi.setUp(binding.binaryMessenger, null)
  }

  override fun ping(hello: String, callback: (kotlin.Result<String>) -> Unit) {
    callback(kotlin.Result.success("pong $hello"));
  }
}
