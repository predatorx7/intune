package com.hdfc.flutter_plugins.intune_android.authentication

import com.hdfc.flutter_plugins.intune_android.IntuneFlutterApi
import com.microsoft.intune.mam.policy.MAMServiceAuthenticationCallback
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.suspendCancellableCoroutine
import java.util.logging.Level
import java.util.logging.Logger

/**
 * Implementation of the required callback for MAM integration.
 */
class MAMAuthenticationCallback(intuneFlutterApi: IntuneFlutterApi) : MAMServiceAuthenticationCallback {
    private val mIntuneFlutterApi: IntuneFlutterApi

    init {
        mIntuneFlutterApi = intuneFlutterApi
    }

     @OptIn(ExperimentalCoroutinesApi::class)
     suspend fun acquireTokenSilent(
         upn: String,
         aadId: String,
         scopes: List<String>,
     ): String? = suspendCancellableCoroutine { continuation ->
        mIntuneFlutterApi.acquireTokenSilent(upn, aadId, scopes) { result: String? ->
            continuation.resume(result) {
                LOGGER.log(Level.SEVERE, "Failed to send token '$result' for MAM Service", it)
            }
        }
    }

    override fun acquireToken(upn: String, aadId: String, resourceId: String): String? {
        try {
            // Create the MSAL scopes by using the default scope of the passed in resource id.
            val scopes = arrayListOf("$resourceId/.default")
            val accessToken = runBlocking { acquireTokenSilent(upn, aadId, scopes) }
            if (accessToken != null) return accessToken
        } catch (e: Throwable) {
            LOGGER.log(Level.SEVERE, "Failed to get token for MAM Service", e)
            return null
        }
        LOGGER.warning("Failed to get token for MAM Service - no result from MSAL")
        return null
    }

    companion object {
        private val LOGGER = Logger.getLogger(MAMAuthenticationCallback::class.java.name)
    }
}