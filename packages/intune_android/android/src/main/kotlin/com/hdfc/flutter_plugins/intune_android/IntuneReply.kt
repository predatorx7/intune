package com.hdfc.flutter_plugins.intune_android

import android.util.Log
import com.microsoft.identity.client.IAuthenticationResult
import com.microsoft.identity.client.exception.MsalException
import com.microsoft.identity.client.exception.MsalIntuneAppProtectionPolicyRequiredException
import com.microsoft.identity.client.exception.MsalUserCancelException
import io.flutter.plugin.common.BinaryMessenger

class IntuneReply(messenger: BinaryMessenger) {
    companion object {
        const val TAG = "IntuneReply"
    }

    private val intuneFlutterApi: IntuneFlutterApi

    init {
        intuneFlutterApi = IntuneFlutterApi(messenger)
    }

    fun onMsalException(exception: MsalException?) {
        if (exception == null) {
            return onErrorType(MSALErrorType.UNKNOWN)
        }
        Log.e("msal_auth.onError", "authentication failed", exception)
        when (exception) {
            is MsalIntuneAppProtectionPolicyRequiredException -> {
                // Note: An app that has enabled APP CA with Policy Assurance would need to pass these values to `remediateCompliance`.
                // For more information, see https://docs.microsoft.com/en-us/mem/intune/developer/app-sdk-android#app-ca-with-policy-assurance
                val upn = exception.accountUpn
                val aadid = exception.accountUserId
                val tenantId = exception.tenantId
                val authorityURL = exception.authorityUrl

                // The user cannot be considered "signed in" at this point, so don't save it to the settings.
                // val mUserAccount = AppAccount(upn, aadid, tenantId, authorityURL)

                Log.i(TAG, "MsalIntuneAppProtectionPolicyRequiredException received.")
                Log.i(
                        TAG,
                        "Data from broker: UPN: $upn; AAD ID: $aadid; Tenant ID: $tenantId; Authority: $authorityURL",
                )
                onErrorType(MSALErrorType.INTUNEAPPPROTECTIONPOLICYREQUIRED)
            }
            is MsalUserCancelException -> {
                onErrorType(MSALErrorType.USERCANCELLEDSIGNINREQUEST)
            }
            else -> {
                onErrorType(MSALErrorType.UNKNOWN)
            }
        }
        intuneFlutterApi.onMsalException(MSALApiException(
                exception.errorCode,
                exception.localizedMessage ?: exception.message,
                exception.stackTraceToString(),
        )) {
            Log.d(TAG, "Sent error code to flutter")
        }
    }

    fun onErrorType(errorType: MSALErrorType) {
        intuneFlutterApi.onErrorType(MSALErrorResponse(errorType)) {
            Log.d(TAG, "Sent error type to flutter")
        }
    }

    fun onEnrollmentNotification(enrollmentResult: MAMEnrollmentStatus?) {
        Log.d(IntuneAndroidPlugin.TAG, "Enrollment Receiver $enrollmentResult")
        intuneFlutterApi.onEnrollmentNotification(MAMEnrollmentStatusResult(enrollmentResult)) {
            Log.d(IntuneAndroidPlugin.TAG, "Enrollment Receiver result \"$enrollmentResult\" sent to flutter")
        }
    }

    fun onUnexpectedEnrollmentNotification() {
        Log.d(IntuneAndroidPlugin.TAG, "Enrollment Receiver: Unexpected notification type received")
        intuneFlutterApi.onUnexpectedEnrollmentNotification {
            Log.d(IntuneAndroidPlugin.TAG, "onUnexpectedEnrollmentNotification sent to flutter")
        }
    }

    private fun onUserAuthenticationDetails(details: MSALUserAuthenticationDetails) {
        intuneFlutterApi.onUserAuthenticationDetails(details) {
            Log.d(IntuneAndroidPlugin.TAG, "onUserAuthenticationDetails sent to flutter")
        }
    }

    fun onSignOut() {
        intuneFlutterApi.onSignOut {
            Log.d(IntuneAndroidPlugin.TAG, "onSignOut sent to flutter")
        }
    }

    fun onMSALAuthenticationResult(result: IAuthenticationResult) {
        val account = result.account
        val upn = account.username
        val aadId = account.id
        val tenantId = account.tenantId
        val authorityURL = account.authority
        val message = "Authentication succeeded for user $upn"
        Log.i("msal_auth", message)

        return onUserAuthenticationDetails(MSALUserAuthenticationDetails(
                accessToken = result.accessToken,
                authenticationScheme = result.authenticationScheme,
                scope = result.scope.toList(),
                expiresOnISO8601 = result.expiresOn.toInstant().toString(),
                account = MSALUserAccount(
                        authority = authorityURL,
                        username = upn,
                        tenantId = tenantId,
                        id = aadId,
                ),
        ))
    }
}
