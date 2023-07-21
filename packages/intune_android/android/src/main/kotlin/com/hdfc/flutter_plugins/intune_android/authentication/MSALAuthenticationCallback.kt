package com.hdfc.flutter_plugins.intune_android.authentication

import android.content.Context
import com.hdfc.flutter_plugins.intune_android.IntuneFlutterApi
import com.hdfc.flutter_plugins.intune_android.authentication.AppSettings.saveAccount
import com.microsoft.identity.client.IAuthenticationResult
import com.microsoft.identity.client.exception.MsalException
import com.microsoft.identity.client.exception.MsalIntuneAppProtectionPolicyRequiredException
import com.microsoft.identity.client.exception.MsalUserCancelException
import android.util.Log
import com.hdfc.flutter_plugins.intune_android.IntuneReply
import com.microsoft.intune.mam.policy.MAMEnrollmentManager

class MSALAuthenticationCallback(private val context: Context, private val reply: IntuneReply, private val enrollmentManager: MAMEnrollmentManager) : com.microsoft.identity.client.AuthenticationCallback {

    override fun onError(exc: MsalException?) {
        Log.e("msal_auth.onError", "authentication failed", exc)
        if (exc is MsalIntuneAppProtectionPolicyRequiredException) {
            val appException = exc

            // Note: An app that has enabled APP CA with Policy Assurance would need to pass these values to `remediateCompliance`.
            // For more information, see https://docs.microsoft.com/en-us/mem/intune/developer/app-sdk-android#app-ca-with-policy-assurance
            val upn = appException.accountUpn
            val aadid = appException.accountUserId
            val tenantId = appException.tenantId
            val authorityURL = appException.authorityUrl

            // The user cannot be considered "signed in" at this point, so don't save it to the settings.
            val mUserAccount = AppAccount(upn, aadid, tenantId, authorityURL)
            val message = "Intune App Protection Policy required."
//            showMessage(message)
            Log.i("msal_auth", "MsalIntuneAppProtectionPolicyRequiredException received.")
            Log.i("msal_auth", String.format(
                    "Data from broker: UPN: %s; AAD ID: %s; Tenant ID: %s; Authority: %s",
                    upn, aadid, tenantId, authorityURL,
            ))
        } else if (exc is MsalUserCancelException) {
//            showMessage("User cancelled sign-in request")
        } else {
//            showMessage("Exception occurred - check logcat")
        }
        if (exc != null) {
            reply.onMsalException(exc)
        }
    }

    override fun onSuccess(result: IAuthenticationResult) {
        val account = result.account
        val upn = account.username
        val aadId = account.id
        val tenantId = account.tenantId
        val authorityURL = account.authority
        val message = "Authentication succeeded for user $upn"
        Log.i("msal_auth", message)

        // Save the user account in the settings, since the user is now "signed in".
        val mUserAccount = AppAccount(upn, aadId, tenantId, authorityURL)
        saveAccount(context, mUserAccount)

        // Register the account for MAM.
        enrollmentManager.registerAccountForMAM(upn, aadId, tenantId, authorityURL)
//        displayMainView()
    }

    override fun onCancel() {
//        showMessage("User cancelled auth attempt")
    }
}
