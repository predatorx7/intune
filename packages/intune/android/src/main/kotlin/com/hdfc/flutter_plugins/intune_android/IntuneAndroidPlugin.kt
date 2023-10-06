/*
 * Copyright 2023, Mushaheed Syed. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

package com.hdfc.flutter_plugins.intune_android

import android.app.Activity
import android.util.Log
import com.microsoft.intune.mam.client.strict.MAMStrictMode
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/** IntuneAndroidPlugin */
class IntuneAndroidPlugin : FlutterPlugin, ActivityAware {
    companion object {
        const val TAG = "IntuneAndroidPlugin"
    }

    private var api: IntuneApiImpl? = null
    private var activity: Activity? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        try {
            // recommended in onCreate of activity. And should not be used in production builds.
            // MAMStrictMode.enable()
            Log.i(TAG, "Setting up IntuneAndroidPlugin")
            val messenger = flutterPluginBinding.binaryMessenger
            val reply = IntuneReply(messenger)
            api = IntuneApiImpl(
                    flutterPluginBinding.applicationContext,
                    reply,
            )
            IntuneApi.setUp(
                    messenger,
                    api,
            )
            if (activity != null) {
                api!!.setActivity(null)
            }
            Log.i(TAG, "IntuneAndroidPlugin setup completed")
        } catch (ex: Error) {
            Log.e(TAG, "Received exception while setting up IntuneAndroidPlugin", ex)
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        IntuneApi.setUp(binding.binaryMessenger, null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        api?.setActivity(binding.activity)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
        api?.setActivity(null)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        api?.setActivity(binding.activity)
    }

    override fun onDetachedFromActivity() {
        activity = null
        api?.setActivity(null)
    }
}
