package com.hdfc.flutter_plugins.intune_android

import android.util.Log
import com.hdfc.flutter_plugins.intune_android.msal.MSALFlutterClient
import com.microsoft.identity.client.exception.MsalException
import io.flutter.plugin.common.BinaryMessenger

class IntuneReply(messenger: BinaryMessenger) {
    private val intuneFlutterApi: IntuneFlutterApi

    init {
        intuneFlutterApi = IntuneFlutterApi(messenger)
    }

    fun onMsalException(exception: MsalException) {
        intuneFlutterApi.onMsalException(MSALApiException(
                exception.errorCode,
                exception.localizedMessage ?: exception.message,
                exception.stackTraceToString(),
        )) {
            Log.d(MSALFlutterClient.TAG, "Sent error code to flutter")
        }
    }


    fun onEnrollmentNotification(enrollmentResult: String) {
        Log.d(IntuneAndroidPlugin.TAG, "Enrollment Receiver $enrollmentResult")
        intuneFlutterApi.onEnrollmentNotification(enrollmentResult) {
            Log.d(IntuneAndroidPlugin.TAG, "Enrollment Receiver result \"$enrollmentResult\" sent to flutter")
        }
    }

    fun onUnexpectedEnrollmentNotification() {
        Log.d(IntuneAndroidPlugin.TAG, "Enrollment Receiver: Unexpected notification type received")
        intuneFlutterApi.onUnexpectedEnrollmentNotification {
            Log.d(IntuneAndroidPlugin.TAG, "onUnexpectedEnrollmentNotification sent to flutter")
        }
    }
}